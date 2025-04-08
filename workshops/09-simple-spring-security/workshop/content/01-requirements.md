Who should be allowed to manage any given Cash Card?

In our simple domain, let's state that the user who _created_ the Cash Card "owns" the Cash Card. Thus, they are the "card owner". Only the card owner can view or update a Cash Card.

The logic will be something like this:

> IF the user is _authenticated_
>
> ... AND they are _authorized_ as a "card owner"
>
> ... ... AND they own the requested Cash Card
>
> THEN complete the users's request
>
> BUT don't allow users to access Cash Cards they do
> not own.
