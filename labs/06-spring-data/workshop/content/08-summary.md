You've now successfully refactored the way the Family Cash Card API manages its data. Spring Data is now creating an in-memory H2 database and loading it with test data, which our tests utilize to exercise our API.

Furthermore, _we didn't change any of our tests!_ They actually guided us to a correct implementation. How awesome is that?!
