Our REST API can now fetch Cash Cards with a specific ID. In this lesson, you’ll add the Create endpoint to the API.

Four questions we’ll need to answer while doing this are:

1. Who specifies the ID - the client, or the server?
2. In the API Request, how do we represent the object to be created?
3. Which HTTP method should we use in the Request?
4. What does the API send as a Response?

Let’s start by answering the first question: “Who specifies the ID?” In reality, this is up to the API creator! REST is not exactly a standard; it’s merely a way to use HTTP to perform data operations. REST contains a number of guidelines, many of which we’re following in this course.

Here we’ll choose to let the server create the ID. Why? Because it’s the simplest solution, and databases are efficient at managing unique IDs. However, for completeness, let’s discuss our alternatives:

- We could require the client to provide the ID. This might make sense if there were a pre-existing unique ID, but that’s not the case.
- We could allow the client to provide the ID optionally (and create it on the server if the client does not supply it). However, we don’t have a requirement to do this, and it would complicate our application. If you think you might want to do this “just in case”, the **Yagni** article (link in the References section) might dissuade you.

Before answering the third question, “Which HTTP method should be used in the Request?”, let’s talk about the relevant concept of **idempotence**.

## Idempotence and HTTP

An **idempotent** operation is defined as one which, if performed more than once, results in the same outcome. In a REST API, an idempotent operation is one that even if it were to be performed several times, the resulting data on the server would be the same as if it had been performed only once.

For each method, the HTTP standard specifies whether it is idempotent or not. `GET`, `PUT`, and `DELETE` are idempotent, whereas `POST` and `PATCH` are not.

Since we’ve decided that the server will create IDs for every Create operation, the Create operation in our API **is NOT idempotent.** Since the server will create a new ID (on every Create request), if you call Create twice - even with the same content - you’ll end up with two different objects with the same content, but with different IDs. That was a mouthful, so to summarize: Every Create request will generate a new ID, thus no idempotency.

![The Controller and Repository Layers](https://raw.githubusercontent.com/spring-academy/spring-academy-assets/main/courses/course-spring-brasb-build-a-rest-api/idempotency.jpg)

This leaves us with the `POST` and `PATCH` options. As it turns out, REST permits `POST` as one of the proper methods to use for Create operations, so we'll use it. We’ll revisit `PATCH` in a later lesson.

## The POST Request and Response

Now let’s talk about the content of the `POST` Request, and the Response.

### The Request

The `POST` method allows a Body, so we'll use the Body to send a JSON representation of the object:

Request:

- Method: `POST`
- URI: `/cashcards/`
- Body:
  ```
  {
      amount: 123.45
  }
  ```

In contrast, if you recall from a previous lesson, the `GET` operation includes the ID of the Cash Card in the URI, but _not_ in the request Body.

So why is there no ID in the Request? Because we decided to allow the server to create the ID. Thus, the data contract for the Read operation _is different_ from that of the Create operation.

### The Response

Let's move on to the Response. On successful creation, what HTTP Response Status Code should be sent? We could use `200 OK` (the response that Read returns), but there’s a more specific, more accurate code for REST APIs: `201 CREATED`.

The fact that `CREATED` is the name of the code makes it seem intuitively appropriate, but there’s another, more technical reason to use it: A response code of `200 OK` does _not_ answer the question “Was there any change to the server data?”. By returning the `201 CREATED` status, the API is specifically communicating that data was added to the data store on the server.

In a previous lesson you learned that an HTTP Response contains two things: a Status Code, and a Body. But that’s not all! A Response also contains **Headers**. Headers have a name and a value. The HTTP standard specifies that the `Location` header in a `201 CREATED` response should contain the URI of the created resource. This is handy because it allows the caller to easily fetch the new resource using the GET endpoint (the one we implemented prior).

Here is the complete Response:

Response:

- Status Code: `201 CREATED`
- Header: `Location=/cashcards/42`

### Spring Web Convenience Methods

In the accompanying lab, you’ll see that Spring Web provides methods which are geared towards the recommended use of HTTP and REST.

For example, we’ll use the `ResponseEntity.created(uriOfCashCard)` method to create the above response. This method requires you to specify the location, ensures the Location URI is well-formed (by using the `URI` class), adds the `Location` header, and sets the Status Code for you. And by doing so, this saves us from using more verbose methods. For example, the following two code snippets are equivalent (as long as
`uriOfCashCard` is not `null`):

```java
return  ResponseEntity
        .created(uriOfCashCard)
        .build();
```

Versus:

```java
return ResponseEntity
        .status(HttpStatus.CREATED)
        .header(HttpHeaders.LOCATION, uriOfCashCard.toASCIIString())
        .build();
```

Aren’t you glad Spring Web provides the `.created()` convenience method?
