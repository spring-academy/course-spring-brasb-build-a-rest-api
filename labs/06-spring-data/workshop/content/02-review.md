Our Family Cash Card REST API currently relies upon `CashCard` data hard-coded directly into our `CashCardController`. Our tests in `CashCardApplicationTests` assert that this data is present.

We know that a web Controller shouldn't manage data. This is a violation of Separation of Concerns. Web traffic is web traffic, data is data, and healthy software has architectures dedicated to each area.

1. Review `CashCardController`.

   Note lines such as the following:

   ```editor:select-matching-text
   file: ~/exercises/src/main/java/example/cashcard/CashCardController.java
   text: "findById"
   description:
   ```

   ```java
   ...
   if (requestedId.equals(99L)) {
      CashCard cashCard = new CashCard(99L, 123.45);
      return ResponseEntity.ok(cashCard);
   ...
   ```

   This is data management. Our Controller shouldn't be concerned with checking IDs or creating data.

1. Review `CashCardApplicationTests`.

   ```editor:select-matching-text
   file: ~/exercises/src/test/java/example/cashcard/CashCardApplicationTests.java
   text: "shouldReturnACashCardWhenDataIsSaved"
   description:
   ```

   Interestingly, while our tests make assertions about the data, they don't rely upon or specify _how_ that data is created or managed.

   This decoupling is important, as it helps us make the changes we need.

### Prepare to Refactor to use a Repository and Database

Refactoring is the act of altering the implementation of a software system without altering its inputs, outputs, or behavior.

Our tests will allow us to change the implementation of our Cash Card API's data management from hard-coded data inside our Controller, to utilizing a Repository and database.

This lab is a continuous example of the Red, Green, Refactor development loop that we learned about in a previous lesson.

As we refactor, our tests will periodically fail when we run them. We'll know we've successfully removed all hard-coded data from our Controller and "migrated" that data (and data management) to a database-backed Repository when our tests pass again.
