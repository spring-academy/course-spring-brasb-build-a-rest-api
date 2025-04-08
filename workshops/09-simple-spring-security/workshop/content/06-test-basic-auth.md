As we learned in the accompanying lesson, there are many ways of providing user authentication and authorization information for a Spring Boot application using Spring Security.

For our tests, we'll configure a test-only service that Spring Security will use for this purpose: An `InMemoryUserDetailsManager`.

Similar to how we configured an in-memory database using H2 for testing Spring Data, we'll configure an in-memory service with test users to test Spring Security.

1. Configure a test-only `UserDetailsService`.

   Which username and password should we submit in our test HTTP requests?

   When you reviewed changes to `src/test/resources/data.sql` you should've seen that we set an `OWNER` value for each `CashCard` in the database to the username `sarah1`. For example:

   ```editor:open-file
   file: ~/exercises/src/test/resources/data.sql
   ```

   ```sql
   INSERT INTO CASH_CARD(ID, AMOUNT, OWNER) VALUES (100, 1.00, 'sarah1');
   ```

   Let's provide a test-only `UserDetailsService` with the user `sarah1`.

   Add the following Bean to `SecurityConfig`.

   ```editor:select-matching-text
   file: ~/exercises/src/main/java/example/cashcard/SecurityConfig.java
   text: "SecurityConfig"
   description:
   ```

   ```java
     @Bean
     UserDetailsService testOnlyUsers(PasswordEncoder passwordEncoder) {
      User.UserBuilder users = User.builder();
      UserDetails sarah = users
        .username("sarah1")
        .password(passwordEncoder.encode("abc123"))
        .roles() // No roles for now
        .build();
      return new InMemoryUserDetailsManager(sarah);
     }
   ```

   This `UserDetailsService` configuration should be understandable: configure a user named `sarah1` with password `abc123`.

   Spring's IoC container will find the `UserDetailsService` Bean and Spring Data will use it when needed.

1. Configure Basic Auth in HTTP tests.

   Select one test method that uses `restTemplate.getForEntity`, and update it with basic authentication for `sarah1`.

   ```editor:select-matching-text
   file: ~/exercises/src/test/java/example/cashcard/CashCardApplicationTests.java
   text: "shouldReturnACashCardWhenDataIsSaved"
   description:
   ```

   ```java
   void shouldReturnACashCardWhenDataIsSaved() {
       ResponseEntity<String> response = restTemplate
               .withBasicAuth("sarah1", "abc123") // Add this
               .getForEntity("/cashcards/99", String.class);
       assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
       ...
   ```

1. Run the tests.

   The updated test that provides the basics should now pass!

   ```dashboard:open-dashboard
   name: Terminal
   ```

   ```shell
   [~/exercises] $ ./gradlew test
   ...
   CashCardApplicationTests > shouldReturnACashCardWhenDataIsSaved() PASSED
   ...
   ```

1. Update all remaining `CashCardApplicationTests` tests and rerun tests.

   Now for some tedium: Update all remaining `restTemplate`-based tests to supply `.withBasicAuth("sarah1", "abc123")` with every HTTP request.

   ```editor:select-matching-text
   file: ~/exercises/src/test/java/example/cashcard/CashCardApplicationTests.java
   text: "shouldReturnACashCardWhenDataIsSaved"
   description:
   ```

   When finished, rerun the test.

   ```dashboard:open-dashboard
   name: Terminal
   ```

   ```shell
   [~/exercises] $ ./gradlew test
   ...
   BUILD SUCCESSFUL in 9s
   ```

   Everything passes!

   Congratulations, you've implemented and tested Basic Auth!

1. Verify Basic Auth with additional tests.

   Now let's add tests that expect a `401 UNAUTHORIZED` response when incorrect credentials are submitted using basic authentication.

   ```editor:open-file
   file: ~/exercises/src/test/java/example/cashcard/CashCardApplicationTests.java
   ```

   ```java
   @Test
   void shouldNotReturnACashCardWhenUsingBadCredentials() {
       ResponseEntity<String> response = restTemplate
         .withBasicAuth("BAD-USER", "abc123")
         .getForEntity("/cashcards/99", String.class);
       assertThat(response.getStatusCode()).isEqualTo(HttpStatus.UNAUTHORIZED);

       response = restTemplate
         .withBasicAuth("sarah1", "BAD-PASSWORD")
         .getForEntity("/cashcards/99", String.class);
       assertThat(response.getStatusCode()).isEqualTo(HttpStatus.UNAUTHORIZED);
   }
   ```

   This test should pass...

   ```dashboard:open-dashboard
   name: Terminal
   ```

   ```shell
   [~/exercises] $ ./gradlew test
   ...
   CashCardApplicationTests > shouldNotReturnACashCardWhenUsingBadCredentials() PASSED
   ```

Success! Now that we've implemented _authentication_, let's move on to implement _authorization_ next.
