Our contract states that we should return `404 NOT FOUND` if we try to delete a card that doesn't exist.

1. Write the test.

   Add the following test method to `CashCardApplicationTests`:

   ```editor:open-file
   file: ~/exercises/src/test/java/example/cashcard/CashCardApplicationTests.java
   ```

   ```java
   @Test
   void shouldNotDeleteACashCardThatDoesNotExist() {
       ResponseEntity<Void> deleteResponse = restTemplate
               .withBasicAuth("sarah1", "abc123")
               .exchange("/cashcards/99999", HttpMethod.DELETE, null, Void.class);
       assertThat(deleteResponse.getStatusCode()).isEqualTo(HttpStatus.NOT_FOUND);
   }
   ```

2. Run the tests.

   ```dashboard:open-dashboard
   name: Terminal
   ```

   ```shell
   CashCardApplicationTests > shouldNotDeleteACashCardThatDoesNotExist() FAILED
       org.opentest4j.AssertionFailedError:
       expected: 404 NOT_FOUND
       but was: 204 NO_CONTENT
   ```

   No surprise here!

We need to enforce the security of our app by checking that the user trying to delete a card is the owner.

Spring Security does a lot of things for us, but this isn't one of them.
