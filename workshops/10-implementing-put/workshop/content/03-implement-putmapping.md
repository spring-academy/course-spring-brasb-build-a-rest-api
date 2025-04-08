Following the pattern we've used this far in our Controller, let's implement the `PUT` endpoint in our `CashCardController`.

1. Add a minimal `@PutMapping`.

   Edit `src/main/java/example/cashcard/CashCardController.java`, and add the `PUT` endpoint.

   ```editor:open-file
   file: ~/exercises/src/main/java/example/cashcard/CashCardController.java
   ```

   ```java
   @PutMapping("/{requestedId}")
   private ResponseEntity<Void> putCashCard(@PathVariable Long requestedId, @RequestBody CashCard cashCardUpdate) {
       // just return 204 NO CONTENT for now.
       return ResponseEntity.noContent().build();
   }
   ```

   This Controller endpoint is fairly self-explanatory:

   - The `@PutMapping` supports the `PUT` verb and supplies the target `requestedId`.
   - The `@RequestBody` contains the updated `CashCard` data.
   - Return an HTTP `204 NO_CONTENT` response code for now, just to get started.

1. Run the tests.

   What do you think will happen?

   Let's run them now.

   ```dashboard:open-dashboard
   name: Terminal
   ```

   ```shell
   ...
   CashCardApplicationTests > shouldUpdateAnExistingCashCard() PASSED
   ...
   BUILD SUCCESSFUL in 6s
   ```

   They pass!

   But, that isn't very satisfying, is it?

   We haven't updated the `CashCard`!

   Let's do that next.

1. Enhance the test to verify a successful update.

   Similar to other verifications we've performed in our test suite, let's assert that the update was successful.

   ```editor:select-matching-text
   file: ~/exercises/src/test/java/example/cashcard/CashCardApplicationTests.java
   text: "shouldUpdateAnExistingCashCard"
   description:
   ```

   ```java
   void shouldUpdateAnExistingCashCard() {
     ...
     assertThat(response.getStatusCode()).isEqualTo(HttpStatus.NO_CONTENT);

     ResponseEntity<String> getResponse = restTemplate
             .withBasicAuth("sarah1", "abc123")
             .getForEntity("/cashcards/99", String.class);
     assertThat(getResponse.getStatusCode()).isEqualTo(HttpStatus.OK);
     DocumentContext documentContext = JsonPath.parse(getResponse.getBody());
     Number id = documentContext.read("$.id");
     Double amount = documentContext.read("$.amount");
     assertThat(id).isEqualTo(99);
     assertThat(amount).isEqualTo(19.99);
   }
   ```

1. Understand the test updates.

   - ```java
     ResponseEntity<String> getResponse = restTemplate
         .withBasicAuth("sarah1", "abc123")
         .getForEntity("/cashcards/99", String.class);
     ```

     Here, we fetch `CashCard` `99` again, so we can verify that it was updated.

   - ```java
     ...
     assertThat(id).isEqualTo(99);
     assertThat(amount).isEqualTo(19.99);
     ```

     Next, we assert that we've retrieved the correct `CashCard` -- `99` -- and that its `amount` was successfully updated to `19.99`.

1. Run the tests.

   Our expectations are legit, but we haven't updated the `CashCardController` to match.

   The test should fail with valuable error messages, right?

   Let's run the tests now.

   ```dashboard:open-dashboard
   name: Terminal
   ```

   ```shell
   CashCardApplicationTests > shouldUpdateAnExistingCashCard() FAILED
    org.opentest4j.AssertionFailedError:
    expected: 19.99
     but was: 123.45
   ```

   Excellent! We expect an amount of `19.99`, but without any changes we're still returning `123.45`.

   Let's update the Controller.

1. Update `CashCardController` to perform the data update.

   As with our other handler methods, let's ensure that we guarantee that only the `CashCard` `owner` can perform the updates -- the logged-in `Principal` must be the same as the Cash Card `owner`:

   ```editor:select-matching-text
   file: ~/exercises/src/main/java/example/cashcard/CashCardController.java
   text: "putCashCard"
   description:
   ```

   ```java
   @PutMapping("/{requestedId}")
   private ResponseEntity<Void> putCashCard(@PathVariable Long requestedId, @RequestBody CashCard cashCardUpdate, Principal principal) {
       CashCard cashCard = cashCardRepository.findByIdAndOwner(requestedId, principal.getName());
       CashCard updatedCashCard = new CashCard(cashCard.id(), cashCardUpdate.amount(), principal.getName());
       cashCardRepository.save(updatedCashCard);
       return ResponseEntity.noContent().build();
   }
   ```

1. Understand the `CashCardController` updates.

   We're following a similar pattern as in the `@PostMapping createCashCard()` endpoint.

   - ```java
     @PutMapping("/{requestedId}")
     private ResponseEntity<Void> putCashCard(@PathVariable Long requestedId, @RequestBody CashCard cashCardUpdate, Principal principal) {
     ```

     We've added the `Principal` as a method argument, provided automatically by Spring Security.

     Thanks once again, Spring Security!

   - ```java
     cashCardRepository.findByIdAndOwner(requestedId, principal.getName());
     ```

     Here, we scope our retrieval of the `CashCard` to the submitted `requestedId` and `Principal` (provided by Spring Security) to ensure only the authenticated, authorized `owner` may update this `CashCard`.

   - ```java
     CashCard updatedCashCard = new CashCard(cashCard.id(), cashCardUpdate.amount(), principal.getName());
     cashCardRepository.save(updatedCashCard);
     ```

     Finally, build a `CashCard` with updated values and save it.

   That was a lot! Let's run the tests and assess where we're at.

1. Run the tests.

   ```dashboard:open-dashboard
   name: Terminal
   ```

   ```shell
   ...
   CashCardApplicationTests > shouldUpdateAnExistingCashCard() PASSED
   ...
   BUILD SUCCESSFUL in 6s
   ```

   They pass!

We've successfully implemented updating a `CashCard`.

Now let's turn our attention to security. Specifically, What happens if we attempt to update a `CashCard` that we don't own, or one which does not exist?

Let's test those scenarios next.
