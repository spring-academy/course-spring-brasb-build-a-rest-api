Just as if we’re on a real project, let’s use test driven development to implement our first API endpoint.

1. Write the test.

   Let's start by implementing a test using Spring's `@SpringBootTest`.

   Update `src/test/java/example/cashcard/CashCardApplicationTests.java` with the following:

   ```editor:open-file
   file: ~/exercises/src/test/java/example/cashcard/CashCardApplicationTests.java
   ```

   ```java
   package example.cashcard;

   import com.jayway.jsonpath.DocumentContext;
   import com.jayway.jsonpath.JsonPath;
   import org.junit.jupiter.api.Test;
   import org.springframework.beans.factory.annotation.Autowired;
   import org.springframework.boot.test.context.SpringBootTest;
   import org.springframework.boot.test.web.client.TestRestTemplate;
   import org.springframework.http.HttpStatus;
   import org.springframework.http.ResponseEntity;

   import static org.assertj.core.api.Assertions.assertThat;

   @SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
   class CashCardApplicationTests {
       @Autowired
       TestRestTemplate restTemplate;

       @Test
       void shouldReturnACashCardWhenDataIsSaved() {
           ResponseEntity<String> response = restTemplate.getForEntity("/cashcards/99", String.class);

           assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
       }
   }
   ```

1. Understand the test.

   Let's understand several important elements in this test.

   - ```java
     @SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
     ```

     This will start our Spring Boot application and make it available for our test to perform requests to it.

   - ```java
     @Autowired
     TestRestTemplate restTemplate;
     ```

     We've asked Spring to inject a test helper that’ll allow us to make HTTP requests to the locally running application.

     **_Note_**: Even though `@Autowired` is a form of Spring dependency injection, it’s best used only in tests. Don't worry, we'll discuss this in more detail later.

   - ```java
     ResponseEntity<String> response = restTemplate.getForEntity("/cashcards/99", String.class);
     ```

     Here we use `restTemplate` to make an HTTP `GET` request to our application endpoint `/cashcards/99`.

     `restTemplate` will return a `ResponseEntity`, which we've captured in a variable we've named `response`. `ResponseEntity` is another helpful Spring object that provides valuable information about what happened with our request. We'll use this information throughout our tests in this course.

   - ```java
     assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
     ```

     We can inspect many aspects of the `response`, including the HTTP Response Status code, which we expect to be `200 OK`.

1. Now run the test.

   What do you think will happen when we run the test?

   It will fail, _as expected_. Why? As we’ve learned in test-first practice, we describe our expectations _before_ we implement the code that satisfies those expectations.

   Now, let’s run the test. Note that we'll run `./gradlew test` for every test run.

   ```dashboard:open-dashboard
   name: Terminal
   ```

   ```shell
   [~/exercises] $ ./gradlew test
   ```

   It fails! Search the output for the following:

   ```shell
   CashCardApplicationTests > shouldReturnACashCardWhenDataIsSaved() FAILED
     org.opentest4j.AssertionFailedError:
     expected: 200 OK
      but was: 404 NOT_FOUND
   ```

   But why are we getting this specific failure?

1. Understand the test failure.

   As we explained, we expected our test to currently fail.

   Why is it failing due to an unexpected `404 NOT_FOUND` HTTP response code?

   Answer: Since we haven't instructed Spring Web how to handle `GET cashcards/99`, Spring Web is automatically responding that the endpoint is `NOT_FOUND`.

   Thank you for handling that for us, Spring Web!

Next, let's get our application working properly.
