We need to check whether the record exists. If not, we should _not_ delete the Cash Card, and return `404 NOT FOUND`.

1. Make the following changes to `CashCardController.deleteCashCard`:

   ```editor:select-matching-text
   file: ~/exercises/src/main/java/example/cashcard/CashCardController.java
   text: "deleteCashCard"
   description:
   ```

   ```java
   private ResponseEntity<Void> deleteCashCard(
           @PathVariable Long id,
           Principal principal // Add Principal to the parameter list
       ) {
       // Add the following 3 lines:
       if (!cashCardRepository.existsByIdAndOwner(id, principal.getName())) {
           return ResponseEntity.notFound().build();
       }
   ...
   }
   ```

   Let's be sure to the add the `Principal` parameter!

   We're using the Principal in order to check whether the Cash Card exists, _and_ at the same time, enforce ownership.

2. Add the `existsByIdAndOwner()` method to the Repository.

   Also, let's add the new method `existsByIdAndOwner()` to `CashCardRepository`:

   ```editor:select-matching-text
   file: ~/exercises/src/main/java/example/cashcard/CashCardRepository.java
   text: "CashCardRepository"
   description:
   ```

   ```java
   interface CashCardRepository extends CrudRepository<CashCard, Long>, PagingAndSortingRepository<CashCard, Long> {
       ...
       boolean existsByIdAndOwner(Long id, String owner);
       ...
   }
   ```

3. Understand the Repository code.

   We added logic to the Controller method to check whether the Cash Card ID in the request actually exists in the database. The method we'll use is `CashCardRepository.existsByIdAndOwner(id, username)`.

   This is another case where Spring Data will generate the implementation of this method as long as we add it to the Repository.

   So why not just use the `findByIdAndOwner()` method and check whether it returns `null`? We could absolutely do that! But, such a call would return extra information (the content of the Cash Card retrieved), so we'd like to avoid it as to not introduce extra complexity.

   If you'd rather not use the `existsByIdAndOwner()` method, that's ok! You may choose to use `findByIdAndOwner()`. The test result will be the same!

4. Watch the test pass.

   Let's run the test and, no big surprise, the test passes!

   ```dashboard:open-dashboard
   name: Terminal
   ```

   ```shell
   [~/exercises] $ ./gradlew test
   ...
   BUILD SUCCESSFUL in 8s
   ```
