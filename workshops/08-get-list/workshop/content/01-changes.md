We've made the following changes from the previous lab.

1. Added a couple more Cash Card data fixtures to `src/test/resources/data.sql`
1. Refactored `CashCardJsonTest.java` to incorporate the new data fixtures.
1. Renamed `expected.json` to `single.json`, and added another data contract JSON file: `list.json`.
1. Added some `import`s to the Test classes, so you don't have to!
1. Added the `@DirtiesContext` annotation to the `CashCardApplicationTests` class.

This list is just the summary. We'll expand on each point throughout the lab instructions.
