This project was originally created using the [Spring Initializr](https://start.spring.io/), which allowed us to automatically add dependencies to our project. However, now we must manually add dependencies to our project.

1. Add dependencies for Spring Data and a database.

   In `build.gradle`:

   ```editor:select-matching-text
   file: ~/exercises/build.gradle
   text: "dependencies"
   description:
   ```

   ```groovy
   dependencies {
      implementation 'org.springframework.boot:spring-boot-starter-web'
      testImplementation 'org.springframework.boot:spring-boot-starter-test'

      // Add the two dependencies below
      implementation 'org.springframework.data:spring-data-jdbc'
      implementation 'com.h2database:h2'
   }
   ```

1. Understand the dependencies.

   The two dependencies we added are related, but different.

   - ```groovy
     implementation 'org.springframework.data:spring-data-jdbc'
     ```

     Spring Data has many implementations for a variety of relational and non-relational database technologies. Spring Data also has several abstractions on top of those technologies. These are commonly called an Object-Relational Mapping framework, or ORM.

     Here we'll elect to use Spring Data JDBC. From the Spring Data JDBC [documentation](https://spring.io/projects/spring-data-jdbc):

     > Spring Data JDBC aims at being conceptually easy...This makes Spring Data JDBC a simple, limited, opinionated ORM.

   - ```groovy
     implementation 'com.h2database:h2'
     ```

     Database management frameworks only work if they have a linked database. H2 is a "very fast, open source, JDBC API" SQL database implemented in Java. It works seamlessly with Spring Data JDBC.

1. Run the tests.

   This will both install the dependencies, and verify that their addition hasn't broken anything.

   We'll always use `./gradlew test` to run our tests.

   ```dashboard:open-dashboard
   name: Terminal
   ```

   ```shell
   [~/exercises] $ ./gradlew test
   ...
   BUILD SUCCESSFUL in 4s
   ```

   The dependencies are now installed! You might notice additional output compared to previous labs, such as `Shutting down embedded database`.

   Spring Auto Configuration is now starting and configuring an H2 database for us to use with tests. Great!
