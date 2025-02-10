/**
 * This is a template for a document that can be used to create a report.
 *
 * This uses the [CNAM](https://www.cnam.fr/) logo and colors.
 *
 * @author Tom Planche.
 * @license MIT.
 */

#import "@preview/i-figured:0.2.4"
#import "@preview/great-theorems:0.1.1": *

#let bodyFontSize = 12pt

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

#let icon(codepoint) = {
  box(
    height: 1em,
    baseline: 0.1em,
    image(codepoint)
  )
  h(0.1em)
}

/**
 * Create a block with a title.
 *
 * @param fill - The color of the background.
 * @param inset - The padding of the block.
 * @param radius - The radius of the block.
 * @param outline - The outline stroke of the block.
 * @param content - The content of the block.
 * @param align - The alignment of the block.
 */
#let my-block = (
  fill: luma(230),
  inset: 15pt,
  radius: 4pt,
  outline: none,
  alignment: center,
  content
) => {
  align(
    alignment,
    block(
      fill: fill,
      inset: inset,
      radius: radius,
      stroke: outline,
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

// Header
#let buildMainHeader(mainHeadingContent, author) = {
  [
    #smallcaps(mainHeadingContent) #h(1fr) #emph(author)
    #line(length: 100%)
  ]
}

#let buildSecondaryHeader(mainHeadingContent, secondaryHeadingContent, author) = {
  [
    #smallcaps(mainHeadingContent) #h(1fr) #emph(secondaryHeadingContent) #h(1fr)  #emph(author)
    #line(length: 100%)
  ]
}

// To know if the secondary heading appears after the main heading
#let isAfter(secondaryHeading, mainHeading) = {
  let secHeadPos = secondaryHeading.location().position()
  let mainHeadPos = mainHeading.location().position()
  if (secHeadPos.at("page") > mainHeadPos.at("page")) {
    return true
  }
  if (secHeadPos.at("page") == mainHeadPos.at("page")) {
    return secHeadPos.at("y") > mainHeadPos.at("y")
  }
  return false
}

#let getHeader(
    author: "Tom Planche",
) = {
  context {
    // if we are on the first and second pages, we don't have any header
    // so we return an empty header
    if (here().page() <= 2) {
      return []
    }

    // Find if there is a level 1 heading on the current page
    let nextMainHeading = query(selector(heading).after(here())).find(headIt => {
     headIt.location().page() == here().page() and headIt.level == 1
    })

    if (nextMainHeading != none) {
      return buildMainHeader(nextMainHeading.body, author)
    }

    // Find the last previous level 1 heading -- at this point surely there's one :-)
    let lastMainHeading = query(selector(heading).before(here())).filter(headIt => {
      headIt.level == 1
    }).last()

    // Find if the last level > 1 heading in previous pages
    let previousSecondaryHeadingArray = query(selector(heading).before(here())).filter(headIt => {
      headIt.level > 1
    })

    let lastSecondaryHeading = if (previousSecondaryHeadingArray.len() != 0) {previousSecondaryHeadingArray.last()} else {none}

    // Find if the last secondary heading exists and if it's after the last main heading
    if (lastSecondaryHeading != none and isAfter(lastSecondaryHeading, lastMainHeading)) {
      return buildSecondaryHeader(lastMainHeading.body, lastSecondaryHeading.body, author)
    }

    return buildMainHeader(lastMainHeading.body, author)
  }
}

#let code(
  line-spacing: 5pt,
  line-offset: 5pt,
  numbering: true,
  inset: 5pt,
  radius: 3pt,
  number-align: right,
  stroke: 1pt + luma(180),
  fill: luma(250),
  text-style: (size: 8pt, font: "Fira Code"),
  width: 100%,
  lines: auto,
  lang: none,
  lang-box: (
    gutter: 5pt,
    radius: 3pt,
    outset: 1.75pt,
    fill: rgb("#ffbfbf"),
    stroke: 1pt + rgb("#ff8a8a")
  ),
  source
) = {
  show raw.line: set text(..text-style)
  show raw: set text(..text-style)

  set par(justify: false, leading: line-spacing)

  let label-regex = regex("<((\w|_|-)+)>[ \t\r\f]*(\n|$)")

  let labels = source
    .text
    .split("\n")
    .map(line => {
      let match = line.match(label-regex)

      if match != none {
        match.captures.at(0)
      } else {
        none
      }
    })

  // We need to have different lines use different tables to allow for the text after the lang-box to go in its horizontal space.
  // This means we need to calculate a size for the number column. This requires AOT knowledge of the maximum number horizontal space.
  let number-style(number) = text(
    size: 1.25em,
    raw(str(number))
  )

  let unlabelled-source = source.text.replace(
    label-regex,
    "\n"
  )

  show raw.where(block: true): it => context {
    let lines = lines

    if lines == auto {
      lines = (auto, auto)
    }

    if lines.at(0) == auto {
      lines.at(0) = 1
    }

    if lines.at(1) == auto {
      lines.at(1) = it.lines.len()
    }

    lines = (lines.at(0) - 1, lines.at(1))

    let maximum-number-length = measure(number-style(lines.at(1))).width

    block(
      inset: inset,
      radius: radius,
      stroke: stroke,
      fill: fill,
      width: width,
      {
        stack(
          dir: ttb,
          spacing: line-spacing,
          ..it
            .lines
            .slice(..lines)
            .map(line => table(
              stroke: none,
              inset: 0pt,
              columns: (maximum-number-length, 1fr, auto),
              column-gutter: (line-offset, if line.number - 1 == lines.at(0) { lang-box.gutter } else { 0pt }),
              align: (number-align, left, top + right),
              if numbering {
                text(
                    ..text-style,
                    fill: gray,
                    str(line.number)
                )
              },
              {
                let line-label = labels.at(line.number - 1)

                if line-label != none {
                  show figure: it => it.body

                  counter(figure.where(kind: "sourcerer")).update(line.number - 1)
                  [
                    #figure(supplement: "Line", kind: "sourcerer", outlined: false, line)
                    #label(line-label)
                  ]
                } else {
                  line
                }
              },
              if line.number - 1 == lines.at(0) and lang != none {
                rect(
                  fill: lang-box.fill,
                  stroke: lang-box.stroke,
                  inset: 0pt,
                  outset: lang-box.outset,
                  radius: radius,
                  text(size: 1.25em, lang)
                )
              }
            ))
            .flatten()
        )
      }
    )
  }

  raw(block: true, lang: source.lang, unlabelled-source)
}

// Maths
// #let math-definition = (
//   title: "Définition",
//   content,
// ) => {
//   my-block(
//     fill: luma(230),
//     content: [
//       bold(title),
//       content
//     ]
//   )
// }

#let ar = name => $accent(#name, harpoon)$

#show heading: i-figured.reset-counters
#show math.equation: i-figured.show-equation.with(
  level: 3,
  zero-fill: false,
  leading-zero: true,
  numbering: "(1.1)",
  prefix: "eqt:",
  only-labeled: false,  // numbering all block equations implicitly
  unnumbered-label: "-",
)
#set math.equation(number-align: bottom)

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
  let body-font = "New Computer Modern Math"
  let title-font = "New Computer Modern Math"

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
    header-ascent: 50%,
    footer-descent: 50%,
    margin: (
        top: 3cm,
        right: 1cm,
        bottom: 1.75cm,
        left: 1cm
    ),
    numbering: "1 / 1",
    number-align: bottom + right,
  )

  show: great-theorems-init

  // paragraph
  set par(justify: true)

  // customize look of figure
  set figure.caption(separator: [ --- ], position: top)

  // Set body font family.
  set text(font: body-font, size: bodyFontSize)

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
  show heading: it => it + v(.5em)

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
  let side-padding = .35em;
  show raw.where(block: false) : it => h(side-padding) + box(fill: primary-color.lighten(90%), outset: (x: .25em, y: .5em), radius: 2pt, it) + h(side-padding)


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

  // MATHS
  // show math.equation: i-figured.show-equation.with(
  //   level: 1,
  //   zero-fill: true,
  //   leading-zero: true,
  //   numbering: "(1.1)",
  //   prefix: "eqt:",
  //   only-labeled: false,  // numbering all block equations implicitly
  //   unnumbered-label: "-",
  // )

  v(2fr)

  line(length: 100%, stroke: primary-color)
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
      text(1.1em,
        if start-date == last-updated-date {
          date-format(start-date)
        } else {
          date-format(start-date) + " - " + date-format(last-updated-date)
        }
      )
  )
  v(2em, weak: true)
  line(length: 100%, stroke: primary-color)

  v(2fr)

  // Author information.
  let school-year = if start-date.month() < 9 { int(year) - 1 } else { int(year) }
  let next-year = str(school-year + 1)

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
      str(school-year) + "-" + str(next-year) + "\n" + emph[#class],
      14pt)
  }

  place(
    bottom + center,
    dy: 5%,
    align(center)[
      #bottom-text
    ]
  )

  set page(header: getHeader(author: author))

  pagebreak()
  outline()
  pagebreak()


  body
}
