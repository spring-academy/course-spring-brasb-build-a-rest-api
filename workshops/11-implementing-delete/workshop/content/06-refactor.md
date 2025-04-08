At this point, we have an opportunity to practice the _Red, Green, Refactor_ process. We've already done _Red_ (the failing test), and _Green_ (the passing test). Now we can ask ourselves, should we _Refactor_ anything?

Here's the body of our `CashCardController.deleteCashCard` method:

```editor:select-matching-text
file: ~/exercises/src/main/java/example/cashcard/CashCardController.java
text: "deleteCashCard"
description:
```

```java
...
if (!cashCardRepository.existsByIdAndOwner(id, principal.getName())) {
    return ResponseEntity.notFound().build();
}
cashCardRepository.deleteById(id);
return ResponseEntity.noContent().build();
```

You might find the following version, which is logically equivalent but slightly simpler, to be easier to read:

```java
if (cashCardRepository.existsByIdAndOwner(id, principal.getName())) {
    cashCardRepository.deleteById(id);
    return ResponseEntity.noContent().build();
}
return ResponseEntity.notFound().build();
```

The differences are slight, but removing a not-operator (`!`) from an `if` statement often makes for easier-to-read code, and _readability is important_!

If you do find the second version easier to read and understand, then replace the existing code with the new version.

Run the tests again. They still pass!

```dashboard:open-dashboard
name: Terminal
```

```shell
[~/exercises] $ ./gradlew test
...
BUILD SUCCESSFUL in 8s
```
