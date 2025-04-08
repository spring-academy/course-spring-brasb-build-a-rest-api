We want our Cash Card API to behave as semantically correctly as possible. Meaning, users of our API shouldn't be surprised by how it behaves.

Let's refer to the official Request for Comments for HTTP Semantics and Content ([RFC 9110](https://www.rfc-editor.org/rfc/rfc9110)) for guidance as to how our API should behave.

For our `POST` endpoint, review this section about [HTTP POST](https://www.rfc-editor.org/rfc/rfc9110#name-post); note that we've added emphasis:

> If one or more resources has been created on the origin server as a result of successfully processing a POST request, **_the origin server SHOULD send a 201 (Created) response containing a Location header field that provides an identifier for the primary resource created ..._**

We'll explain more about this specification as we write our test.

Let's start by updating the `POST` test.

1. Update the `shouldCreateANewCashCard` test.

   Here's how we'll encode the HTTP specification as expectations in our test. Be sure to add the additional `import`.

   ```editor:select-matching-text
   file: ~/exercises/src/test/java/example/cashcard/CashCardApplicationTests.java
   text: "shouldCreateANewCashCard"
   description:
   ```

   ```java
   import java.net.URI;
   ...

   @Test
   void shouldCreateANewCashCard() {
      CashCard newCashCard = new CashCard(null, 250.00);
      ResponseEntity<Void> createResponse = restTemplate.postForEntity("/cashcards", newCashCard, Void.class);
      assertThat(createResponse.getStatusCode()).isEqualTo(HttpStatus.CREATED);

      URI locationOfNewCashCard = createResponse.getHeaders().getLocation();
      ResponseEntity<String> getResponse = restTemplate.getForEntity(locationOfNewCashCard, String.class);
      assertThat(getResponse.getStatusCode()).isEqualTo(HttpStatus.OK);
   }
   ```

1. Understand the test updates.

   We've made quite a few changes. Let's review.

   - ```java
     assertThat(createResponse.getStatusCode()).isEqualTo(HttpStatus.CREATED);
     ```

     According to the official specification:

     > the origin server SHOULD send a 201 (Created) response ...

     We now expect the HTTP response status code to be `201 CREATED`, which is semantically correct if our API _creates_ a new `CashCard` from our request.

   - ```java
     URI locationOfNewCashCard = createResponse.getHeaders().getLocation();
     ```

     The official spec continues to state the following:

     > send a 201 (Created) response **_containing a Location header field_** that provides an identifier for the primary resource created ...

     In other words, when a `POST` request results in the successful creation of a resource, such as a new `CashCard`, the response should include information for how to retrieve that resource. We'll do this by supplying a URI in a [Response Header](https://www.rfc-editor.org/rfc/rfc9110#section-10.2.2) named "Location".

     Note that URI is indeed the correct entity here and _not_ a URL; a [URL is a type of URI](https://www.w3.org/TR/uri-clarification/#contemporary), while a URI is more generic.

   - ```java
     ResponseEntity<String> getResponse = restTemplate.getForEntity(locationOfNewCashCard, String.class);
     assertThat(getResponse.getStatusCode()).isEqualTo(HttpStatus.OK);
     ```

     Finally, we'll use the Location header's information to fetch the newly created `CashCard`.

1. Run the tests.

   Unsurprisingly, they fail on the first changed assertion.

   ```dashboard:open-dashboard
   name: Terminal
   ```

   ```shell
   expected: 201 CREATED
     but was: 200 OK
   ```

Let's start fixing stuff!
