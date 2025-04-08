As of now, our test only asserts that the request succeeded by checking for a `200 OK` response status. Next, let's test that the response contains the correct values.

1. Update the test.

   ```editor:select-matching-text
   file: ~/exercises/src/test/java/example/cashcard/CashCardApplicationTests.java
   text: "shouldReturnACashCardWhenDataIsSaved"
   description:
   ```

   ```java
   assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);

   DocumentContext documentContext = JsonPath.parse(response.getBody());
   Number id = documentContext.read("$.id");
   assertThat(id).isNotNull();
   ```

1. Understand the additions.

   - ```java
      DocumentContext documentContext = JsonPath.parse(response.getBody());
     ```

     This converts the response String into a JSON-aware object with lots of helper methods.

   - ```java
      Number id = documentContext.read("$.id");
      assertThat(id).isNotNull();
     ```

     We expect that when we request a Cash Card with `id` of `99` a JSON object will be returned with _something_ in the `id` field. For now, assert that the `id` is not `null`.

1. Run the test -- and note the failure.

   Since we return an empty JSON object `{}` we shouldn't be surprised that the `id` field is empty.

   ```dashboard:open-dashboard
   name: Terminal
   ```

   ```shell
   CashCardApplicationTests > shouldReturnACashCardWhenDataIsSaved() FAILED
       com.jayway.jsonpath.PathNotFoundException: No results for path: $['id']
   ```

1. Return a Cash Card from the Controller.

   Let's make the test pass, but return something _intentionally wrong_, such as `1000L`. You'll see why later.

   Additionally, let’s utilize the `CashCard` data model class that we created in an earlier lesson. Please review it under `src/main/java/example/cashcard/CashCard.java`, if needed.

   ```editor:select-matching-text
   file: ~/exercises/src/main/java/example/cashcard/CashCardController.java
   text: "findById"
   description:
   ```

   ```java
   @GetMapping("/{requestedId}")
   private ResponseEntity<CashCard> findById() {
      CashCard cashCard = new CashCard(1000L, 0.0);
      return ResponseEntity.ok(cashCard);
   }
   ```

1. Run the test.

   ```dashboard:open-dashboard
   name: Terminal
   ```

   It passes! Yet - does it feel correct? Not really. Having the test pass with incorrect data seems wrong.

   We asked you to intentionally return an incorrect `id` of `1000L` to illustrate a point: It's important that tests pass or fail for _for the right reason._

1. Update the test.

   Update the test to assert that the `id` is correct.

   ```editor:select-matching-text
   file: ~/exercises/src/test/java/example/cashcard/CashCardApplicationTests.java
   text: "shouldReturnACashCardWhenDataIsSaved"
   description:
   ```

   ```java
   DocumentContext documentContext = JsonPath.parse(response.getBody());
   Number id = documentContext.read("$.id");
   assertThat(id).isEqualTo(99);
   ```

1. Rerun the tests and note the _new_ failure message.

   ```dashboard:open-dashboard
   name: Terminal
   ```

   ```shell
   expected: 99
    but was: 1000
   ```

   Now, the test is failing for the right reason: We didn't return the correct `id`.

1. Fix `CashCardController`.

   Update `CashCardController` to return the correct `id`.

   ```editor:select-matching-text
   file: ~/exercises/src/main/java/example/cashcard/CashCardController.java
   text: "findById"
   description:
   ```

   ```java
   @GetMapping("/{requestedId}")
   private ResponseEntity<CashCard> findById() {
      CashCard cashCard = new CashCard(99L, 0.0);
      return ResponseEntity.ok(cashCard);
   }
   ```

1. Run the test.

   ```dashboard:open-dashboard
   name: Terminal
   ```

   Woo hoo, it passes!

1. Test the `amount`.

   Next, let's add an assertion for `amount` indicated by the JSON contract.

   ```editor:select-matching-text
   file: ~/exercises/src/test/java/example/cashcard/CashCardApplicationTests.java
   text: "shouldReturnACashCardWhenDataIsSaved"
   description:
   ```

   ```java
   DocumentContext documentContext = JsonPath.parse(response.getBody());
   Number id = documentContext.read("$.id");
   assertThat(id).isEqualTo(99);

   Double amount = documentContext.read("$.amount");
   assertThat(amount).isEqualTo(123.45);
   ```

1. Run the tests and observe the failure.

   Sure enough, we don’t return the correct `amount` in the response.

   ```dashboard:open-dashboard
   name: Terminal
   ```

   ```shell
   expected: 123.45
   but was: 0.0
   ```

1. Return the correct `amount`.

   Let's update the `CashCardController` to return the amount indicated by the JSON contract.

   ```editor:select-matching-text
   file: ~/exercises/src/main/java/example/cashcard/CashCardController.java
   text: "findById"
   description:
   ```

   ```java
   @GetMapping("/{requestedId}")
   private ResponseEntity<CashCard> findById() {
      CashCard cashCard = new CashCard(99L, 123.45);
      return ResponseEntity.ok(cashCard);
   }
   ```

1. Rerun the tests.

   ```dashboard:open-dashboard
   name: Terminal
   ```

   They pass! Excellent.

   `BUILD SUCCESSFUL in 6s`
