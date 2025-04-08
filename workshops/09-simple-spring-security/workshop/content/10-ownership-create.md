We have one more remaining security hole: creating `CashCards`.

The authenticated, authorized Principal should be used as the `owner` when creating a new `CashCard`.

Question: What would happen if we automatically used the submitted `owner` value?

Answer: We risk allowing users to create `CashCards` for _someone else_!

Let's ensure that only the authenticated, authorized Principal owns the `CashCards` they are creating.

1. Update the `POST` test.

   To prove that we don't need to submit an `owner`, let's use `null` as the `owner` for the `CashCard`.

   ```editor:select-matching-text
   file: ~/exercises/src/test/java/example/cashcard/CashCardApplicationTests.java
   text: "shouldCreateANewCashCard"
   description:
   ```

   ```java
   void shouldCreateANewCashCard() {
     CashCard newCashCard = new CashCard(null, 250.00, null);
     ...
   ```

1. Run the tests.

   What do you think will happen when we run the tests? They'll likely fail, but can you guess why?

   To help us out, pass in the `--info` flag when running the tests so we can get a bit more insight into what's going on:

   ```dashboard:open-dashboard
   name: Terminal
   ```

   ```shell
   [~/exercises] $ ./gradlew test --info
   ...
   CashCardApplicationTests > shouldCreateANewCashCard() FAILED
    org.opentest4j.AssertionFailedError:
    expected: 201 CREATED
     but was: 403 FORBIDDEN
   ```

   You'll see that the tests fail with a `403 FORBIDDEN` error.

   But why? Searching through the stacktrace we find the following:

   ```shell
   DbActionExecutionException: Failed to execute InsertRoot{entity=CashCard[id=null, amount=250.0, owner=null], idValueSource=GENERATED}] with root cause

   org.h2.jdbc.JdbcSQLIntegrityConstraintViolationException: NULL not allowed for column "OWNER"; SQL statement:
    INSERT INTO "CASH_CARD" ("AMOUNT", "OWNER") VALUES (?, ?) [23502-214]
   ```

   Interesting! It seems that we tried to create a new `CASH_CARD` in the database, but `NULL` is not allowed as the `OWNER`, which is exactly what we passed in for the `OWNER` in our test.

   Sure enough, more clues can be found in the `main/resources/schema.sql`, which sets up our database tables:

   ```editor:open-file
   file: ~/exercises/src/main/resources/schema.sql
   ```

   ```sql
   CREATE TABLE cash_card
   (
     ...
     OWNER    VARCHAR(256) NOT NULL
   );
   ```

   What does this all mean? It means that even though the tests (and users) see a `403 FORBIDDEN` error, the application is actually _crashing!_

   So, why aren't we seeing a `500 INTERNAL_SERVER_ERROR`, which is more appropriate for a crashing server?

   ### Learning Moment: Spring Security and Error Handling

   Our Controller is returning `403 FORBIDDEN` instead of an `500 INTERNAL_SERVER_ERROR` because Spring Security is automatically implementing a best practice regarding how errors are handled by Spring Web.

   It's important to understand that any information returned from our application might be useful to a bad actor attempting to violate our application's security. For example: knowledge about actions that causes our application to crash -- a `500 INTERNAL_SERVER_ERROR`.

   In order to avoid _"leaking"_ information about our application, Spring Security has configured Spring Web to return a generic `403 FORBIDDEN` in most error conditions. If almost everything results in a `403 FORBIDDEN` response then an attacker doesn't really know what's going on.

   Now that we understand what's happening, let's get the Controller to properly handle this situation.

1. Update the `POST` endpoint in the Controller.

   Once again we'll use the provided `Principal` to ensure that the correct `owner` is saved with the new `CashCard`.

   ```editor:select-matching-text
   file: ~/exercises/src/main/java/example/cashcard/CashCardController.java
   text: "createCashCard"
   description:
   ```

   ```java
   @PostMapping
   private ResponseEntity<Void> createCashCard(@RequestBody CashCard newCashCardRequest, UriComponentsBuilder ucb, Principal principal) {
       CashCard cashCardWithOwner = new CashCard(null, newCashCardRequest.amount(), principal.getName());
       CashCard savedCashCard = cashCardRepository.save(cashCardWithOwner);
       ...
   ```

1. Run the tests.

   Thankfully, everything passes again!

   ```dashboard:open-dashboard
   name: Terminal
   ```

   ```shell
   CashCardApplicationTests > shouldCreateANewCashCard() PASSED
   ...
   BUILD SUCCESSFUL in 7s
   ```

Now only the authenticated, authorized Principal is used to create a `CashCard`.

Security for the win!
