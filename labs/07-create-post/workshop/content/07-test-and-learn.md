1. Run the tests.

   They pass!

   ```dashboard:open-dashboard
   name: Terminal
   ```

   ```shell
   BUILD SUCCESSFUL in 7s
   ```

   The new `CashCard` was created, and we used the URI supplied in the `Location` response header to retrieve the newly created resource.

1. Add more test assertions.

   If you'd like, add more test assertions for the new `id` and `amount` to solidify your learning.

   ```editor:select-matching-text
   file: ~/exercises/src/test/java/example/cashcard/CashCardApplicationTests.java
   text: "shouldCreateANewCashCard"
   description:
   ```

   ```java
   ...
   assertThat(getResponse.getStatusCode()).isEqualTo(HttpStatus.OK);

   // Add assertions such as these
   DocumentContext documentContext = JsonPath.parse(getResponse.getBody());
   Number id = documentContext.read("$.id");
   Double amount = documentContext.read("$.amount");

   assertThat(id).isNotNull();
   assertThat(amount).isEqualTo(250.00);
   ```

   The additions verify that the new `CashCard.id` is not null, and the newly created `CashCard.amount` is 250.00, just as we specified at creation time.

### Learning Moment

Earlier we stated that the database (via the Repository) would manage creating all database `id` values for us.

What would happen if we provided an `id` for our new, unsaved `CashCard`?

Let's find out.

1. Update the test to submit a `CashCard.id`

   Change the `id` submitted from `null` to one that does not exist, such as `44L`.

   ```editor:select-matching-text
   file: ~/exercises/src/test/java/example/cashcard/CashCardApplicationTests.java
   text: "shouldCreateANewCashCard"
   description:
   ```

   ```java
   @Test
   void shouldCreateANewCashCard() {
      CashCard newCashCard = new CashCard(44L, 250.00);
      ...
   ```

   In addition, edit `build.gradle` to enable more verbose test output, which will give us more insight into what happens when we run the tests.

   ```editor:select-matching-text
   file: ~/exercises/build.gradle
   text: "showStandardStreams"
   description:
   ```

   ```groovy
   test {
     testLogging {
       ...
       // Set to `true` for more detailed logging.
       showStandardStreams = true
     }
   }
   ```

1. Run the tests.

   The test fails, but not in the way you might expect.

   ```dashboard:open-dashboard
   name: Terminal
   ```

   ```shell
   [~/exercises] $ ./gradlew test
   ...
   CashCardApplicationTests > shouldCreateANewCashCard() FAILED
       org.opentest4j.AssertionFailedError:
       expected: 200 OK
        but was: 404 NOT_FOUND
   ```

   Look closely at which assertion failed. It's the one checking the `GET` response, not the `POST` response — the `POST` still returned `201 CREATED` with a `Location` header. It's only when the test follows that `Location` header that things fall apart.

   Let's find out why.

1. Understand what happened.

   The `POST` request appeared to succeed, yet nothing was actually saved. Interesting! Can you guess why?

   Supplying an `id` tells Spring Data JDBC that we're asking it to **update** an existing `CashCard`, not create a new one. Since no `CashCard` with `id` of `44` exists yet, that "update" matches zero rows in the database.

   `cashCardRepository.save()` doesn't treat this as an error: no row is written, but no exception is thrown either. The controller has no way of knowing anything went wrong, so it still returns `201 CREATED` with a `Location` header pointing at `/cashcards/44`.

   The problem only becomes visible one step later, when the test follows that `Location` header with a `GET` request: there's no `CashCard` with `id` of `44` in the database, so the response is `404 NOT_FOUND`.

   Supplying an `id` to `cashCardRepository.save` is supported when an _update_ is performed on an existing resource.

   We'll cover this scenario in a later lab focused on updating an existing `CashCard`.

In this Learning Moment you learned that the API requires that you _not_ supply a `CashCard.id` when creating a new `CashCard`. Doing so doesn't cause an obvious crash — it lets the create request report success while silently saving nothing.

Should we validate that requirement in the API? You betcha! Again, stay tuned for how to do that in a future lesson.
