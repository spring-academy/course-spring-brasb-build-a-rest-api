Let's now implement paging, starting with a test!

We have 3 `CashCards` in our database. Let's set up a test to fetch them one at a time (page size of 1), then have their amounts sorted from highest to lowest (descending).

1. Write the pagination test.

   Add the following test to `CashCardApplicationTests`, and note that we are adding parameters to the HTTP request of `?page=0&size=1`. We will handle these in our Controller later.

   ```editor:open-file
   file: ~/exercises/src/test/java/example/cashcard/CashCardApplicationTests.java
   ```

   ```java
   @Test
   void shouldReturnAPageOfCashCards() {
       ResponseEntity<String> response = restTemplate.getForEntity("/cashcards?page=0&size=1", String.class);
       assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);

       DocumentContext documentContext = JsonPath.parse(response.getBody());
       JSONArray page = documentContext.read("$[*]");
       assertThat(page.size()).isEqualTo(1);
   }
   ```

1. Run the tests.

   When we run the tests we shouldn't be surprised that all `CashCards` are returned.

   ```dashboard:open-dashboard
   name: Terminal
   ```

   ```shell
   expected: 1
   but was: 3
   ```

1. Implement pagination in the `CashCardController`.

   So, let's add our new endpoint to the Controller! Add the following method to the `CashCardController` (don't delete the existing `findAll()` method):

   ```editor:select-matching-text
   file: ~/exercises/src/main/java/example/cashcard/CashCardController.java
   text: "findAll"
   description:
   ```

   ```java
   @GetMapping
   private ResponseEntity<List<CashCard>> findAll(Pageable pageable) {
       Page<CashCard> page = cashCardRepository.findAll(
               PageRequest.of(
                       pageable.getPageNumber(),
                       pageable.getPageSize()
       ));
       return ResponseEntity.ok(page.getContent());
   }
   ```

1. Understand the pagination code.

   - ```java
     findAll(Pageable pageable)
     ```

     `Pageable` is yet another object that Spring Web provides for us. Since we specified the URI parameters of `page=0&size=1`, `pageable` will contain the values we need.

   - ```java
     PageRequest.of(
       pageable.getPageNumber(),
       pageable.getPageSize()
     ));
     ```

   `PageRequest` is a basic Java Bean implementation of `Pageable`. Things that want paging and sorting implementation often support this, such as _some types of_ Spring Data Repositories.

   Does our `CashCardRepository` support Paging and Sorting yet? Let's find out.

1. Try to compile.

   When we run the tests we discover that our code doesn't even compile!

   ```dashboard:open-dashboard
   name: Terminal
   ```

   ```shell
   [~/exercises] $ ./gradlew test
   ...
   > Task :compileJava FAILED
   exercises/src/main/java/example/cashcard/CashCardController.java:50: error: method findAll in interface CrudRepository<T,ID> cannot be applied to given types;
           Page<CashCard> page = cashCardRepository.findAll(
                                                   ^
     required: no arguments
     found:    PageRequest
   ```

   But of course! We haven't changed the Repository to extend the additional interface. So let's do that. In
   `CashCardRepository.java`, also extend `PagingAndSortingRepository`:

1. Extend `PagingAndSortingRepository` and rerun tests.

   Update `CashCardRepository` to also extend `PagingAndSortingRepository`.

   Don't forget to add the new `import`!

   ```editor:select-matching-text
   file: ~/exercises/src/main/java/example/cashcard/CashCardRepository.java
   text: "CashCardRepository"
   description:
   ```

   ```java
   import org.springframework.data.repository.PagingAndSortingRepository;
   ...

   interface CashCardRepository extends CrudRepository<CashCard, Long>, PagingAndSortingRepository<CashCard, Long> { ... }
   ```

   Now our repository _does_ support Paging and Sorting.

   But our tests still fail! Search for the following failure:

   ```dashboard:open-dashboard
   name: Terminal
   ```

   ```shell
   [~/exercises] $ ./gradlew test
   ...
   Failed to load ApplicationContext
   java.lang.IllegalStateException: Failed to load ApplicationContext
   ...
   Caused by: java.lang.IllegalStateException: Ambiguous mapping. Cannot map 'cashCardController' method
   example.cashcard.CashCardController#findAll(Pageable)
   to {GET [/cashcards]}: There is already 'cashCardController' bean method
   example.cashcard.CashCardController#findAll() mapped.
   ```

   (The actual output is immensely long. We've included the most helpful error message in the output above.)

1. Understand and resolve the failure.

   So what happened?

   We didn't remove the existing `findAll()` Controller method!

   Why is this a problem? Don't we have unique method names and everything compiles?

   The problem is that we have _two methods mapped to the same endpoint_. Spring detects this error at runtime, during the Spring startup process.

   So let's remove the offending old `findAll()` method:

   ```editor:select-matching-text
   file: ~/exercises/src/main/java/example/cashcard/CashCardController.java
   text: "findAll()"
   description:
   ```

   ```java
   // Delete this one:
   @GetMapping()
   private ResponseEntity<Iterable<CashCard>> findAll() {
       return ResponseEntity.ok(cashCardRepository.findAll());
   }
   ```

   Run the tests and ensure that they pass.

   ```dashboard:open-dashboard
   name: Terminal
   ```

   ```shell
   BUILD SUCCESSFUL in 7s
   ```

Next, let's implement Sorting.
