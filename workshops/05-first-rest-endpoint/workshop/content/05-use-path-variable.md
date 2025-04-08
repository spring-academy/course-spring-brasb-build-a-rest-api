Thus far, we’ve ignored the `requestedId` in the Controller handler method. Let's use this path variable in our Controller to make sure we return the correct Cash Card.

1. Add a new test method.

   Let's write a new test that expects to ignore Cash Cards that do not have an `id` of `99`. Use `1000`, as we have in previous tests.

   ```editor:open-file
   file: ~/exercises/src/test/java/example/cashcard/CashCardApplicationTests.java
   ```

   ```java
   @Test
   void shouldNotReturnACashCardWithAnUnknownId() {
     ResponseEntity<String> response = restTemplate.getForEntity("/cashcards/1000", String.class);

     assertThat(response.getStatusCode()).isEqualTo(HttpStatus.NOT_FOUND);
     assertThat(response.getBody()).isBlank();
   }
   ```

   Notice that we're expecting a semantic HTTP Response Status code of `404 NOT_FOUND`. If we request a Cash Card that doesn't exist, then that Cash Card is indeed "not found".

1. Run the test and note the result.

   ```dashboard:open-dashboard
   name: Terminal
   ```

   ```shell
   expected: 404 NOT_FOUND
   but was: 200 OK
   ```

1. Add `@PathVariable`.

   Let’s make the test pass by making the Controller return the specific Cash Card _only_ if we submit the correct identifier.

   To do this, first make the Controller aware of the path variable we’re submitting, by adding the `@PathVariable` annotation to the handler method argument.

   ```editor:select-matching-text
   file: ~/exercises/src/main/java/example/cashcard/CashCardController.java
   text: "findById"
   description:
   ```

   ```java
   @GetMapping("/{requestedId}")
   private ResponseEntity<CashCard> findById(@PathVariable Long requestedId) {
       CashCard cashCard = new CashCard(99L, 123.45);
       return ResponseEntity.ok(cashCard);
   }
   ```

   `@PathVariable` makes Spring Web aware of the `requestedId` supplied in the HTTP request. Now it’s available for us to use in our handler method.

1. Utilize `@PathVariable`.

   Update the handler method to return an empty response with status `NOT_FOUND` unless the `requestedId` is `99`.

   ```java
   @GetMapping("/{requestedId}")
   private ResponseEntity<CashCard> findById(@PathVariable Long requestedId) {
       if (requestedId.equals(99L)) {
           CashCard cashCard = new CashCard(99L, 123.45);
           return ResponseEntity.ok(cashCard);
       } else {
           return ResponseEntity.notFound().build();
       }
   }
   ```

1. Rerun the tests.

   Awesome! They pass!

   ```dashboard:open-dashboard
   name: Terminal
   ```

   ```shell
   [~/exercises] $ ./gradlew test
   ...
   BUILD SUCCESSFUL in 6s
   ```
