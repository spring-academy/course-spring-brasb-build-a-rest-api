As we've done in previous workshops, we'll begin by writing a test of what we expect success to look like.

Since we are introducing a new data contract, we'll start by testing it!

1. Look at the new data fixtures.

   Look at the `src/test/resources/example/cashcard/list.json` file. It contains the following JSON array:

   ```editor:open-file
   file: ~/exercises/src/test/resources/example/cashcard/list.json
   ```

   ```json
   [
     { "id": 99, "amount": 123.45 },
     { "id": 100, "amount": 1.0 },
     { "id": 101, "amount": 150.0 }
   ]
   ```

   This is our new data contract containing a list of Cash Cards, matching the data in the new `data.sql` file; go ahead, look at the `src/test/resources/data.sql` file to verify that the JSON file's values match.

   ```editor:open-file
   file: ~/exercises/src/test/resources/data.sql
   ```

   Now open the `CashCardJsonTest.java` file. Note class-level variable `cashCards` is configured to contain the following Java array:

   ```editor:select-matching-text
   file: ~/exercises/src/test/java/example/cashcard/CashCardJsonTest.java
   text: "setUp"
   description:
   ```

   ```java
   cashCards = Arrays.array(
        new CashCard(99L, 123.45),
        new CashCard(100L, 100.00),
        new CashCard(101L, 150.00));
   ```

   If you look closely you'll see that one of the `CashCard` objects in our test does not match the test data in `data.sql`.
   This is to set us up to write a failing test!

2. Add a serialization test for the Cash Card list.

   Add a new test to `CashCardJsonTest.java`:

   ```java
   @Test
   void cashCardListSerializationTest() throws IOException {
      assertThat(jsonList.write(cashCards)).isStrictlyEqualToJson("list.json");
   }
   ```

   The test code is self-explanatory: It serializes the `cashCards` variable into JSON, then asserts that `list.json` should contain the same data as the serialized `cashCards` variable.

3. Run the tests.

   Can you predict whether the test will fail, and if it does, what the cause of the failure will be? Go ahead, make the call! What do you think will happen?

   Verify your prediction by running the tests.

   Note that we'll always run `./gradlew test` to run the tests.

   ```dashboard:open-dashboard
   name: Terminal
   ```

   ```
   [~/exercises] $ ./gradlew test
   ...
   > Task :test FAILED
   ...
   java.lang.AssertionError: JSON Comparison failure: [1].amount
   Expected: 1.0
        got: 100.0
   ```

   Your prediction was correct (hopefully)! The test failed. Happily, the error message points out the exact spot
   where the failure occurs: the `amount` field of the second `CashCard` in the array (index `[1]`) isn't what was expected.

4. Fix and rerun the tests.

   Change `cashCards[1].amount` to expect the correct `amount` on the Cash Card.

   To verify what amount the test should expect, look at the `list.json` file again. You'll see that the expected amount should be 1.00 instead of 100.0. So let's change the test code:

   ```editor:select-matching-text
   file: ~/exercises/src/test/java/example/cashcard/CashCardJsonTest.java
   text: "setUp"
   description:
   ```

   ```java
   ...
   new CashCard(100L, 1.00),
   ...
   ```

   After correcting the test code to expect 1.0 instead of 100.0 for the value of the `amount` field, re-run the tests. They will pass:

   ```dashboard:open-dashboard
   name: Terminal
   ```

   ```shell
   [~/exercises] $ ./gradlew test
   ...
   BUILD SUCCESSFUL in 7s
   ```

5. Add a deserialization test.

   Now let's test deserialization. Add the following test:

   ```editor:open-file
   file: ~/exercises/src/test/java/example/cashcard/CashCardJsonTest.java
   ```

   ```java
   @Test
   void cashCardListDeserializationTest() throws IOException {
      String expected="""
            [
               { "id": 99, "amount": 123.45 },
               { "id": 100, "amount": 100.00 },
               { "id": 101, "amount": 150.00 }
            ]
            """;
      assertThat(jsonList.parse(expected)).isEqualTo(cashCards);
   }
   ```

   Again, we've intentionally asserted an incorrect value to make it obvious what the test is testing.

6. Run the tests.

   When you run the tests you'll see the incorrect value was caught.

   ```dashboard:open-dashboard
   name: Terminal
   ```

   ```shell
   [~/exercises] $ ./gradlew test
   ...
   > Task :test FAILED
   ...
    expected:
      [CashCard[id=99, amount=123.45],
          CashCard[id=100, amount=1.0],
          CashCard[id=101, amount=150.0]]
     but was:
      [CashCard[id=99, amount=123.45],
          CashCard[id=100, amount=100.0],
          CashCard[id=101, amount=150.0]]
   ```

   This time, the test failed because we deserialized the `expected` JSON String, and compared it to the `cashCards`
   variable. Again, that pesky $100.00 Cash Card does not match the expectation.

   Change the expectation:

   ```editor:select-matching-text
   file: ~/exercises/src/test/java/example/cashcard/CashCardJsonTest.java
   text: "cashCardListDeserializationTest"
   description:
   ```

   ```java
   String expected="""
       [
           { "id": 99, "amount": 123.45 },
           { "id": 100, "amount": 1.00 },
           { "id": 101, "amount": 150.00 }
       ]
       """;
   ```

   Next, rerun the tests and watch the test pass:

   ```dashboard:open-dashboard
   name: Terminal
   ```

   ```shell
   [~/exercises] $ ./gradlew test
   ...
   CashCardJsonTest > cashCardListDeserializationTest() PASSED
   ```

   Now that we've tested the data contract, let's move on to the Controller endpoint.
