1. Create the `CashCardRepository`.

   Create `src/main/java/example/cashcard/CashCardRepository.java` and have it `extend CrudRepository`.

   ```java
   package example.cashcard;

   import org.springframework.data.repository.CrudRepository;

   interface CashCardRepository extends CrudRepository {
   }
   ```

1. Understand `extends CrudRepository`.

   This is where we tap into the magic of Spring Data and its data repository pattern.

   `CrudRepository` is an interface supplied by Spring Data. When we extend it (or other sub-Interfaces of Spring Data's `Repository`), Spring Boot and Spring Data work together to automatically generate the CRUD methods that we need to interact with a database.

   We'll use one of these CRUD methods, `findById`, later in the lab.

1. Run the tests.

   We can see that everything compiles, however our application crashes badly upon startup. Digging through the failure messages we find this:

   ```dashboard:open-dashboard
   name: Terminal
   ```

   ```shell
   [~/exercises] $ ./gradlew test
   ...
   CashCardApplicationTests > shouldNotReturnACashCardWithAnUnknownId() FAILED
    java.lang.IllegalStateException: Failed to load ApplicationContext for ...

   Caused by:
   java.lang.IllegalArgumentException: Could not resolve domain type of interface example.cashcard.CashCardRepository
   ...
   ```

   This cryptic error means that we haven't indicated which data object the `CashCardRepository` should manage. For our application, the "domain type" of this repository will be the `CashCard`.

1. Configure the `CashCardRepository`.

   Edit the `CashCardRepository` to specify that it manages the `CashCard`'s data, and that the datatype of the Cash Card ID is `Long`.

   ```editor:select-matching-text
   file: ~/exercises/src/main/java/example/cashcard/CashCardRepository.java
   text: "CashCardRepository"
   description:
   ```

   ```java
   interface CashCardRepository extends CrudRepository<CashCard, Long> {
   }
   ```

1. Configure the `CashCard`.

   When we configure the repository as `CrudRepository<CashCard, Long>` we indicate that the `CashCard`'s ID is `Long`. However, we still need to tell Spring Data which field is the ID.

   Edit the `CashCard` class to configure the `id` as the `@Id` for the `CashCardRepository`.

   Don't forget to add the new import.

   ```editor:open-file
   file: ~/exercises/src/main/java/example/cashcard/CashCard.java
   ```

   ```java
   package example.cashcard;

   // Add this import
   import org.springframework.data.annotation.Id;

   record CashCard(@Id Long id, Double amount) {
   }
   ```

1. Run the tests.

   ```dashboard:open-dashboard
   name: Terminal
   ```

   ```shell
   [~/exercises] $ ./gradlew test
   ...
   BUILD SUCCESSFUL in 4s
   ```

   The tests pass, but we haven't made any meaningful changes to the code...yet!
