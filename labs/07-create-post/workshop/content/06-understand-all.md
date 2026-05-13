Our `CashCardController` now implements the expected input and results of an HTTP POST.

- ```java
  createCashCard(@RequestBody CashCard newCashCardRequest, ...)
  ```

  Unlike the `GET` we added earlier, the `POST` expects a request "body". This contains the data submitted to the API. Spring Web will deserialize the data into a `CashCard` for us.

- ```java
  URI locationOfNewCashCard = ucb
     .path("cashcards/{id}")
     .buildAndExpand(savedCashCard.id())
     .toUri();
  ```

  This is constructing a URI to the newly created `CashCard`. This is the URI that the caller can then use to GET the newly-created `CashCard`.

  Note that `savedCashCard.id` is used as the identifier, which matches the `GET` endpoint's specification of `cashcards/<CashCard.id>`.

- Where did `UriComponentsBuilder` come from?

  We were able to add `UriComponentsBuilder ucb` as a method argument to this `POST` handler method and it was automatically passed in. How so? It was injected from our now-familiar friend, Spring's IoC Container. Thanks, Spring Web!

- ```
  return ResponseEntity.created(locationOfNewCashCard).build();
  ```

  Finally, we return `201 CREATED` with the correct `Location` header.
