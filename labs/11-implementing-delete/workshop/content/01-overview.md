In the associated lesson, you learned about implementing the Delete operation in a REST API. In this lab, we'll implement hard delete in our Cash Card API, using the API specifications we defined in the associated lesson.

### Credentials for test user Kumar

If you've taken previous labs in this course you'll notice the following changes to the codebase, which we've made on your behalf, to make this lab easier to understand and complete.

We've added credentials for the user `kumar2` to the `testOnlyUsers` bean in `src/main/java/example/cashcard/SecurityConfig.java`.

```editor:select-matching-text
file: ~/exercises/src/main/java/example/cashcard/SecurityConfig.java
text: "testOnlyUsers"
description:
```

Let's implement the Delete endpoint!
