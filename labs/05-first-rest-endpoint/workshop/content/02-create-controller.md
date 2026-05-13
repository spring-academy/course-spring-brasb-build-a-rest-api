Spring Web Controllers are designed to handle and respond to HTTP requests.

1. Create the Controller.

   Create the Controller class in `src/main/java/example/cashcard/CashCardController.java`.

   ```editor:append-lines-to-file
   file: ~/exercises/src/main/java/example/cashcard/CashCardController.java
   description: "Create CashCardController.java"
   ```


   ```java
   package example.cashcard;

   import org.springframework.http.ResponseEntity;
   import org.springframework.web.bind.annotation.GetMapping;
   import org.springframework.web.bind.annotation.PathVariable;
   import org.springframework.web.bind.annotation.RequestMapping;
   import org.springframework.web.bind.annotation.RestController;

   class CashCardController {
   }
   ```

2. Add the handler method.

   Implement a `findById()` method to handle incoming HTTP requests.

   ```java
   class CashCardController {
      private ResponseEntity<String> findById() {
         return ResponseEntity.ok("{}");
      }
   }
   ```

3. Now rerun the test.

   What do we expect to happen when we rerun the tests?

   ```dashboard:open-dashboard
   name: Terminal
   ```

   ```shell
   expected: 200 OK
    but was: 404 NOT_FOUND
   ```

   Same result! Why?

   Despite the name, `CashCardController` isn't really a Spring Web Controller; it's just a class with `Controller` in the name. Thus, it’s not "listening" for our HTTP requests. Therefore, we need to tell Spring to make the Controller available as a Web Controller to handle requests to `cashcards/*` URLs.
