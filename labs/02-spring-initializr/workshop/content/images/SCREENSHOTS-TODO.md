# Screenshot re-capture TODO (Spring Boot 4 upgrade)

These Initializr screenshots still show the Spring Boot 3 UI and must be
**manually re-captured** from https://start.spring.io — they cannot be
regenerated programmatically:

- `initializr-metadata.png` — must show **Spring Boot 4.0.x** selected in the
  version radios (and Java **17**, Gradle - Groovy, Jar).
- `initializr-dependencies.png` — must show the **Spring Web** dependency
  selected (unchanged selection; only the surrounding UI/version differs).

Matches the text change in `../01-spring-initializr.md` ("Choose the latest
**4.0.X** version"). Delete this file once the images are refreshed.
