You're finally ready to use the `CashCardRepository`!

1. Find the `CashCard` using `findById`.

   The `CrudRepository` interface provides [many helpful methods](https://docs.spring.io/spring-data/commons/docs/current/api/org/springframework/data/repository/CrudRepository.html#findById-ID-), including `findById(ID id)`.

   Update the `CashCardController` to utilize this method on the `CashCardRepository` and update the logic; be sure to `import java.util.Optional;`

   ```editor:select-matching-text
   file: ~/exercises/src/main/java/example/cashcard/CashCardController.java
   text: "findById"
   description:
   ```

   ```java
   import java.util.Optional;
   ...
   @GetMapping("/{requestedId}")
   private ResponseEntity<CashCard> findById(@PathVariable Long requestedId) {
       Optional<CashCard> cashCardOptional = cashCardRepository.findById(requestedId);
       if (cashCardOptional.isPresent()) {
           return ResponseEntity.ok(cashCardOptional.get());
       } else {
           return ResponseEntity.notFound().build();
       }
   }
   ```

1. Understand the changes.

   We've just altered the `CashCardController.findById` in several important ways.

   - ```java
     Optional<CashCard> cashCardOptional = cashCardRepository.findById(requestedId);
     ```

     We're calling `CrudRepository.findById`, which returns an `Optional`. This smart object _might or might not_ contain the `CashCard` for which we're searching. Learn more about `Optional` [here](https://docs.oracle.com/javase/8/docs/api/java/util/Optional.html).

   - ```java
     cashCardOptional.isPresent()
     ```

     and

     ```java
     cashCardOptional.get()
     ```

     This is how you determine if `findById` did or did not find the `CashCard` with the supplied `id`.

     If `cashCardOptional.isPresent()` is `true`, then the repository successfully found the `CashCard` and we can retrieve it with `cashCardOptional.get()`.

     If not, the repository has not found the `CashCard`.

1. Run the tests.

   We can see that the tests fail with a `500 INTERNAL_SERVER_ERROR`.

   ```dashboard:open-dashboard
   name: Terminal
   ```

   ```shell
   CashCardApplicationTests > shouldReturnACashCardWhenDataIsSaved() FAILED
      org.opentest4j.AssertionFailedError:
      expected: 200 OK
      but was: 500 INTERNAL_SERVER_ERROR
   ```

   This means the Cash Card API "crashed".

   We need a bit more information...

   Let's temporarily update the test output section of `build.gradle` with `showStandardStreams = true`, so that our test runs will produce _a lot_ more output.

   ```editor:select-matching-text
   file: ~/exercises/build.gradle
   text: "showStandardStreams"
   description:
   ```

   ```groovy
   test {
    testLogging {
        events "passed", "skipped", "failed" //, "standardOut", "standardError"

        showExceptions true
        exceptionFormat "full"
        showCauses true
        showStackTraces true

        // Change from false to true
        showStandardStreams = true
    }
   }
   ```

1. Rerun the tests.

   Note that the test output is much more verbose.

   Searching through the output we find these failures:

   ```dashboard:open-dashboard
   name: Terminal
   ```

   ```shell
   org.h2.jdbc.JdbcSQLSyntaxErrorException: Table "CASH_CARD" not found (this database is empty); SQL statement:
    SELECT "CASH_CARD"."ID" AS "ID", "CASH_CARD"."AMOUNT" AS "AMOUNT" FROM "CASH_CARD" WHERE "CASH_CARD"."ID" = ? [42104-214]
   ```

   The cause of our test failures is clear: `Table "CASH_CARD" not found` means we don't have a database nor any data.
