Let's reinforce your usage of the Red, Green, Refactor development loop.

We've just completed several tests focused on updating an existing Cash Card.

Do we have any opportunities to simplify, reduce duplication, or otherwise refactor our code without changing behavior?

Continue on to address several refactoring opportunities.

### Simplify the Code

1. Remove the `Optional`.

   This might be controversial: Since we're not taking advantage of features of `Optional` in `CashCardController.findById`, and no other Controller methods use an `Optional`, let's simplify our code by removing it.

   Edit `CashCardController.findById` to remove the usage of the `Optional`:

   ```editor:select-matching-text
   file: ~/exercises/src/main/java/example/cashcard/CashCardController.java
   text: "findById"
   description:
   ```

   ```java
   // remove the unused Optional import if present
   // import java.util.Optional;

   @GetMapping("/{requestedId}")
   private ResponseEntity<CashCard> findById(@PathVariable Long requestedId, Principal principal) {
       CashCard cashCard = cashCardRepository.findByIdAndOwner(requestedId, principal.getName());
       if (cashCard != null) {
           return ResponseEntity.ok(cashCard);
       } else {
           return ResponseEntity.notFound().build();
       }
   }
   ```

1. Run the tests.

   Because we haven't changed any functionality, the tests will continue to pass.

   ```dashboard:open-dashboard
   name: Terminal
   ```

   ```shell
   ./gradlew test
   ...
   BUILD SUCCESSFUL in 6s
   ```

### Reduce Code Duplication

Note that both `CashCardController.findById` and `CashCardController.putCashCard` have nearly identical code that retrieves a target `CashCard` from the `CashCardRepository` using information from a `CashCard` and `Principal`.

Let's reduce code duplication by extracting a helper method named `findCashCard`, and utilizing it in both `.findById` and `.putCashCard`.

This will allow us to update how we retrieve a `CashCard` in one place as the Controller changes over time.

1. Create a shared `findCashCard` method.

   Create a new method in `CashCardController` named `findCashCard`, using functionality we've written before:

   ```editor:open-file
   file: ~/exercises/src/main/java/example/cashcard/CashCardController.java
   ```

   ```java
   private CashCard findCashCard(Long requestedId, Principal principal) {
       return cashCardRepository.findByIdAndOwner(requestedId, principal.getName());
   }
   ```

2. Update `CashCardController.findById` and rerun the tests.

   Next, utilize the new `findCashCard` method in `CashCardController.findById`.

   ```editor:select-matching-text
   file: ~/exercises/src/main/java/example/cashcard/CashCardController.java
   text: "findById"
   description:
   ```

   ```java
   @GetMapping("/{requestedId}")
   private ResponseEntity<CashCard> findById(@PathVariable Long requestedId, Principal principal) {
       CashCard cashCard = findCashCard(requestedId, principal);
       ...
   ```

   No functionality has changed, so no tests should fail when we rerun the tests.

   ```dashboard:open-dashboard
   name: Terminal
   ```

   ```shell
   ./gradlew test
   ...
   BUILD SUCCESSFUL in 6s
   ```

3. Update `CashCardController.putCashCard` and rerun the tests.

   Similar to the previous step, utilize the new `findCashCard` method in `CashCardController.putCashCard`.

   ```editor:select-matching-text
   file: ~/exercises/src/main/java/example/cashcard/CashCardController.java
   text: "putCashCard"
   description:
   ```

   ```java
   @PutMapping("/{requestedId}")
   private ResponseEntity<Void> putCashCard(@PathVariable Long requestedId, @RequestBody CashCard cashCardUpdate, Principal principal) {
       CashCard cashCard = findCashCard(requestedId, principal);
       ...
   ```

   As with the other refactoring we've performed, no functionality has changed, so no tests should fail when we rerun the tests.

   ```dashboard:open-dashboard
   name: Terminal
   ```

   ```shell
   ./gradlew test
   ...
   BUILD SUCCESSFUL in 6s
   ```

Look at that! We've refactored our code by simplifying it, and also reduced code duplication. Excellent!
