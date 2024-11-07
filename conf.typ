/**
 * This is a template for a document that can be used to create a report.
 *
 * This uses the [CNAM](https://www.cnam.fr/) logo and colors.
 *
 * @author Tom Planche.
 * @license MIT.
 */

// FUNCTIONS
// Exported
/**
 * Create a blockquote.
 *
 * @param {string} color - The color of the text.
* @param {string} fill - The color of the background.
 */
#let blockquote = (
  color: luma(170),
  fill: luma(230),
  inset: (left: 1em, top: 10pt, right: 10pt, bottom: 10pt),
  radius: (
    top-right: 5pt,
    bottom-right: 5pt,
  ),
  stroke: (left: 2.5pt),
  content,
) => {
  rect(
    stroke: stroke,
    inset: inset,
    fill: fill,
    radius: radius,
    content
  )
}

/**
 * Create a block with a title.
 *
 * @param fill - The color of the background.
 * @param inset - The padding of the block.
 * @param radius - The radius of the block.
 * @param content - The content of the block.
 * @param align - The alignment of the block.
 */
#let my-block = (
  fill: luma(230),
  inset: 15pt,
  radius: 4pt,
  alignment: center,
  content
) => {
  align(
    alignment,
    block(
      fill: fill,
      inset: inset,
      radius: radius,
      content
    )
  )
}

// Inner
/**
 * Format a date to a __french__ format.
 */
#let date-format = (date) => {
    date.display("[day]/[month]/[year]")
}

// MAIN
#let conf(
  title: "",
  subtitle: "",
  author: "",
  affiliation: "",
  year: datetime.today().year(),
  class: none,
  start-date: datetime.today(),
  last-updated-date: datetime.today(),
  logo: none,
  main-color: "E94845",
  alpha: 80%,
  color-words: (),
  body,
) = {
  // VARS
  // Save heading and body font families in variables.
  let body-font = "Source Sans Pro"
  let title-font = "Barlow"

  // Colors
  let primary-color = rgb(main-color) // alpha = 100%

  // change alpha of primary color
  let secondary-color = rgb("#E28A97")

  // SETTINGS
  // document infos
  set document(author: author, title: title)
  set text(lang: "fr")

  // main settings
  set page(
    header: if [#context().page()] != [1] {
        [#emph()[#title #h(1fr) #author]]
    },
    header-ascent: 50%,
    footer-descent: 50%,
    margin: (
      top: 3cm,
      right: 1.5cm,
      bottom: 3cm,
      left: 1.5cm
    ),
    numbering: "1 / 1",
    number-align: bottom + right,
  )

  // paragraph
  set par(justify: true)

  // customize look of figure
  set figure.caption(separator: [ --- ], position: top)

  // Set body font family.
  set text(font: body-font, 12pt)

  // Headings font and color
  show heading: set text(font: title-font, fill: primary-color)

  // heading numbering
  set heading(numbering: (..nums) => {
    let level = nums.pos().len()

    let pattern = if level == 1 {
      "I -"
    } else if level == 2 {
      "  I. I -"
    } else if level == 3 {
      "    I. I .I -"
    } else if level == 4 {
      "     I. I. I. 1 -"
    }

    if pattern != none {
      numbering(pattern, ..nums)
    }
  })

  // space for heading
  show heading: it => it + v(1em)

  // Set link style
  show link: it => underline(text(fill: primary-color, it))

  // numbered list colored
  set enum(indent: 1em, numbering: n => [#text(fill: primary-color, numbering("1.", n))])

  // unordered list colored
  set list(indent: 1em, marker: n => [#text(fill: primary-color, "•")])

  // SCRIPTS
  // highlight important words
  show regex(if color-words.len() == 0 { "$ " } else { color-words.join("|") }): text.with(fill: primary-color)

  // customize inline raw code
  let side-padding = .5em;
  show raw.where(block: false) : it => h(side-padding) + box(fill: primary-color.lighten(90%), outset: side-padding, it) + h(side-padding)

  // DECORATIONS
  // Top left
  place(top + left, dx: -25%, dy: -28%, circle(radius: 150pt, fill: primary-color))
  place(top + left, circle(radius: 75pt, fill: secondary-color))

  // Bottom right
  place(bottom + right, dx: 25%, dy: 25%, circle(radius: 100pt, fill: secondary-color))

  // display of outline entries
  show outline.entry: it => text(size: 12pt, weight: "regular",it)

  // First page.
  if logo != none {
    set image(width: 6cm)
    place(
      top + right,
      dx: .5cm,
      dy: -1.5cm,
      logo
    )
  }

  show heading: i-figured.reset-counters
  show math.equation: i-figured.show-equation.with(
    level: 1,
    zero-fill: true,
    leading-zero: true,
    numbering: "(1.1)",
    prefix: "eqt:",
    only-labeled: false,  // numbering all block equations implicitly
    unnumbered-label: "-",
  )

  v(2fr)

  // Centered text
  // Title
  align(center, text(font: title-font, 2.5em, weight: 700, title))
  v(2em, weak: true)

  // Subtitle
  align(center, text(font: title-font, 2em, weight: 700, subtitle))
  v(2em, weak: true)

  // Date
  align(
    center,
    text(1.1em, date-format(start-date) + " - " + date-format(last-updated-date))
  )

  v(2fr)

  // Author information.
  let next-year = str(int(year) + 1)

  let bottom-text = text(
    author + "\n" +
    if (affiliation != "") {
      affiliation + "\n"
    } else {
      ""
    },
    14pt,
    weight: "bold"
  ) + if (class != "") {
    text(
      str(year) + "-" + str(next-year) + "\n" + emph[#class],
      14pt)
  }

  place(
    bottom + center,
    dy: 5%,
    align(center)[
      #bottom-text
    ]
  )

  pagebreak()

  body

}
