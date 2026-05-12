1. Update the Controller.

   Let's update our `CashCardController` so it’s configured to listen for and handle HTTP requests to `/cashcards`.

   ```editor:select-matching-text
   file: ~/exercises/src/main/java/example/cashcard/CashCardController.java
   text: "class CashCardController"
   description:
   ```

   ```java
   @RestController
   @RequestMapping("/cashcards")
   class CashCardController {

      @GetMapping("/{requestedId}")
      private ResponseEntity<String> findById() {
            return ResponseEntity.ok("{}");
      }
   }
   ```

1. Understand the Spring Web annotations.

   Let's review our additions.

   - ```java
      @RestController
     ```

     This tells Spring that this class is a `Component` of type `RestController` and capable of handling HTTP requests.

   - ```java
      @RequestMapping("/cashcards")
     ```

     This is a companion to `@RestController` that indicates which address requests must have to access this Controller.

   - ```java
      @GetMapping("/{requestedId}")
      private ResponseEntity<String> findById() {...}
     ```

     `@GetMapping` marks a method as a _handler method._ `GET` requests that match `cashcards/{requestedID}` will be handled by this method.

1. Run the tests.

   They pass!

   ```dashboard:open-dashboard
   name: Terminal
   ```

   ```shell
   [~/exercises] $ ./gradlew test
   ...
   BUILD SUCCESSFUL in 6s
   ```

We finally have a Controller and handler method that matches the request performed in our test. Sweet!
