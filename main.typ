#import "conf.typ": *

#import "@preview/codly:1.0.0": *
#show: codly-init.with()

#show: conf.with(
  title: "Title",
  author: "Tom Planche",
  class: "Class name",
  subtitle: "Class subtitle",
  logo: image("assets/cnam_logo.svg"),
  start-date: datetime(day: 4, month: 9, year: 2024),
  main-color: "#C4122E",
)

#codly(
  zebra-fill: none
)

= Main title
== Subtitle
=== Subsubtitle

#my-block(
  [
  Custom Block
  ]
)

#blockquote([
  Custom Blockquote
])

```SQL
CREATE TABLE ELEVE (
  IDE        INT,
  NOM        VARCHAR(30),
  PRENOM     VARCHAR(30),
  ANNEENAISS NUMBER(4),
  ENTREPRISE VARCHAR(30),
  NOMTUTEUR  VARCHAR(50)
);
```
