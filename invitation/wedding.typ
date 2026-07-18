// =====================================================================
//  Wedding invitation  —  Prasanth & Sharon
// =====================================================================

#set document(
  title: "Prasanth & Sharon — Invitations",
  author: "Prasanth",
)

// ---------- palette --------------------------------------------------

#let gold = rgb("#9a7b4f")
#let rose_gold = rgb("#c4956a")
#let blush = rgb("#d4a8a8")
#let soft_peach = rgb("#deb89c")
#let champagne = rgb("#dcc480")
#let warm_ivory = rgb("#d8c8a8")
#let ink = rgb("#2c2420")

#let confetti_palette = (
  gold,
  rose_gold,
  blush,
  soft_peach,
  champagne,
  warm_ivory,
)

// ---------- confetti border ------------------------------------------
//
//  Renders a deterministic confetti scatter in a rectangular band around
//  the page edges, forming a decorative frame. The centre is left clear
//  so text remains fully readable.

#let confetti-border(seed: 42, count: 4000, band: 81, alpha: 92%) = {
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
      // small plus / cross (two perpendicular bars)
      let arm = (3.5 + cc * 0.4) * 1pt
      let th = 0.8pt
      rotate(ff * 1deg, place(center + horizon, stack(
        dir: ltr,
        spacing: -arm / 2,
        rect(width: arm, height: th, fill: color, stroke: none),
        place(center + horizon, rect(width: th, height: arm, fill: color, stroke: none)),
      )))
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

// ---------- page setup ----------------------------------------------

#set page(
  paper: "a5",
  margin: (x: 1cm, y: 1cm),
  background: context {
    let pn = counter(page).get().first()
    confetti-border(seed: pn)
  },
)

// Body font: Libertinus Serif — a high-quality open-source serif with
// true italics and small-caps support.
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

// Date panel: the day set large in the centre with the month above and the
// year below, flanked by weekday and time — each between its own thin gold
// rules. No vertical dividers; the three columns share a common midline.
#let ruled_cell(body) = {
  line(length: 100%, stroke: 0.4pt + gold)
  v(0.15em)
  body
  v(0.15em)
  line(length: 100%, stroke: 0.4pt + gold)
}

#let date_box(weekday, day, month, year, time, w: 88%) = align(center, box(width: w, grid(
  columns: (1fr, auto, 1fr),
  align: horizon + center,
  column-gutter: 1.4em,
  ruled_cell(text(size: 14pt, tracking: 1pt, fill: ink)[#time]),
  {
    text(size: 12pt, fill: ink)[#month]
    v(0.01em)
    text(size: 26pt, fill: ink)[#day]
    v(0.01em)
    text(size: 12pt, fill: ink)[#year]
  },
  ruled_cell(text(size: 14pt, tracking: 1pt, fill: ink)[#smallcaps(weekday)]),
)))

// ---------- invitation template -------------------------------------

#let invitation(
  hosts,
  invite_lines,
  ceremony_intro,
  venue,
  city,
  weekday,
  day,
  month,
  year,
  time,
  reception,
) = {
  set align(center)

  v(4.75em)

  smallcaps(text(size: 12pt, hosts, fill: rose_gold))

  v(0.45em)

  for line in invite_lines {
    text(size: 10.5pt, style: "italic", line)
    linebreak()
  }

  v(0.35em)

  // The names — visual centerpiece.
  text(
    font: "Libertinus Serif",
    size: 26pt,
    style: "italic",
    fill: gold,
    tracking: 1pt,
  )[Prasanth]
  v(0.15em)
  and_divider()
  v(0.15em)
  text(
    font: "Libertinus Serif",
    size: 26pt,
    style: "italic",
    fill: gold,
    tracking: 1pt,
  )[Sharon]

  v(0.35em)

  text(size: 10pt, ceremony_intro)
  v(0.25em)
  smallcaps(text(size: 11.5pt, weight: "semibold", venue))
  linebreak()
  smallcaps(text(size: 10pt, style: "italic", city))

  v(0.35em)
  mini_divider()
  v(0.5em)

  date_box(weekday, day, month, year, time)

  smallcaps(text(size: 9.5pt, style: "italic", reception))
}

#invitation(
  [
    Dr. Shaji Tharasseril & Dr. Asha \
  ],
  (
    [request the honour of your presence],
    [at the marriage of],
  ),
  [at the],
  [Holy Family Roman Catholic Church],
  [Kollam],
  "Monday",
  "31",
  "August",
  "2026",
  "10:30 a.m",
  [Reception to follow at the \ *Younus Convention Center, Kollam* \ from 12:00 noon to 3:00 in the afternoon],
)

