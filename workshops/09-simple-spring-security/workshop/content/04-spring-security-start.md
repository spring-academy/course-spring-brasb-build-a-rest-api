Next, we'll focus on getting our tests passing again by providing the minimum configuration needed by Spring Security.

We've provided another file on our behalf: `example/cashcard/SecurityConfig.java`. This will be the Java Bean where we'll configure Spring Security for our application.

1. Uncomment `SecurityConfig.java` and review.

   Open `SecurityConfig`.

   ```editor:select-matching-text
   file: ~/exercises/src/main/java/example/cashcard/SecurityConfig.java
   text: "SecurityConfig"
   description:
   ```

   Notice that most of the file is commented.

   Uncomment all commented lines within `SecurityConfig`, including all methods and `import` statements.

   ```java
   package example.cashcard;
   ...
   class SecurityConfig {

       SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
           return http.build();
       }

       @Bean
       PasswordEncoder passwordEncoder() {
           return new BCryptPasswordEncoder();
       }
   ...
   ```

   `filterChain` returns `http.build()`, which is the minimum needed for now.

   _Note:_ Please ignore the method `passwordEncoder()` for now.

1. Enable Spring Security.

   At the moment `SecurityConfig` is just an un-referenced Java class as nothing is using it.

   Let's turn `SecurityConfig` into our configuration Bean for Spring Security.

   ```java
   // Add this Annotation
   @Configuration
   class SecurityConfig {

       // Add this Annotation
       @Bean
       SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
           return http.build();
       }
   ...
   ```

1. Understand the Annotations.

   - ```java
     @Configuration
     class SecurityConfig {...}
     ```

     The `@Configuration` annotation tells Spring to use this class to configure Spring and Spring Boot itself. Any Beans specified in this class will now be available to Spring's Auto Configuration engine.

   - ```java
     @Bean
     SecurityFilterChain filterChain
     ```

     Spring Security expects a Bean to configure its **Filter Chain**, which you learned about in the Simple Spring Security lesson. Annotating a method returning a `SecurityFilterChain` with the `@Bean` satisfies this expectation.

1. Run the tests.

   When you run the tests you'll see that once again all tests pass – _except for the test for creating a new `CashCard` via a `POST`_.

   ```dashboard:open-dashboard
   name: Terminal
   ```

   ```shell
   [~/exercises] $ ./gradlew test
   ...
   CashCardApplicationTests > shouldCreateANewCashCard() FAILED
       org.opentest4j.AssertionFailedError:
       expected: 201 CREATED
        but was: 403 FORBIDDEN
   ...
   11 tests completed, 1 failed
   ```

   This is expected. We'll cover this in depth a bit later on.
