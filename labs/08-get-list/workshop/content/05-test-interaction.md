Let's take a moment now to talk about the `@DirtiesContext` annotation.

You'll see two uses of this annotation in the `CashCardApplicationTests` class: One on the class definition, one on the `shouldCreateANewCashCard` test method definition, which is commented-out for now.

Let's explain.

First, comment out the class-level annotation:

```editor:select-matching-text
file: ~/exercises/src/test/java/example/cashcard/CashCardApplicationTests.java
text: "@DirtiesContext"
description:
```

```java
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
//@DirtiesContext(classMode = ClassMode.AFTER_EACH_TEST_METHOD)
class CashCardApplicationTests {
```

Run all the tests:

```dashboard:open-dashboard
name: Terminal
```

```shell
[~/exercises] $ ./gradlew test
...
 org.opentest4j.AssertionFailedError:
 expected: 3
  but was: 4
     ...
     at app//example.cashcard.CashCardApplicationTests.shouldReturnAllCashCardsWhenListIsRequested(CashCardApplicationTests.java:70)
```

Our new `shouldReturnAllCashCardsWhenListIsRequested` test didn't pass this time! Why?

The reason is that one of the other tests is interfering with our new test by creating a new Cash Card. `@DirtiesContext` fixes this problem by causing Spring to start with a clean state, as if those other tests hadn't been run. Removing it (commenting it out) from the class caused our new test to fail.

## Learning Moment

Although you can use `@DirtiesContext` to work around inter-test interaction, you shouldn't use it indiscriminately; you should have a good reason. Our reason here is to clean up after creating a new Cash Card.

Leave `DirtiesContext` commented out at the class level, and _uncomment_ it on the method which creates a new Cash Card:

```editor:select-matching-text
file: ~/exercises/src/test/java/example/cashcard/CashCardApplicationTests.java
text: "CashCardApplicationTests"
description:
```

```java
//@DirtiesContext(classMode = ClassMode.AFTER_EACH_TEST_METHOD)
class CashCardApplicationTests {
   ...

    @Test
    @DirtiesContext
    void shouldCreateANewCashCard() {
   ...
```

Run the tests, and they pass!
