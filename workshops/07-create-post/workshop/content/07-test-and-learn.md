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

   In addition, edit `build.gradle` to enable more verbose test output, which will help us identify the upcoming test failure.

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

   When we run the test we see that the the API crashes with a `500` status code.

   ```dashboard:open-dashboard
   name: Terminal
   ```

   ```shell
   [~/exercises] $ ./gradlew test
   ...
   expected: 201 CREATED
    but was: 500 INTERNAL_SERVER_ERROR
   ```

   Let's find out why the test is failing.

1. Find and understand the database failure.

   Search the test output for the following message:

   ```shell
   Failed to update entity [CashCard[id=44, amount=250.0]]. Id [44] not found in database.
   ```

   The Repository is trying to **_find `CashCard` with `id` of `44` and throwing an error when it cannot find it._** Interesting! Can you guess why?

   Supplying an `id` to `cashCardRepository.save` is supported when an _update_ is performed on an existing resource.

   We'll cover this scenario in a later lab focused on updating an existing `CashCard`.

In this Learning Moment you learned that the API requires that you _not_ supply a `CashCard.id` when creating a new `CashCard`.

Should we validate that requirement in the API? You betcha! Again, stay tuned for how to do that in a future lesson.
