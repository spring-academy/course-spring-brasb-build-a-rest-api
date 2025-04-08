We’ve made some decisions about how our API will support creating Family Cash Cards:

- The API will accept POST requests to create a Cash Card.
- The server will create IDs for all Cash Cards.
- On success, the API will return a Response with Status Code: `201 CREATED`, containing the URI (location) of the new Cash Card
  resource in the Response headers.

In the lab, we’ll implement these decisions!
