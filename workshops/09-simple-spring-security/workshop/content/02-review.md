In this lab we'll secure our Family Cash Card API and restrict access to any given Cash Card to the card's "owner".

To prepare for this, we introduced the concept of an `owner` in the application.

The `owner` is the unique identity of the person who created and can manage a given Cash Card.

Let's review the following changes we made on your behalf:

- `owner` added as a field to the `CashCard` Java record.
- `owner` added to all `.sql` files in `src/main/resources/` and `src/test/resources/`.
- `owner` added to all `.json` files in `src/test/resources/example/cashcard`.

All application code and tests are updated to support the new `owner` field. No functionality has changed as a result of these updates.

Let's take some time to familiarize yourself with these updates.
