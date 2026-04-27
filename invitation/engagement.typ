// =====================================================================
//  Engagement invitation  —  Prasanth & Sharon
// =====================================================================

#set document(
  title: "Prasanth & Sharon — Invitations",
  author: "Prasanth",
)

// ---------- palette --------------------------------------------------

#let gold       = rgb("#9a7b4f")
#let gold_light = rgb("#c89d68")
#let blush      = rgb("#d4a8a8")
#let sage       = rgb("#a8b89c")
#let lilac      = rgb("#b8a4c8")
#let champagne  = rgb("#e8c987")
#let dusty_blue = rgb("#a8b8d0")
#let ink        = rgb("#1f2a44")

#let confetti_palette = (
  gold, gold_light, blush, sage, lilac, champagne, dusty_blue,
)

// ---------- page setup ----------------------------------------------

#set page(
  paper: "a5",
  margin: (x: 1.4cm, y: 1.2cm),
  background: {
    // Outer border
    place(top + left, dx: 0.55cm, dy: 0.55cm,
      rect(width: 100% - 1.1cm, height: 100% - 1.1cm,
           stroke: 0.4pt + gold))
    // Inner border
    place(top + left, dx: 0.78cm, dy: 0.78cm,
      rect(width: 100% - 1.56cm, height: 100% - 1.56cm,
           stroke: 0.25pt + gold))
    // Corner floral motifs near each outer-border corner
    let corner = text(size: 11pt, fill: gold)[❦]
    place(top + left,     dx:  0.42cm, dy:  0.32cm, corner)
    place(top + right,    dx: -0.42cm, dy:  0.32cm, corner)
    place(bottom + left,  dx:  0.42cm, dy: -0.32cm, corner)
    place(bottom + right, dx: -0.42cm, dy: -0.32cm, corner)
  },
)

#set text(
  font: ("Libertinus Serif", "EB Garamond", "Linux Libertine"),
  size: 10.5pt,
  fill: ink,
  hyphenate: false,
)

#set par(leading: 0.65em, justify: false)

// ---------- confetti band -------------------------------------------
//
//  Deterministic scatter of small shapes at the top.
//  Pass a different `seed` to vary the pattern between pages.
//  `clip: true` keeps stray pieces inside the band.

#let confetti(seed: 0, count: 60, height: 1.25cm) = block(
  width: 100%, height: height, clip: true, breakable: false,
)[
  #for i in range(count) [
    #let xx = calc.rem(i * 137 + seed * 53 + 11, 100)
    #let yy = calc.rem(i * 89  + seed * 17 +  7,  34)
    #let cc = calc.rem(i * 53  + seed *  7,        6)
    #let dd = calc.rem(i * 71  + seed * 13, confetti_palette.len())
    #let ee = calc.rem(i + seed, 5)
    #let ff = calc.rem(i * 31  + seed * 19, 360)
    #let color = confetti_palette.at(dd)
    #let piece = if ee == 0 {
      // filled dot
      circle(radius: (1.4 + cc * 0.25) * 1pt, fill: color, stroke: none)
    } else if ee == 1 {
      // small filled diamond
      rotate(45deg, square(size: (2.6 + cc * 0.35) * 1pt, fill: color, stroke: none))
    } else if ee == 2 {
      // paper streamer
      rotate(ff * 1deg, rect(
        width: (4.5 + cc) * 1pt, height: 1.3pt,
        fill: color, stroke: none, radius: 0.5pt,
      ))
    } else if ee == 3 {
      // tiny ring (a wink at wedding rings)
      circle(radius: (1.2 + cc * 0.2) * 1pt, fill: none, stroke: 0.5pt + color)
    } else {
      // small triangle
      rotate(ff * 1deg, polygon.regular(
        size: (3.5 + cc * 0.4) * 1pt, vertices: 3,
        fill: color, stroke: none,
      ))
    }
    #place(top + left, dx: xx * 1%, dy: yy * 1pt, piece)
  ]
]

// ---------- decorative bits -----------------------------------------

#let ornament(w: 55%) = align(center, box(width: w)[
  #stack(
    spacing: -0.65em,
    line(length: 100%, stroke: 0.4pt + gold),
    align(center, text(size: 12pt, fill: gold)[❦]),
    line(length: 100%, stroke: 0.4pt + gold),
  )
])

#let petals_row() = align(center, text(
  size: 10pt, fill: gold, tracking: 8pt,
)[❦ ❦ ❦])

#let mini_divider() = align(center, text(
  size: 11pt, fill: gold, tracking: 6pt,
)[· ❦ ·])

#let label(t) = align(center, text(
  size: 9pt, tracking: 4pt, fill: gold,
)[#upper(t)])

// ---------- invitation template -------------------------------------

#let invitation(
  occasion_label,
  hosts,
  invite_lines,
  ceremony_intro,
  venue,
  city,
  date_line,
  reception,
  seed: 0,
) = {
  set align(center)

  // confetti at the very top
  confetti(seed: seed)

  v(0.1em)
  label(occasion_label)
  v(0.25em)
  ornament()
  v(0.55em)

  text(size: 12.5pt, hosts)

  v(0.55em)

  for line in invite_lines {
    text(size: 10.5pt, style: "italic", line)
    linebreak()
  }

  v(0.45em)
  petals_row()
  v(0.25em)

  // The names — visual centerpiece
  text(size: 26pt, style: "italic", fill: gold, tracking: 1pt)[Prasanth]
  v(-0.25em)
  text(size: 18pt, fill: ink, style: "italic")[#sym.amp]
  v(-0.25em)
  text(size: 26pt, style: "italic", fill: gold, tracking: 1pt)[Sharon]

  v(0.55em)

  text(size: 10pt, ceremony_intro)
  v(0.25em)
  text(size: 11.5pt, weight: "semibold", venue)
  linebreak()
  text(size: 10pt, style: "italic", city)

  v(0.4em)
  text(size: 10pt, date_line)

  v(0.55em)
  mini_divider()
  v(0.35em)

  text(size: 9.5pt, style: "italic", reception)

  v(0.4em)
  ornament(w: 35%)
}

#invitation(
  "the engagement",
  [Mr. M. D. Laurance \ & \ Mrs. Smitha Laurance],
  (
    [joyfully invite you to share in the celebration],
    [of the engagement of their beloved children],
  ),
  [the ceremony will be solemnised at the],
  [Shrine Basilica of Our Lady of Dolours \ #text(size: 9.5pt, style: "italic")[(Puthanpalli)]],
  [Thrissur],
  [on _#h(0.3em)August 22, 2026#h(0.3em)_ at half past ten in the morning],
  [Reception to follow at the \ *Regal Ball Room, Hyatt Regency*],
  seed: 1,
)

