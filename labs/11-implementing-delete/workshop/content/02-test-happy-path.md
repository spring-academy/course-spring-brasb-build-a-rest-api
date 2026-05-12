Let's start with the simplest happy path: Successfully deleting a `CashCard` which exists.

We need the Delete endpoint to return the `204 NO CONTENT` status code.

1. Write the test.

   Add the following test method to `src/test/java/example/cashcard/CashCardApplicationTests.java`:

   ```editor:open-file
   file: ~/exercises/src/test/java/example/cashcard/CashCardApplicationTests.java
   ```

   ```java
   @Test
   @DirtiesContext
   void shouldDeleteAnExistingCashCard() {
       ResponseEntity<Void> response = restTemplate
               .withBasicAuth("sarah1", "abc123")
               .exchange("/cashcards/99", HttpMethod.DELETE, null, Void.class);
       assertThat(response.getStatusCode()).isEqualTo(HttpStatus.NO_CONTENT);
   }
   ```

   Notice that we've added the `@DirtiesContext` annotation. We'll add this annotation to all tests which change the data. If we don't, then these tests could affect the result of other tests in the file.

   ### Why not use `RestTemplate.delete()`?

   Notice that we're using `RestTemplate.exchange()` even though `RestTemplate` supplies a method that looks like we could use: `RestTemplate.delete()`. However, let's look at the signature:

   ```java
   public class RestTemplate ... {
       public void delete(String url, Object... uriVariables)
   ```

   The other methods we've been using (such as `getForEntity()` and `exchange()`) return a `ResponseEntity`, but `delete()` doesn't. Instead, it's a `void` method. Why is this?

   The Spring Web framework supplies the `delete()` method as a convenience, but it comes with some assumptions:

   1. A response to a `DELETE` request will have no body.
   2. The client shouldn't care what the response code is unless it's an error, in which case, it'll throw an exception.

   Given those assumptions, no return value is needed from `delete()`.

   But, the second assumption makes `delete()` unsuitable for us: We need the `ResponseEntity` in order to assert on the status code! So, we won't use the convenience method, but rather let's use the more general method: `exchange()`.

2. Run the tests.

   As always, we'll use `./gradlew test` to run the tests.

   ```dashboard:open-dashboard
   name: Terminal
   ```

   ```shell
   [~/exercises] $ ./gradlew test
   ...
   CashCardApplicationTests > shouldDeleteAnExistingCashCard() FAILED
       org.opentest4j.AssertionFailedError:
       expected: 204 NO_CONTENT
       but was: 403 FORBIDDEN
   ```

   The test failed because the `DELETE /cashcards/99` request returned a `403 FORBIDDEN`.

   At this point you probably expected this result: Spring Security returns a `403` response for any endpoint which isn't mapped.

   We need to implement the Controller method. So, let's do it!

3. Implement the Delete endpoint in the Controller.

   Add the following method to the `CashCardController` class:

   ```editor:open-file
   file: ~/exercises/src/main/java/example/cashcard/CashCardController.java
   ```

   ```java
   @DeleteMapping("/{id}")
   private ResponseEntity<Void> deleteCashCard(@PathVariable Long id) {
       return ResponseEntity.noContent().build();
   }
   ```

   What will happen if we run the tests?

4. Run the tests.

   ```dashboard:open-dashboard
   name: Terminal
   ```

   ```shell
   [~/exercises] $ ./gradlew test
   ...
   BUILD SUCCESSFUL in 8s
   ```

   They pass!

   Does that mean that we're done? Not yet!

   We haven't written the code to actually _delete_ the item. Let's do that next.

   We'll write the test first, of course.

5. Test that we're actually deleting the `CashCard`.

   Add the following assertions to the `shouldDeleteAnExistingCashCard()` test:

   ```editor:select-matching-text
   file: ~/exercises/src/test/java/example/cashcard/CashCardApplicationTests.java
   text: "shouldDeleteAnExistingCashCard"
   description:
   ```

   ```java
   @Test
   @DirtiesContext
   void shouldDeleteAnExistingCashCard() {
       ResponseEntity<Void> response = restTemplate
               .withBasicAuth("sarah1", "abc123")
               .exchange("/cashcards/99", HttpMethod.DELETE, null, Void.class);
       assertThat(response.getStatusCode()).isEqualTo(HttpStatus.NO_CONTENT);

       // Add the following code:
       ResponseEntity<String> getResponse = restTemplate
               .withBasicAuth("sarah1", "abc123")
               .getForEntity("/cashcards/99", String.class);
       assertThat(getResponse.getStatusCode()).isEqualTo(HttpStatus.NOT_FOUND);
   }
   ```

6. Understand the test code.

   We want to test that the deleted Cash Card is actually deleted, so we try to `GET` it, and assert that the result code is `404 NOT FOUND`.

   Run the test. Does it pass? Of course not!

   ```dashboard:open-dashboard
   name: Terminal
   ```

   ```shell
   CashCardApplicationTests > shouldDeleteAnExistingCashCard() FAILED
       org.opentest4j.AssertionFailedError:
       expected: 404 NOT_FOUND
       but was: 200 OK
   ```

   What do we need to do to make the test pass? Write some code to delete the record!

   Let's go.
