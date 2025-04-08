At this point, you may ask yourself, "Are we done?" You're the best person to answer that question! If you want, take a couple minutes to refresh yourself with the accompanying lesson in order to see if we've tested and implemented every aspect of the API contract for DELETE.

OK, that was time well-spent, wasn't it? That's right - There's one more case that we have yet to test: What if the user attempts to delete a Cash Card owned by someone else? We decided in the associated lesson that the response should be `404 NOT FOUND` in this case. Thats enough information for us to write a test for that case:

1. In `CashCardApplicationTests.java`, add the following test method at the end of the class:

   ```editor:open-file
   file: ~/exercises/src/test/java/example/cashcard/CashCardApplicationTests.java
   ```

   ```java
   @Test
   void shouldNotAllowDeletionOfCashCardsTheyDoNotOwn() {
       ResponseEntity<Void> deleteResponse = restTemplate
               .withBasicAuth("sarah1", "abc123")
               .exchange("/cashcards/102", HttpMethod.DELETE, null, Void.class);
       assertThat(deleteResponse.getStatusCode()).isEqualTo(HttpStatus.NOT_FOUND);
   }
   ```

1. Run the test.

   Do you think the test will pass? Take a moment to predict the outcome, then run the test.

   ```dashboard:open-dashboard
   name: Terminal
   ```

   ```shell
   [~/exercises] $ ./gradlew test
   ...
   BUILD SUCCESSFUL in 8s
   ```

   They all passed! That's great news.

   - We've written a test for a specific case in our API.
   - The test passed without any code changes!

   Now, let's consider a question which may have occurred to you: Why do I need that test, since it passes without having to make any code changes? Isn't the purpose of TDD to use tests to guide the implementation of the application? If that's the case, why did I bother to write that test?

   Answers:

   - Yes, that is _one_ of many benefits that TDD provides: A process to guide the creation of code in order to arrive at a desired outcome.
   - Tests themselves, though, have another purpose, separate from TDD: Tests are a powerful safety net to enforce correctness. Since the test you just wrote tests a different case than those already written, it provides value. If someone were to make a code change which caused this new test to fail, then you'll have caught the error before it could become an issue! Yay for Tests.

1. One more test.

   But wait, you say!

   Shouldn't we test that the record that we tried to delete still exists in the database - that it didn't get deleted?

   Yes, that's a valid test. Thanks for mentioning it!

   Add the following code to the test method, to verify that the record you tried unsuccessfully to delete is still there:

   ```editor:select-matching-text
   file: ~/exercises/src/test/java/example/cashcard/CashCardApplicationTests.java
   text: "shouldNotAllowDeletionOfCashCardsTheyDoNotOwn"
   description:
   ```

   ```java
   void shouldNotAllowDeletionOfCashCardsTheyDoNotOwn() {
    ...
       // Add this code at the end of the test method:
       ResponseEntity<String> getResponse = restTemplate
               .withBasicAuth("kumar2", "xyz789")
               .getForEntity("/cashcards/102", String.class);
       assertThat(getResponse.getStatusCode()).isEqualTo(HttpStatus.OK);
   }
   ```

   Do you think the test will pass? Of course it will! (right?)

1. Run the test

   One last test run!

   Please run all the tests and ensure that they pass.

   ```dashboard:open-dashboard
   name: Terminal
   ```

   ```shell
   [~/exercises] $ ./gradlew test
   ...
   BUILD SUCCESSFUL in 6s
   ```

We're the best!
