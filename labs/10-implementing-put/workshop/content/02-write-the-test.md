As we have in almost every lab, let's begin with a test.

What's the functionality that we want our application to have? How do we want our application to behave?

Let's define this now, then work our way towards satisfying our aspirations.

1. Write the Update test.

   We'll use `PUT` to update `CashCards`.

   Note that we'll expect a `204 NO_CONTENT` response instead of a `200 OK`. The `204` indicates that the action was successfully performed and no further action is needed by the caller.

   Edit `src/test/java/example/cashcard/CashCardApplicationTests.java`, and add the following test, which updates Cash Card `99` and sets its `amount` to `19.99`.

   Don't forget to add the two new imports.

   ```editor:open-file
   file: ~/exercises/src/test/java/example/cashcard/CashCardApplicationTests.java
   ```

   ```java
   import org.springframework.http.HttpEntity;
   import org.springframework.http.HttpMethod;
   ...
   @Test
   @DirtiesContext
   void shouldUpdateAnExistingCashCard() {
       CashCard cashCardUpdate = new CashCard(null, 19.99, null);
       HttpEntity<CashCard> request = new HttpEntity<>(cashCardUpdate);
       ResponseEntity<Void> response = restTemplate
               .withBasicAuth("sarah1", "abc123")
               .exchange("/cashcards/99", HttpMethod.PUT, request, Void.class);
       assertThat(response.getStatusCode()).isEqualTo(HttpStatus.NO_CONTENT);
   }
   ```

   ### Learning Moment: what's up with `restTemplate.exchange()`?

   Did you notice that we're not using `RestTemplate` in the same way we have in our previous tests?

   All other tests use `RestTemplate.xyzForEntity()` methods such as `getForEntity()` and `postForEntity()`.

   So, why aren't we following the same pattern of utilizing `putForEntity()`?

   Answer: `putForEntity()` doesn't exist! Read more about it here in the [GitHub issue](https://github.com/spring-projects/spring-framework/issues/15256) about the topic.

   Luckily `RestTemplate` supports multiple ways of interacting with REST APIs, such as `RestTemplate.exchange()`.

   Let's learn about `RestTemplate.exchange()` now.

1. Understand `RestTemplate.exchange()`.

   Let's understand more about what's happening.

   The `exchange()` method is a more general version of the `xyzForEntity()` methods we've used in other tests: `exchange()` requires the verb and the request entity (the body of the request) to be supplied as parameters.

   Using `getForEntity()` as an example, you can imagine that the following two lines of code accomplish the same goal:

   `.exchange("/cashcards/99", HttpMethod.GET, new HttpEntity(null), String.class);`

   The above line is functionally equivalent to the following line:

   `.getForEntity("/cashcards/99", String.class);`

   Now let's explain the test code.

   - First we create the `HttpEntity` that the `exchange()` method needs:

     ```java
     HttpEntity<CashCard> request = new HttpEntity<>(cashCardUpdate);
     ```

   - Then we call `exchange()`, which sends a `PUT` request for the target ID of `99` and updated Cash Card data:

     ```java
     .exchange("/cashcards/99", HttpMethod.PUT, request, Void.class);
     ```

1. Run the tests.

   It's time to watch our tests _fail for the right reasons._

   For what reason will our new test fail?

   Note that we'll always use `./gradlew test` to run our tests.

   ```dashboard:open-dashboard
   name: Terminal
   ```

   ```shell
   [~/exercises] $ ./gradlew test
   ...
   CashCardApplicationTests > shouldUpdateAnExistingCashCard() FAILED
    org.opentest4j.AssertionFailedError:
    expected: 204 NO_CONTENT
     but was: 403 FORBIDDEN
   ...
   BUILD FAILED in 6s
   ```

   Answer: We haven't implemented a `PUT` request method handler yet!

   As you can see, the test failed with a `403 FORBIDDEN` response code.

   With no Controller endpoint, this `PUT` call is forbidden! Spring Security automatically handled this scenario for us. Nice!

Next, let's implement the Controller endpoint.
