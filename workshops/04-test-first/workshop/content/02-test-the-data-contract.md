Now, let's write a test that makes sense for your goal: write the CashCard REST API.

1. Replace the very simple test from the previous exercise with a more comprehensive test, so that the test file looks
   like this:

   ```editor:open-file
   file: ~/exercises/src/test/java/example/cashcard/CashCardJsonTest.java
   ```

   ```java
   package example.cashcard;

   import org.junit.jupiter.api.Test;
   import org.springframework.beans.factory.annotation.Autowired;
   import org.springframework.boot.test.autoconfigure.json.JsonTest;
   import org.springframework.boot.test.json.JacksonTester;

   import java.io.IOException;

   import static org.assertj.core.api.Assertions.assertThat;

   @JsonTest
   class CashCardJsonTest {

       @Autowired
       private JacksonTester<CashCard> json;

       @Test
       void cashCardSerializationTest() throws IOException {
           CashCard cashCard = new CashCard(99L, 123.45);
           assertThat(json.write(cashCard)).isStrictlyEqualToJson("expected.json");
           assertThat(json.write(cashCard)).hasJsonPathNumberValue("@.id");
           assertThat(json.write(cashCard)).extractingJsonPathNumberValue("@.id")
                   .isEqualTo(99);
           assertThat(json.write(cashCard)).hasJsonPathNumberValue("@.amount");
           assertThat(json.write(cashCard)).extractingJsonPathNumberValue("@.amount")
                .isEqualTo(123.45);
       }
   }
   ```

   The `@JsonTest` annotation marks the `CashCardJsonTest` as a test class which uses the Jackson framework (which is
   included as part of Spring). This provides extensive JSON testing and parsing support. It also establishes all the
   related behavior to test JSON objects.

   - `JacksonTester` is a convenience wrapper to the Jackson JSON parsing library. It handles serialization and
     deserialization of JSON objects.
   - `@Autowired` is an annotation that directs Spring to create an object of the requested type.

1. Run the test.

   Run the `cashCardSerializationTest()` that you just created to test the serialization of the `CashCard` class.

   ```dashboard:open-dashboard
   name: Terminal
   ```

   ```shell
   [~/exercises] $ ./gradlew test

   > Task :compileTestJava
   /home/eduk8s/src/test/java/example/cashcard/CashCardJsonTest.java:16: error: cannot find symbol
       private JacksonTester<CashCard> json;
                             ^
     symbol:   class CashCard
     location: class CashCardJsonTest
   ...
   > Task :compileTestJava FAILED

   FAILURE: Build failed with an exception.

   * What went wrong:
   Execution failed for task ':compileTestJava'.
   > Compilation failed; see the compiler error output for details.
   ```

   It's no surprise that the test failed as a `CashCard` class does not yet exist. Let's create one now.

1. Create the `CashCard` class.

   To create a `CashCard` class and the constructor that's used in the `cashCardSerializationTest()` test, create the
   file `src/main/java/example/cashcard/CashCard.java` with the following contents (notice that this file is under in
   the `src/main` directory, not the `src/test` directory):

   You can also create `CashCard.java` by clicking the "click-action" below.

   ```editor:append-lines-to-file
   file: ~/exercises/src/main/java/example/cashcard/CashCard.java
   description: "Create CashCard.java"
   ```

   ```java
   package example.cashcard;

   record CashCard(Long id, Double amount) {
   }
   ```

1. Re-run the test.

   You should receive a failure because the `expected.json` file does not exist yet:

   ```dashboard:open-dashboard
   name: Terminal
   ```

   ```shell
   [~/exercises] $ ./gradlew test
   ...
   CashCardJsonTest > cashCardSerializationTest() FAILED
       java.lang.IllegalStateException: Unable to load JSON from class path resource [example/cashcard/expected.json]
   ...
           at example.cashcard.CashCardJsonTest.cashCardSerializationTest(CashCardJsonTest.java:21)

           Caused by:
           java.io.FileNotFoundException: class path resource [example/cashcard/expected.json] cannot be opened because it does not exist
   ...
   2 tests completed, 1 failed

   > Task :test FAILED
   ```

   The quickest way to add a new `expected.json` file is to:

1. Create the Cash Card contract file.

   Create a file called `expected.json` in `src/test/resources/example/cashcard/expected.json`, with the following
   content. Again, you can use the following "click-action" to create `expected.json` if you'd like.

   ```editor:append-lines-to-file
   file: ~/exercises/src/test/resources/example/cashcard/expected.json
   description: "Create expected.json"
   ```

   ```json
   {}
   ```

   Note that you'll need to create the directory structure to contain the new file. One way to do this is as follows:

   1. Right-click on the `test` portion of the `src/test` folder in the editor.
   1. Select **New File...**
   1. In the dialog enter `resources/example/cashcard/expected.json` as the file name.
   1. Edit the newly-created `expected.json` file, and enter `{}` as the only contents.

   We are purposely only including an empty JSON document `{}`, which will cause the test to fail.

1. Run the test.

   The test fails again, but this time it's because of a comparison failure. The error messages indicate two fields are
   missing:

   ```dashboard:open-dashboard
   name: Terminal
   ```

   ```shell
   CashCardJsonTest > cashCardSerializationTest() FAILED
       java.lang.AssertionError: JSON Comparison failure:
       Unexpected: amount
        ;
       Unexpected: id
           at example.cashcard.CashCardJsonTest.cashCardSerializationTest(CashCardJsonTest.java:21)
   ```

1. Complete the Data Contract.

   To add data contract fields to the `src/test/resources/example/cashcard/expected.json `JSON file, change the content
   of the expected.json file to the following:

   ```editor:open-file
   file: ~/exercises/src/test/resources/example/cashcard/expected.json
   ```

   ```json
   {
     "id": 99,
     "amount": 123.45
   }
   ```

1. Run the test again.

   ```dashboard:open-dashboard
   name: Terminal
   ```

   ```shell
   [~/exercises] $ ./gradlew test
   ...
   BUILD SUCCESSFUL in 4s
   ```

   It passes now that the assertions match the contract file.

Congratulations! You've now implemented TDD to create a data contract for your CashCard API.
