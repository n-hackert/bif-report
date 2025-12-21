// #import "formatters.typ": display_abstract

#let report(
  // title
  title: "title placeholder",
  // date
  date: datetime.today(),
  // author
  author: "Nicolaj Hackert",
  // body block
  body
) = {

  /*******
    RULES
  ********/  

  // document metadata
  set document(
    title: title,
  )

  // layout
  // font settings
  set text(
    size: 12pt,
    font: ("arial"),
  )

  // page layout
  set page(
    paper: "a4",
    margin: 1in,
  )

  // paragraph appearance
  set par(
    justify: true,
  )

  // set heading(numbering: "1.")

  // customize heading ref behaviour
  // this seems to be the most concise way to do this
  // as where clauses don't work here
  show ref: it => {
    let el = it.element
    if el != none and el.func() == heading {
      // Display just the heading text
      link(it.target, el.body)
    } else {
      it
    }
  }

  // figure things

  // breakability
  // TODO: figure out why this makes sense
  show figure: set block(width: 100%, spacing: 1.6em, breakable: true)

  // caption layout the way we like it
  show figure.caption: it => context [
    #block(width: 100%)[
      #set align(left)
      #set text(10pt)
      *#it.supplement #it.counter.display(it.numbering)* | #it.body
    ]
  ]

  /**********
    DOCUMENT
  ***********/
  // header block
  block()[
    #align(center)[
      // TODO: find inspiring font
      #text(font: "Arial")[
        Boehringer Ingelheim Fonds MD fellowship report
      ]
    ]

    #text(size: 16pt, weight: "bold")[#title]

    #author
    #h(1fr)
    #date.display("[day].[month].[year]")
    #v(1em)
    #line(length: 100%)
  ]

  // content, including all sections and refs
  body
}
