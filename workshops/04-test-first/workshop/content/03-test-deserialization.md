Deserialization is the reverse process of serialization. It transforms data from a file or byte stream back into an
object for your application. This makes it possible for an object serialized on one platform to be deserialized on a
different platform. For example, your client application can serialize an object on Windows while the backend would
deserialize it on Linux.

Serialization and deserialization work together to transform/recreate data objects to/from a portable format. The most
popular data format for serializing data is JSON.

Let’s write a second test to deserialize data so that it converts from JSON to Java after the first test passes.
This test uses a test-first technique where you purposely write a failing test. Specifically: the values for `id`
and `amount` are not what you expect.

1. In the file `src/test/java/example/cashcard/CashCardJsonTest.java`, add a test:

   ```editor:open-file
   file: ~/exercises/src/test/java/example/cashcard/CashCardJsonTest.java
   ```

   ```java
   @Test
   void cashCardDeserializationTest() throws IOException {
      String expected = """
              {
                  "id":99,
                  "amount":123.45
              }
              """;
      assertThat(json.parse(expected))
              .isEqualTo(new CashCard(1000L, 67.89));
      assertThat(json.parseObject(expected).id()).isEqualTo(1000);
      assertThat(json.parseObject(expected).amount()).isEqualTo(67.89);
   }
   ```

2. Run the test.

   The test fails:

   ```dashboard:open-dashboard
   name: Terminal
   ```

   ```shell
   CashCardJsonTest > cashCardDeserializationTest() FAILED
    org.opentest4j.AssertionFailedError:
    expected: CashCard[id=1000, amount=67.89]
     but was: CashCard[id=99, amount=123.45]
   ```

3. Correct the erroneous values for `id` and `amount`.

   You can correct them one at a time. Be sure to re-run the test after each edit.

   Here is what the corrected assertions now look like:

   ```editor:select-matching-text
   file: ~/exercises/src/test/java/example/cashcard/CashCardJsonTest.java
   text: "cashCardDeserializationTest"
   description:
   ```

   ```java
   ...
   assertThat(json.parse(expected))
           .isEqualTo(new CashCard(99L, 123.45));
   assertThat(json.parseObject(expected).id()).isEqualTo(99);
   assertThat(json.parseObject(expected).amount()).isEqualTo(123.45);
   ...
   ```

That's it! You now have a working pair of serialization/deserialization tests.

## Summary

In this lesson you learned about JSON and its importance for modern apps. You also learned how JSON is used in the
CashCard application. Finally, you learned the benefits of the test-first approach to software development, then
exercised test-first development by testing the JSON data contract for the Cash Card service.
