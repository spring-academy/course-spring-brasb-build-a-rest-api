Now that our API can **create** Cash Cards, it’s reasonable to learn how to fetch all (or some!) of the Cash Cards. In
this lesson, we’ll implement the “Read Many” endpoint, and understand how this operation differs substantially from the
Read endpoint that we previously created.

## Requesting a List of Cash Cards

We can expect each of our Family Cash Card users to have a few cards: imagine one for each of their family members, and perhaps a few
that they gave as gifts. The API should be able to return multiple Cash Cards in response to a single REST request.

When you make an API request for several Cash Cards, you’d ideally make a single request, which returns a list of Cash
Cards. So, we’ll need a new data contract. Instead of a single Cash Card, the new contract should specify that the
response is a JSON Array of Cash Card objects:

```json
[
  {
    "id": 1,
    "amount": 123.45
  },
  {
    "id": 2,
    "amount": 50.0
  }
]
```

It turns out that our old friend, `CrudRepository`, has a `findAll` method that we can use to easily fetch all the Cash
Cards in the database. Let's go ahead and use that method. At first glance, it looks quite simple:

```java
@GetMapping()
private ResponseEntity<Iterable<CashCard>> findAll() {
   return ResponseEntity.ok(cashCardRepository.findAll());
}
```

However, it turns out there’s a lot more to this operation than just returning all the Cash Cards in the database. Some
questions come to mind:

- How do I return only the Cash Cards that the user owns?
  (**Great question!** We’ll discuss this in the upcoming Spring Security lesson).
- What if there are hundreds (or thousands?!) of Cash Cards? Should the API return an unlimited number of results or
  return them in “chunks”? This is known as **Pagination**.
- Should the Cash Cards be returned in a particular order (i.e., should they be sorted?)?

We’ll leave the first question for later, but answer the pagination and sorting questions in this lesson. Let’s press on!

## Pagination and Sorting

To start our pagination and sorting work, we’ll use a specialized version of the `CrudRepository`, called
the `PagingAndSortingRepository.` As you might guess, this does exactly what its name suggests. But first, let’s
talk about the “Paging” functionality.

Even though we’re unlikely to have users with thousands of Cash Cards, we never know how users _might_ use
the product. Ideally, an API should **not** be able to produce a response with unlimited size, because this could
overwhelm the client or server memory, not to mention taking quite a long time!

In order to ensure that an API response doesn’t include an astronomically large number of Cash Cards, let’s utilize
Spring Data’s pagination functionality. Pagination in Spring (and many other frameworks) is to
specify the page length (e.g. 10 items), and the page index (starting with 0). For example, if a user has 25
Cash Cards, and you elect to request the second page where each page has 10 items, you would request a page of size 10,
and page index of 1.

Bingo! Right? But wait, this brings up another hurdle. In order for pagination to produce the correct page content,
the items must be sorted in some specific order. Why? Well, let’s say we have a bunch of Cash Cards with the following amounts:

- `$0.19` (this one’s pretty much all gone, oh well!)
- `$1,000.00` (this one is for emergency purchases for a university student)
- `$50.00`
- `$20.00`
- `$10.00` (someone gifted this one to your niece for her birthday)

Now let’s go through an example using a page size of 3. Since there are 5 Cash Cards, we’d make two requests in order to
return all of them. Page 1 (index 0) contains three items, and page 2 (index 1, the last page) contains 2 items. But
which items go where? If you specify that the items should be sorted by `amount` in descending order, then this is how
the data is paginated:

Page 1:

1. `$1,000.00`
2. `$50.00`
3. `$20.00`

Page 2:

1. `$10.00`
2. `$0.19`

### Regarding Unordered Queries

Although Spring does provide an “unordered” sorting strategy, let’s be explicit when we select which fields for sorting.
Why do this? Well, imagine you elect to use “unordered” pagination. In reality, the order is not random,
but instead predictable; it never changes on subsequent requests. Let’s say you make a request, and Spring returns the
following “unordered” results:

Page 1:

1. `$0.19`
2. `$1,000.00`
3. `$50.00`

Page 2:

1. `$20.00`
2. `$10.00`

Although they look random, every time you make the request, the cards will come back in exactly this order, so that each
item is returned on exactly one page.

Now for the punchline: Imagine you now create a new Cash Card with an amount of $42.00. Which page do you think it will
be on? As you might guess, there’s no way to know other than making the request and seeing where the new Cash
Card lands.

So how can we make this a bit more useful? Let’s opt for ordering by a specific field. There are a few good reasons to
do so, including:

- Minimize **cognitive overhead**: Other developers (not to mention users) will probably appreciate a thoughtful ordering
  when developing it.
- Minimize future errors: What happens when a new version of Spring, or Java, or the database, suddenly causes the
  “random” order to change overnight?

### Spring Data Pagination API

Thankfully, Spring Data provides the `PageRequest` and `Sort` classes for pagination. Let’s look at a query to get page
2 with page size 10, _sorting by amount in descending order_ (largest amounts first):

```java
Page<CashCard> page2 = cashCardRepository.findAll(
    PageRequest.of(
        1,  // page index for the second page - indexing starts at 0
        10, // page size (the last page might have fewer items)
        Sort.by(new Sort.Order(Sort.Direction.DESC, "amount"))));
```

### The Request and Response

Now let’s use Spring Web to extract the data to feed the pagination functionality:

- **Pagination:** Spring can parse out the `page` and `size` parameters if you pass a `Pageable` object to
  a `PagingAndSortingRepository find…()`method.
- **Sorting:** Spring can parse out the `sort` parameter, consisting of the field name and the direction separated by a
  comma – but be careful, no space before or after the comma is allowed! Again, this data is part of the `Pageable` object.

### The URI

Now let’s learn how we can compose a URI for the new endpoint, step-by-step (we've omitted the `https://domain` prefix in the following):

1. Get the second page
   <pre>/cashcards<b>?page=1</b></pre>
2. …where a page has length of 3
   <pre>/cashcards?page=1<b>&size=3</b></pre>
3. …sorted by the current Cash Card balance
   <pre>/cashcards?page=1&size=3<b>&sort=amount</b></pre>
4. …in descending order (highest balance first)
   <pre>/cashcards?page=1&size=3&sort=amount<b>,desc</b></pre>

### The Java Code

Let’s go over the complete implementation of the Controller method for our new “get a page of Cash Cards” endpoint:

```java
@GetMapping
private ResponseEntity<List<CashCard>> findAll(Pageable pageable) {
   Page<CashCard> page = cashCardRepository.findAll(
           PageRequest.of(
                   pageable.getPageNumber(),
                   pageable.getPageSize(),
                   pageable.getSortOr(Sort.by(Sort.Direction.DESC, "amount"))));
   return ResponseEntity.ok(page.getContent());
}
```

Let’s dive into a bit more detail:

- First let’s parse the needed values out of the query string:
  - We use `Pageable`, which allows Spring to parse out the `page` number and `size` query string parameters.
    - Note: If the caller doesn’t provide the parameters, Spring provides defaults: `page=0, size=20`.
- We use `getSortOr()` so that even if the caller doesn’t supply the `sort` parameter, there is a default. Unlike
  the `page` and `size` parameters, for which it makes sense for Spring to supply a default, it wouldn’t make sense for
  Spring to arbitrarily pick a sort field and direction.
- We use the `page.getContent()` method to return the Cash Cards contained in the `Page` object to the caller.

So, what does the `Page` object contain besides the Cash Cards? Here's the `Page` object in JSON format. The Cash Cards are contained in the `content`. The rest of the fields contain information about how this Page is related to other Pages in the query.

```json
{
  "content": [
    {
      "id": 1,
      "amount": 10.0
    },
    {
      "id": 2,
      "amount": 0.19
    }
  ],
  "pageable": {
    "sort": {
      "empty": false,
      "sorted": true,
      "unsorted": false
    },
    "offset": 3,
    "pageNumber": 1,
    "pageSize": 3,
    "paged": true,
    "unpaged": false
  },
  "last": true,
  "totalElements": 5,
  "totalPages": 2,
  "first": false,
  "size": 3,
  "number": 1,
  "sort": {
    "empty": false,
    "sorted": true,
    "unsorted": false
  },
  "numberOfElements": 2,
  "empty": false
}
```

Although we could return the entire Page object to the client, we don't need all that information. We'll define our data contract to only return the Cash Cards, not the rest of the Page data.
