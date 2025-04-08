This line in `CashCardController.createCashCard` is deceptively simple:

```java
CashCard savedCashCard = cashCardRepository.save(newCashCardRequest);
```

As learned in previous lessons and labs, Spring Data's `CrudRepository` provides methods that support creating, reading, updating, and deleting data from a data store. `cashCardRepository.save(newCashCardRequest)` does just as it says: it saves a new `CashCard` for us, and returns the saved object with a unique `id` provided by the database. Amazing!
