# sslscan docker image

This docker image wraps the SSL Labs Scan binary to test a website's
SSL security.

## Getting Started

Run `make` to see what actions are available to you.

Once the docker image is built, you can do:

```
docker run -it --rm sslscan -grade www.google.com
```

