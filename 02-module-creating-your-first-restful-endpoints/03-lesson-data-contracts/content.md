We're developing an API. This brings up a lot of questions about how the API should behave:

- How should API consumers interact with the API?
- What data do consumers need to send in various scenarios?
- What data should the API return to consumers, and when?
- What does the API communicate when it's used incorrectly (or something goes wrong)?

Whenever possible, API providers and consumers should discuss these scenarios and come to agreements. Better yet, they should document these agreements not only in a shared documentation system, but also in a way that supports automated tests passing (or failing) based upon these decisions.

This is where the concept of contracts comes in.

## API Contracts

The software industry has adopted several patterns for capturing agreed upon API behavior in documentation and code. These agreements are often called "contracts". Two examples include Consumer Driven Contracts and Provider Driven Contracts. We'll provide resources for these patterns, but won't discuss them in detail in this course. Instead, we'll discuss a lightweight concept called API contracts.

We define an API contract as a formal agreement between a software provider and a consumer that abstractly communicates how to interact with each other. This contract defines how API providers and consumers interact, what data exchanges looks like, and how to communicate success and failure cases.

The provider and consumers do not have to share the same programming language, only the same API contracts. For the Family Cash Card domain, let’s assume that currently there's one contract between the Cash Card service and all services using it. Below is an example of that first API contract. Don't worry if you don't understand the entire contract. We'll address every aspect of the information below as you complete this course.

```
Request
  URI: /cashcards/{id}
  HTTP Verb: GET
  Body: None

Response:
  HTTP Status:
    200 OK if the user is authorized and the Cash Card was successfully retrieved
    401 UNAUTHORIZED if the user is unauthenticated or unauthorized
    404 NOT FOUND if the user is authenticated and authorized but the Cash Card cannot be found
  Response Body Type: JSON
  Example Response Body:
    {
      "id": 99,
      "amount": 123.45
    }
```

### Why Are API Contracts Important?

API contracts are important because they communicate the behavior of a REST API. They provide specific details about the data being serialized (or deserialized) for each command and parameter being exchanged. The API contracts are written in such a way that can be easily translated into API provider and consumer functionality, and corresponding automated tests. We'll implement both API provider functionality and automated tests in the labs.

## What Is JSON?

JSON (Javascript Object Notation) provides a data interchange format that represents the particular information of an object in a format that you can easily read and understand. We'll use JSON as our data interchange format for the Family Cash Card API.

Here's the example we used above:

```json
{
  "id": 99,
  "amount": 123.45
}
```

Other popular data formats include YAML (Yet Another Markup Language) and XML (Extensible Markup Language). When compared to XML, JSON reads and writes quicker, is easier to use, and takes up less space. You can use JSON with most modern programming languages and on all major platforms. It also works seamlessly with Javascript-based applications.

For these reasons, JSON has largely superseded XML as the most widely used format for APIs used by Web apps, including REST APIs.
