Let's turn our attention back to our Steel Thread, concentrating on another component of the architecture: Security.

## What Is Security?

Software Security can mean many things. The field is a huge topic that deserves its own course. In this lesson, we’ll talk about Web Security. More specifically we'll cover how HTTP Authentication and Authorization work, common ways in which the web ecosystem is vulnerable to attacks, and how we can use Spring Security to prevent unauthorized access to our Family Cash Card service.

## Authentication

A user of an API can actually be a person or another program, so often we’ll use the term **Principal** as a synonym for “user”. **Authentication** is the act of a Principal proving its identity to the system. One way to do this is to provide credentials (e.g. a username and password using **Basic Authentication**). We say that once the proper credentials have been presented, the Principal is authenticated, or in other words, the user has successfully logged in.

HTTP is a stateless protocol, so each request must contain data that proves it’s from an authenticated Principal. Although it’s possible to present the credentials on every request, doing so is inefficient because it requires more processing on the server. Instead, an **Authentication Session** (or Auth Session, or just Session) is created when a user gets authenticated. Sessions can be implemented in many ways. We’ll use a common mechanism: A **Session Token** (a string of random characters) that is generated, and placed in a **Cookie**. A Cookie is a set of data stored in a web client (such as a browser), and associated with a specific URI.

A couple of nice things about Cookies:

- Cookies are automatically sent to the server with every request (no extra code needs to be written for this to happen). As long as the server checks that the Token in the Cookie is valid, unauthenticated requests can be rejected.
- Cookies can persist for a certain amount of time even if the web page is closed and later re-visited. This ability typically improves the user experience of the web site.

## Spring Security and Authentication

**Spring Security** implements authentication in the **Filter Chain**. The Filter Chain is a component of Java web architecture which allows programmers to define a sequence of methods that get called prior to the Controller. Each filter in the chain decides whether to allow request processing to continue, or not. Spring Security inserts a filter which checks the user’s authentication and returns with a `401 UNAUTHORIZED` response if the request is not authenticated.

## Authorization

Up until now we’ve discussed authentication. But in reality, authentication is only the first step. **Authorization** happens after authentication, and allows different users of the same system to have different permissions.

Spring Security provides Authorization via **Role-Based Access Control (RBAC)**. This means that a Principal has a number of **Roles**. Each resource (or operation) specifies which Roles a Principal must have in order to perform actions with proper authorization. For example, a user with an Administrator Role is likely to be authorized to perform more actions than a user with a Card Owner Role. You can configure role-based authorization at both a global level and a per-method basis.

## Same Origin Policy

The web is a dangerous place, where bad actors are constantly trying to exploit security vulnerabilities. The most basic mechanism of protection relies on HTTP clients and servers implementing the **Same Origin Policy (SOP)**. This policy states that only scripts which are contained in a web page are allowed to send requests to the origin (URI) of the web page.

SOP is critical to the security of web sites because without the policy, anyone could write a web page containing a script which sends requests to any other site. For example, let’s look at a typical banking web site. If a user is logged into their bank account and visits a malicious web page (in a different browser tab or window), the malicious requests could be sent (with the Auth Cookies) to the banking site. This could result in unwanted actions–like a withdrawal from the user’s bank account!

### Cross-Origin Resource Sharing

Sometimes a system consists of services running on several machines with different URIs (i.e. Microservices). **Cross-Origin Resource Sharing (CORS)** is a way that browsers and servers can cooperate to relax the SOP. A server can explicitly allow a list of “allowed origins” of requests coming from an origin outside the server’s.

Spring Security provides the `@CrossOrigin` annotation, allowing you to specify a list of allowed sites. Be careful! If you use the annotation _without_ any arguments, it will allow _all_ origins, so bear this in mind!

## Common Web Exploits

Along with exploiting known security vulnerabilities, malicious actors on the web are also constantly discovering new vulnerabilities. Thankfully, Spring Security provides a powerful tool set to guard against common security exploits. Let’s discuss two common exploits, how they work, and how Spring Security helps to mitigate them.

### Cross-Site Request Forgery

One type of vulnerability is a **Cross-Site Request Forgery (CSRF)** which is often pronounced **“Sea-Surf”**, and also known as **Session Riding**. Session Riding is actually enabled by Cookies. CSRF attacks happen when a malicious piece of code sends a request to a server where a user is authenticated. When the server receives the Authentication Cookie, it has no way of knowing if the victim sent the harmful request unintentionally.

To protect against CSRF attacks, you can use a **CSRF Token**. A CSRF Token is different from an Auth Token because a unique token is generated on each request. This makes it harder for an outside actor to insert itself into the “conversation” between the client and the server.

Thankfully, Spring Security has built-in support for CSRF tokens which is enabled by default. You’ll learn more about this in the upcoming lab.

### Cross-Site Scripting

Perhaps even more dangerous than CSRF vulnerability is **Cross-Site Scripting (XSS)**. This occurs when an attacker is somehow able to “trick” the victim application into executing arbitrary code. There are many ways to do this. A simple example is saving a string in a database containing a `<script>` tag, and then waiting until the string is rendered on a web page, resulting in the script being executed.

XSS is potentially more dangerous than CSRF. In CSRF, only actions that a user is authorized to do can be executed. However in XSS, _arbitrary malicious code_ executes _on the client or on the server_. Additionally, XSS attacks don’t depend on Authentication. Rather, XSS attacks depend on security “holes” caused by poor programming practices.

The main way to guard against XSS attacks is to properly process all data from external sources (like web forms and URI query strings). In the case of our `<script>` tag example, attacks can be mitigated by properly escaping the special HTML characters when the string is rendered.

Phew! That’s it for our brief introduction to Web Security. Web Security is a large and diverse topic, but now you have a broad sense of how you can use Spring Security to protect your users and applications!
