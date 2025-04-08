We've got two remaining scenarios to test: The case where a user tries to update a Cash Card which doesn't exist; and the case where a user tries to update a Cash Card they don't own.

## Case 1: Attempt to update a Cash Card which does not exist.

Let's start with the first of those two cases. Start by adding a test.

1. Try to update a Cash Card that doesn't exist.

   Add the following test to `CashCardApplicationTests`.

   ```editor:open-file
   file: ~/exercises/src/test/java/example/cashcard/CashCardApplicationTests.java
   ```

   ```java
   @Test
   void shouldNotUpdateACashCardThatDoesNotExist() {
       CashCard unknownCard = new CashCard(null, 19.99, null);
       HttpEntity<CashCard> request = new HttpEntity<>(unknownCard);
       ResponseEntity<Void> response = restTemplate
               .withBasicAuth("sarah1", "abc123")
               .exchange("/cashcards/99999", HttpMethod.PUT, request, Void.class);
       assertThat(response.getStatusCode()).isEqualTo(HttpStatus.NOT_FOUND);
   }
   ```

   Here we'll attempt to update a Cash Card with ID `99999`, which doesn't exist.

   The test should expect a generic `404 NOT_FOUND` error.

2. Run the tests.

   Before running the test, guess what the result will be.

   OK, have you made your guess? Now, run the test to verify your hypothesis.

   ```dashboard:open-dashboard
   name: Terminal
   ```

   ```shell
   ...
   CashCardApplicationTests > shouldNotUpdateACashCardThatDoesNotExist() FAILED
    org.opentest4j.AssertionFailedError:
    expected: 404 NOT_FOUND
     but was: 403 FORBIDDEN
   ```

   Well that's...interesting. Why did we get a `403 FORBIDDEN`?

   Before we run them again, let's edit `build.gradle` to enable additional test output.

   ```editor:select-matching-text
   file: ~/exercises/build.gradle
   text: "showStandardStreams"
   description:
   ```

   ```groovy
   test {
    testLogging {
        ...
        // Change to `true` for more verbose test output
        showStandardStreams = true
    }
   }
   ```

   After rerunning the tests, search the output for the following:

   ```dashboard:open-dashboard
   name: Terminal
   ```

   ```shell
   CashCardApplicationTests > shouldNotUpdateACashCardThatDoesNotExist() STANDARD_OUT
   ...
   java.lang.NullPointerException: Cannot invoke "example.cashcard.CashCard.id()" because "cashCard" is null
   ```

   A `NullPointerException`! Why a `NullPointerException`?

   Looking at `CashCardController.putCashCard`, we can see that if we don't find the `cashCard`, then method calls to `cashCard` will result in a `NullPointerException`. That makes sense.

   But why is a `NullPointerException` thrown in our Controller resulting in a `403 FORBIDDEN` instead of a `500 INTERNAL_SERVER_ERROR`, given the server "crashed?"

   Remember: We learned in the Spring Security module that in order to avoid "leaking" information about our application, Spring Security has configured Spring Web to return a generic `403 FORBIDDEN` in most error conditions. Thanks again, Spring Security!

   Now that we understand what's happening, let's fix it.

3. Don't crash.

   Though we're thankful to Spring Security, our application shouldn't crash - we shouldn't allow our code to throw a `NullPointerException`. Instead, we should handle the condition when `cashCard == null`, and return a generic `404 NOT_FOUND` HTTP response.

   Update `CashCardController.putCashCard` to return `404 NOT_FOUND` if no existing `CashCard` is found.

   ```editor:select-matching-text
   file: ~/exercises/src/main/java/example/cashcard/CashCardController.java
   text: "putCashCard"
   description:
   ```

   ```java
   @PutMapping("/{requestedId}")
   private ResponseEntity<Void> putCashCard(@PathVariable Long requestedId, @RequestBody CashCard cashCardUpdate, Principal principal) {
       CashCard cashCard = cashCardRepository.findByIdAndOwner(requestedId, principal.getName());
       if (cashCard != null) {
           CashCard updatedCashCard = new CashCard(cashCard.id(), cashCardUpdate.amount(), principal.getName());
           cashCardRepository.save(updatedCashCard);
           return ResponseEntity.noContent().build();
       }
       return ResponseEntity.notFound().build();
   }
   ```

4. Run the tests.

   Our tests pass now that we're returning a `404` when no `CashCard` is found.

   ```dashboard:open-dashboard
   name: Terminal
   ```

   ```shell
   [~/exercises] $ ./gradlew test
   ...
   BUILD SUCCESSFUL in 6s
   ```

## Case 2: Attempt to update a Cash Card owned by someone else

1. Write a test for the remaining case.

   Let's write a test that asserts that `sarah1` isn't allowed to update one of `kumar2`'s Cash Cards.

   ```editor:open-file
   file: ~/exercises/src/test/java/example/cashcard/CashCardApplicationTests.java
   ```

   ```java
   @Test
   void shouldNotUpdateACashCardThatIsOwnedBySomeoneElse() {
       CashCard kumarsCard = new CashCard(null, 333.33, null);
       HttpEntity<CashCard> request = new HttpEntity<>(kumarsCard);
       ResponseEntity<Void> response = restTemplate
               .withBasicAuth("sarah1", "abc123")
               .exchange("/cashcards/102", HttpMethod.PUT, request, Void.class);
       assertThat(response.getStatusCode()).isEqualTo(HttpStatus.NOT_FOUND);
   }
   ```

2. Make a hypothesis about what the test result will be, then verify the hypothesis by running the test.

   ```dashboard:open-dashboard
   name: Terminal
   ```

   ```shell
   [~/exercises] $ ./gradlew test
   ...
   CashCardApplicationTests > shouldNotUpdateACashCardThatIsOwnedBySomeoneElse() PASSED
   ```

   Was your hypothesis correct?

   The test passed because the modification to the Controller that we made in the previous step - namely, to check for a `null` result when retrieving the existing Cash Card - also causes this test to pass. But to be sure of this diagnosis, let's do an experiment.

3. Verify the reason for the test success.

   Go ahead! Comment out the changes in the Controller, and run the tests again:

   ```editor:select-matching-text
   file: ~/exercises/src/main/java/example/cashcard/CashCardController.java
   text: "putCashCard"
   description:
   ```

   ```java
   @PutMapping("/{requestedId}")
   private ResponseEntity<Void> putCashCard(@PathVariable Long requestedId, @RequestBody CashCard cashCardUpdate, Principal principal) {
       CashCard cashCard = cashCardRepository.findByIdAndOwner(requestedId, principal.getName());
       // if (null != cashCard) {
           CashCard updatedCashCard = new CashCard(cashCard.id(), cashCardUpdate.amount(), principal.getName());
           cashCardRepository.save(updatedCashCard);
           return ResponseEntity.noContent().build();
       // }
       // return ResponseEntity.notFound().build();
   }
   ```

   ```dashboard:open-dashboard
   name: Terminal
   ```

   ```shell
   [~/exercises] $ ./gradlew test
   ...
   CashCardApplicationTests > shouldNotUpdateACashCardThatIsOwnedBySomeoneElse() FAILED
   org.opentest4j.AssertionFailedError:
   expected: 404 NOT_FOUND
    but was: 403 FORBIDDEN
   ...
   CashCardApplicationTests > shouldNotUpdateACashCardThatDoesNotExist() FAILED
   org.opentest4j.AssertionFailedError:
   expected: 404 NOT_FOUND
    but was: 403 FORBIDDEN
   ```

   We're back to the "crashing" state: Both tests result in `403 FORBIDDEN` because of the underlying `NullPointerException`.

4. Undo your experimental changes.

   Remember to un-comment the three lines in `CashCardController.putCashCard`

   ```editor:select-matching-text
   file: ~/exercises/src/main/java/example/cashcard/CashCardController.java
   text: "putCashCard"
   description:
   ```

   ```java
   @PutMapping("/{requestedId}")
   private ResponseEntity<Void> putCashCard(@PathVariable Long requestedId, @RequestBody CashCard cashCardUpdate, Principal principal) {
       CashCard cashCard = cashCardRepository.findByIdAndOwner(requestedId, principal.getName());
       if (null != cashCard) {
           CashCard updatedCashCard = new CashCard(cashCard.id(), cashCardUpdate.amount(), principal.getName());
           cashCardRepository.save(updatedCashCard);
           return ResponseEntity.noContent().build();
       }
       return ResponseEntity.notFound().build();
   }
   ```

### Learning Moment: Controversy Exists

At this point you may ask yourself: Should I write two different tests which act exactly the same with respect to a single change in the application code? And if I should, why?

One reason why you might wish to keep the two tests is that at some future time, someone might change the implementation of the controller in some way that causes the two tests to _actually act differently_.

After all, we're testing two different scenarios:

- A `CashCard` record with `id`=99999 **_does_** exist in the database.
- A `CashCard` record with `id`=99999 **_does not_** exist in the database.

The truth is that if you bring this up as a conversation topic, you might get different answers from different people under different circumstances. While that might be interesting to talk about, as developers of the Family Cash Card API, we do need to move on.

Acknowledging that opinions may differ, we'll make the choice to leave _both_ tests in place.
