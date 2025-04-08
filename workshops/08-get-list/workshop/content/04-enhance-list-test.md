As we've done in previous lessons, we've tested that our Cash Card API Controller is "listening" for our HTTP calls and does not crash when invoked, this time for a `GET` with no further parameters.

Let's enhance our tests and make sure the correct data is returned from our HTTP request.

1. Enhance the test.

   First, let's fill out the test to assert on the expected data values:

   ```editor:select-matching-text
   file: ~/exercises/src/test/java/example/cashcard/CashCardApplicationTests.java
   text: "shouldReturnAllCashCardsWhenListIsRequested"
   description:
   ```

   ```java
    @Test
    void shouldReturnAllCashCardsWhenListIsRequested() {
        ResponseEntity<String> response = restTemplate.getForEntity("/cashcards", String.class);
        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);

        DocumentContext documentContext = JsonPath.parse(response.getBody());
        int cashCardCount = documentContext.read("$.length()");
        assertThat(cashCardCount).isEqualTo(3);

        JSONArray ids = documentContext.read("$..id");
        assertThat(ids).containsExactlyInAnyOrder(99, 100, 101);

        JSONArray amounts = documentContext.read("$..amount");
        assertThat(amounts).containsExactlyInAnyOrder(123.45, 100.0, 150.00);
    }
   ```

1. Understand the test.

   - ```java
     documentContext.read("$.length()");
     ...
     documentContext.read("$..id");
     ...
     documentContext.read("$..amount");
     ```

     Check out these new JsonPath expressions!

     `documentContext.read("$.length()")` calculates the length of the array.

     `.read("$..id")` retrieves the list of all `id` values returned, while `.read("$..amount")` collects all `amounts` returned.

     To learn more about JsonPath, a good place to start is [here in the JsonPath documentation](https://github.com/json-path/JsonPath).

   - ```java
     assertThat(...).containsExactlyInAnyOrder(...)
     ```

     We haven't guaranteed the order of the `CashCard` list -- they come out in whatever order the database chooses to return them. Since we don't specify the order, `containsExactlyInAnyOrder(...)` asserts that while the list must contain everything we assert, the order does not matter.

1. Run the tests.

   What do you think the test result will be?

   ```dashboard:open-dashboard
   name: Terminal
   ```

   ```shell
    Expecting actual:
      [123.45, 1.0, 150.0]
    to contain exactly in any order:
      [123.45, 100.0, 150.0]
    elements not found:
      [100.0]
    and elements not expected:
      [1.0]
   ```

   The failure message points out exactly the cause of the failure. We've sneakily written a failing test which expects the second Cash Card to have an amount of $100.00, whereas in `src/test/resources/data.sql` the actual value is $1.00.

1. Correct the tests and rerun.

   Change the expectation for the $1 Cash Card:

   ```editor:select-matching-text
   file: ~/exercises/src/test/java/example/cashcard/CashCardApplicationTests.java
   text: "shouldReturnAllCashCardsWhenListIsRequested"
   description:
   ```

   ```java
   assertThat(amounts).containsExactlyInAnyOrder(123.45, 1.00, 150.00);
   ```

   And watch the test pass!

   ```dashboard:open-dashboard
   name: Terminal
   ```

   ```shell
   [~/exercises] $ ./gradlew test
   ...
   CashCardApplicationTests > shouldReturnAllCashCardsWhenListIsRequested() PASSED
   ...
   BUILD SUCCESSFUL in 6s
   ```
