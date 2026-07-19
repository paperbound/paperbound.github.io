
// =====================================================================
//  Invitation  —  Prasanth & Sharon
// =====================================================================

#set document(
  author: "Prasanth",
)

// ---------- palette --------------------------------------------------

#let gold = rgb("#9a7b4f")
#let rose_gold = rgb("#c4956a")
#let soft_peach = rgb("#deb89c")
#let champagne = rgb("#dcc480")
#let warm_ivory = rgb("#d8c8a8")
#let ink = rgb("#2c2420")

#let confetti_palette = (
  gold,
  rose_gold,
  soft_peach,
  champagne,
  warm_ivory,
)

// ---------- confetti border ------------------------------------------
//
//  Renders a deterministic confetti scatter in a rectangular band around
//  the page edges, forming a decorative frame. The centre is left clear
//  so text remains fully readable.

#let confetti-border(seed: 42, count: 4000, band: 70, alpha: 92%) = {
  let golden_angle = 137.50776405deg
  let r_max = 870

  for i in range(count) {
    let theta = golden_angle * i
    let r = calc.sqrt(i / count) * r_max
    let xx = calc.round(500 + r * calc.cos(theta))
    let yy = calc.round(500 + r * calc.sin(theta) * 0.7048)

    if xx < 0 or xx > 1000 or yy < 0 or yy > 1000 { continue }

    // Keep only pieces inside the border band (near any edge)
    let in_band = (xx < band or xx > 1000 - band or yy < band or yy > 1000 - band)
    if not in_band { continue }

    let cc = calc.rem(i * 53 + seed * 7, 6)
    let dd = calc.rem(i * 71 + seed * 13, confetti_palette.len())
    let ee = calc.rem(i + seed, 5)
    let ff = calc.rem(i * 31 + seed * 19, 360)
    let color = confetti_palette.at(dd).transparentize(100% - alpha)

    let piece = if ee == 0 {
      // hollow triangle
      rotate(ff * 1deg, polygon.regular(
        size: (4.5 + cc * 0.5) * 1pt,
        vertices: 3,
        fill: none,
        stroke: 0.5pt + color,
      ))
    } else if ee == 1 {
      // filled triangle
      rotate(ff * 1deg, polygon.regular(
        size: (3.5 + cc * 0.4) * 1pt,
        vertices: 3,
        fill: color,
        stroke: none,
      ))
    } else if ee == 2 {
      // hollow ring
      circle(radius: (2.0 + cc * 0.3) * 1pt, fill: none, stroke: 0.6pt + color)
    } else if ee == 3 {
      // small filled square
      let side = (3.5 + cc * 0.4) * 1pt
      rotate(ff * 1deg, rect(width: side, height: side, fill: color, stroke: none))
    } else {
      // thin dash at angle (minimalist)
      rotate(ff * 1deg, rect(
        width: (5.5 + cc * 0.6) * 1pt,
        height: 0.7pt,
        fill: color,
        stroke: none,
        radius: 0.3pt,
      ))
    }

    place(top + left, dx: xx * 0.1%, dy: yy * 0.1%, piece)
  }
}

// ---------- decorative bits -----------------------------------------

#let cross(size: 12pt, fill: gold, tracking: 0pt) = text(
  font: ("Noto Sans Symbols2", "Noto Sans Symbols", "OpenSymbol"),
  size: size,
  fill: fill,
  tracking: tracking,
)[✝]

#let mini_divider() = align(center, text(size: 11pt, fill: gold)[
  · #h(0.4em) #cross(size: 11pt) #h(0.4em) ·
])

#let and_divider(word: "and", w: 58%) = align(center, box(width: w, grid(
  columns: (1fr, auto, 1fr),
  align: horizon,
  column-gutter: 0.7em,
  line(length: 100%, stroke: 0.4pt + gold),
  text(size: 13pt, style: "italic", fill: ink)[#word],
  line(length: 100%, stroke: 0.4pt + gold),
)))

#let ruled_cell(body) = {
  line(length: 100%, stroke: 0.4pt + gold)
  body
  line(length: 100%, stroke: 0.4pt + gold)
}

#let date_box(weekday, day, month, year, time, w: 88%) = align(center, box(width: w, grid(
  columns: (1fr, auto, 1fr),
  align: horizon + center,
  column-gutter: 1.4em,
  ruled_cell(text(size: 11pt, tracking: 1pt, fill: ink)[#time]),
  {
    text(size: 12pt, fill: ink)[#month]
    linebreak()
    text(size: 26pt, fill: ink)[#day]
    linebreak()
    text(size: 12pt, fill: ink)[#year]
  },
  ruled_cell(text(size: 11pt, tracking: 1pt, fill: ink)[#upper(weekday)]),
)))

// ---------- invitation template -------------------------------------

#set text(
  font: (
    "Libertinus Serif",
    "Noto Serif",
    "DejaVu Serif",
  ),
  size: 10.5pt,
  fill: ink,
  hyphenate: false,
)

#set par(leading: 0.65em, justify: false)

#let invitation(
  verse,
  name1,
  host1,
  address1,
  name2,
  host2,
  address2,
  invite_lines_1,
  invite_line_2,
  venue,
  weekday,
  day,
  month,
  year,
  time,
  reception,
  invite_line_3,
) = {
  set align(center)

  v(3em)

  upper(text(size: 10pt, style: "italic", verse, fill: gold))
  v(1.4em)
  smallcaps(text(size: 12pt, host1))
  smallcaps(text(size: 10pt, address1))

  v(0.5em)

  for line in invite_lines_1 {
    text(size: 10.5pt, style: "italic", line)
    linebreak()
  }

  v(0.1em)

  // The names — visual centerpiece.
  text(
    font: "Libertinus Serif",
    size: 26pt,
    fill: gold,
    tracking: 1pt,
  )[#name1]
  and_divider()
  v(0.1em)
  text(
    font: "Libertinus Serif",
    size: 26pt,
    fill: gold,
    tracking: 1pt,
  )[#name2]

  v(0.1em)
  text(size: 10.5pt, style: "italic", invite_line_2)
  v(0.2em)

  smallcaps(text(size: 12pt, host2))
  smallcaps(text(size: 10pt, address2))

  v(0.3em)
  mini_divider()
  v(0.5em)

  smallcaps(text(size: 11.5pt, weight: "semibold", venue))

  v(0.1em)

  date_box(weekday, day, month, year, time)

  v(0.5em)
  smallcaps(text(size: 9.5pt, style: "italic", reception))
  linebreak()
  smallcaps(text(size: 11pt, style: "italic", fill: gold)[#invite_line_3])
}
