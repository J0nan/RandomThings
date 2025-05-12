# CSRF PoC Generator

This simple HTML, is intended to generate forms to perform CSRF.

It can perform using GET, POST or PUT.

## How it works

### GET

With GET as the HTTP method selected, only the Target URL is necessary. When submitted, a form will be filled out and submitted.

### POST

With this two methods, a Content-Type and a Body are required, as well as the Targeted URL.

The Content-Type can be:

- `application/x-www-form-urlencoded`: With this method, the body must be a set of keys and values, like for example `key=value&key2=value2`. The JavaScript then parses the passed body into the different values of the form.
- `text/plain`: This method, follows the guide in this [link](https://anonymousyogi.medium.com/json-csrf-csrf-that-none-talks-about-c2bf9a480937#0b6b).

After filling up the forms, it is submitted.

### PUT

Using this method it performs the same as the [POST](#post), but it adds to the body: `_method=PUT`.

> https://book.hacktricks.wiki/en/pentesting-web/csrf-cross-site-request-forgery.html#method-bypass
