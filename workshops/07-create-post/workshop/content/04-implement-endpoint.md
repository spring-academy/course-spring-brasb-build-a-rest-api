Our `POST` endpoint in the `CashCardController` is currently empty. Let's implement the correct logic.

1. Return a `201 CREATED` status.

   As we incrementally make our test pass, we can start by returning `201 CREATED`.

   As we learned earlier, we must provide a `Location` header with the URI for where to find the newly created `CashCard`. We're not quite there yet, so we'll use a placeholder URI for now.

   Be sure to add the two new `import` statements.

   ```editor:select-matching-text
   file: ~/exercises/src/main/java/example/cashcard/CashCardController.java
   text: "createCashCard"
   description:
   ```

   ```java
   import java.net.URI;
   import org.springframework.web.bind.annotation.RequestBody;
   ...

    @PostMapping
    private ResponseEntity<Void> createCashCard(@RequestBody CashCard newCashCardRequest) {
        return ResponseEntity.created(URI.create("/what/should/go/here?")).build();
    }
   ```

1. Run the tests.

   ```dashboard:open-dashboard
   name: Terminal
   ```

   ```shell
   expected: 200 OK
    but was: 404 NOT_FOUND
   ```

   Remarkably, our new test passes until the last line of the new test.

   ```java
   ...
   assertThat(getResponse.getStatusCode()).isEqualTo(HttpStatus.OK);
   ```

   Here we expect to have retrieved our newly created `CashCard`, which we haven't created or returned from our `CashCardController`. Thus, our expectation fails with a result of `NOT_FOUND`.

1. Save the new `CashCard` and return its location.

   Let's add the rest of the `POST` implementation, which we will describe in detail.

   Be sure to add the new `import`.

   ```editor:select-matching-text
   file: ~/exercises/src/main/java/example/cashcard/CashCardController.java
   text: "createCashCard"
   description:
   ```

   ```java
   import org.springframework.web.util.UriComponentsBuilder;
   ...

   @PostMapping
   private ResponseEntity<Void> createCashCard(@RequestBody CashCard newCashCardRequest, UriComponentsBuilder ucb) {
      CashCard savedCashCard = cashCardRepository.save(newCashCardRequest);
      URI locationOfNewCashCard = ucb
               .path("cashcards/{id}")
               .buildAndExpand(savedCashCard.id())
               .toUri();
      return ResponseEntity.created(locationOfNewCashCard).build();
   }
   ```

Next we'll go over these changes in detail.
