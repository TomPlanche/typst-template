/**
 * Mainly inspired by: @sebaseb98's clean-math-thesis.
 * @see https://github.com/sebaseb98/clean-math-thesis
 */

#import "@preview/great-theorems:0.1.1": *
#import "@preview/headcount:0.1.0": *

#import "colors.typ": *

#let definition_counter = counter("definition")
#let example_counter = counter("example")

#let my-definition-definition = mathblock.with(
    radius: 0.3em,
    inset: 0.8em,
    numbering: dependent-numbering("1.1"),
    breakable: false,
    titlix: title => [(#title): ],
    counter: definition_counter,
)

#let my-example-definition = mathblock.with(
    radius: 0.3em,
    inset: 0.8em,
    numbering: dependent-numbering("1.1"),
    breakable: false,
    titlix: title => [(#title): ],
    counter: example_counter,
)

#let definition = my-definition-definition(
  blocktitle: "Definition",
  fill: color5.lighten(95%),
  stroke: color5.darken(20%),
)

#let example = my-example-definition(
  blocktitle: "Example",
  fill: color2.lighten(90%),
  stroke: color2.darken(20%),
)
