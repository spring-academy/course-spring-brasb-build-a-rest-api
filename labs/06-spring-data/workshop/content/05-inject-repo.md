Although we've configured our `CashCard` and `CashCardRepository` classes, we haven't utilized the new `CashCardRepository` to manage our `CashCard` data. Let's do that now.

1. Inject the `CashCardRepository` into `CashCardController`.

   Edit `CashCardController` to accept a `CashCardRepository`.

   ```editor:select-matching-text
   file: ~/exercises/src/main/java/example/cashcard/CashCardController.java
   text: "class CashCardController"
   description:
   ```

   ```java
   @RestController
   @RequestMapping("/cashcards")
   class CashCardController {
      private final CashCardRepository cashCardRepository;

      private CashCardController(CashCardRepository cashCardRepository) {
         this.cashCardRepository = cashCardRepository;
      }
      ...
   ```

1. Run the tests.

   If you run the tests now, they'll all pass, despite no other changes to the codebase utilizing the new, _required_ constructor `CashCardController(CashCardRepository cashCardRepository)`.

   ```dashboard:open-dashboard
   name: Terminal
   ```

   ```shell
   BUILD SUCCESSFUL in 7s
   ```

   So how is this possible?

1. Behold Auto Configuration and Construction Injection!

   Spring's Auto Configuration is utilizing its dependency injection (DI) framework, specifically _constructor injection_, to supply `CashCardController` with the correct implementation of `CashCardRepository` at runtime.

   Magical stuff!

### Learning Moment: Remove the DI

We have just beheld the glory of auto configuration and constructor injection.

But what happens when we disable this wonder?

1. Temporarily change the `CashCardRepository` to remove the implementation of `CrudRepository`.

   ```editor:select-matching-text
   file: ~/exercises/src/main/java/example/cashcard/CashCardRepository.java
   text: "CashCardRepository"
   description:
   ```

   ```java
   interface CashCardRepository {
   }
   ```

1. Compile the project and note the failure.

   ```dashboard:open-dashboard
   name: Terminal
   ```

   ```shell
   [~/exercises] $ ./gradlew build
   ```

   Searching through the output, we find this line:

   ```shell
   org.springframework.beans.factory.NoSuchBeanDefinitionException: No qualifying bean of type 'example.cashcard.CashCardRepository' available: expected at least 1 bean which qualifies as autowire candidate. Dependency annotations: {}
   ```

   Clues such as `NoSuchBeanDefinitionException`, `No qualifying bean`, and `expected at least 1 bean which qualifies as autowire candidate` tell us that Spring is trying to find a properly configured class to provide during the dependency injection phase of Auto Configuration, but none qualify.

   We can satisfy this DI requirement by extending the `CrudRepository`.

1. Undo all that.

   Be sure to undo the temporary changes to `CashCardRepository` before moving on.

   ```editor:select-matching-text
   file: ~/exercises/src/main/java/example/cashcard/CashCardRepository.java
   text: "CashCardRepository"
   description:
   ```

   ```java
   interface CashCardRepository extends CrudRepository<CashCard, Long> {
   }
   ```
