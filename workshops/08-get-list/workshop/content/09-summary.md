In this lab, we implemented a "GET many" endpoint and added sorting and pagination. These accomplished two things:

1. Ensured that the data received from the server is in a predictable and understandable order.
1. Protected the client and server from being overwhelmed by a large amount of data
   (the page size puts a cap on the amount of data that can be returned in a single response).
