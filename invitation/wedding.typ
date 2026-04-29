// =====================================================================
//  Wedding invitation  —  Prasanth & Sharon
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

// ---------- confetti -------------------------------------------------
//
//  Renders a deterministic confetti scatter sized to fill its container.
//  Placed inside the page background so it sits BEHIND all content.
//  `alpha` controls opacity (0%–100%): lower = more transparent.
//  `seed` varies the pattern between pages.
//  Density tapers in the vertical center so text stays readable.

#let confetti(seed: 0, count: 4000, alpha: 14%) = {
  // Phyllotaxis (golden-angle) spiral: pieces placed at i × 137.508°
  // with radius ∝ √i — uniform area density, no clustering.
  let golden_angle = 137.50776405deg
  let r_max = 870  // per-mille; reaches all corners from centre on A5

  for i in range(count) {
    let theta = golden_angle * i
    let r = calc.sqrt(i / count) * r_max
    let xx = calc.round(500 + r * calc.cos(theta))
    let yy = calc.round(500 + r * calc.sin(theta) * 0.7048)  // A5: 148/210

    if xx < 0 or xx > 1000 or yy < 0 or yy > 1000 { continue }

    let cc = calc.rem(i * 53 + seed *  7,  6)
    let dd = calc.rem(i * 71 + seed * 13, confetti_palette.len())
    let ee = calc.rem(i + seed, 5)
    let ff = calc.rem(i * 31 + seed * 19, 360)
    let color = confetti_palette.at(dd).transparentize(100% - alpha)

    let piece = if ee == 0 {
      // filled dot
      circle(radius: (1.6 + cc * 0.3) * 1pt, fill: color, stroke: none)
    } else if ee == 1 {
      // small filled diamond
      rotate(45deg, square(size: (3.0 + cc * 0.4) * 1pt, fill: color, stroke: none))
    } else if ee == 2 {
      // paper streamer
      rotate(ff * 1deg, rect(
        width: (5.0 + cc) * 1pt, height: 1.4pt,
        fill: color, stroke: none, radius: 0.5pt,
      ))
    } else if ee == 3 {
      // tiny ring (subtle wedding-ring nod)
      circle(radius: (1.4 + cc * 0.25) * 1pt, fill: none, stroke: 0.6pt + color)
    } else {
      // small triangle
      rotate(ff * 1deg, polygon.regular(
        size: (4.0 + cc * 0.4) * 1pt, vertices: 3,
        fill: color, stroke: none,
      ))
    }

    place(top + left, dx: xx * 0.1%, dy: yy * 0.1%, piece)
  }
}

// ---------- page setup ----------------------------------------------

#set page(
  paper: "a5",
  margin: (x: 1.4cm, y: 1.4cm),
  background: context {
    let pn = counter(page).get().first()

    // Confetti — scattered across the entire page, behind everything.
    confetti(seed: pn)

    // Outer border
    place(top + left, dx: 0.55cm, dy: 0.55cm,
      rect(width: 100% - 1.1cm, height: 100% - 1.1cm,
           stroke: 0.4pt + gold))
    // Inner border
    place(top + left, dx: 0.78cm, dy: 0.78cm,
      rect(width: 100% - 1.56cm, height: 100% - 1.56cm,
           stroke: 0.25pt + gold))

    // Corner floral motifs near each outer-border corner. Use the same
    // symbol-font heart helper as the body so all ❦s share one design.
    let corner = text(
      font: ("Apple Symbols", "Zapf Dingbats"),
      size: 11pt, fill: gold,
    )[❦]
    place(top + left,     dx:  0.42cm, dy:  0.32cm, corner)
    place(top + right,    dx: -0.42cm, dy:  0.32cm, corner)
    place(bottom + left,  dx:  0.42cm, dy: -0.32cm, corner)
    place(bottom + right, dx: -0.42cm, dy: -0.32cm, corner)
  },
)

// Body font: EB Garamond 12 (size-specific Garamond revival recommended
// by Butterick's Practical Typography for serious printed work). The
// Libertinus / Cormorant entries are portability fallbacks; symbol
// fonts are listed last so the floral heart ❦ (U+2766) and other
// dingbats fall back cleanly when the serif fonts don't carry them.
#set text(
  font: (
    "EB Garamond 12", "Cormorant Garamond", "Libertinus Serif",
    "Apple Symbols", "Zapf Dingbats",
  ),
  size: 10.5pt,
  fill: ink,
  hyphenate: false,
)

#set par(leading: 0.65em, justify: false)

// ---------- decorative bits -----------------------------------------

// Force the floral heart through the symbol fonts — Cormorant Garamond
// carries its own ❦ glyph that wins font fallback but doesn't match
// the crisper dingbat form used elsewhere on the page.
#let heart(size: 12pt, fill: gold, tracking: 0pt) = text(
  font: ("Apple Symbols", "Zapf Dingbats"),
  size: size, fill: fill, tracking: tracking,
)[❦]

#let ornament(w: 55%) = align(center, box(width: w, grid(
  columns: (1fr, auto, 1fr),
  align: horizon,
  column-gutter: 0.5em,
  line(length: 100%, stroke: 0.4pt + gold),
  heart(size: 12pt),
  line(length: 100%, stroke: 0.4pt + gold),
)))

#let petals_row() = align(center, {
  heart(size: 10pt)
  h(0.6em)
  heart(size: 10pt)
  h(0.6em)
  heart(size: 10pt)
})

#let mini_divider() = align(center, text(size: 11pt, fill: gold)[
  · #h(0.4em) #heart(size: 11pt) #h(0.4em) ·
])

// True small caps via the dedicated SC cut of EB Garamond — Butterick's
// Practical Typography is emphatic that faked caps via upper() produce
// stretched, ungainly letterforms. Real small caps use proportions
// designed by the type designer. Input text should be lowercase.
#let label(t) = align(center, text(
  font: "EB Garamond SC 12",
  size: 11pt, tracking: 4pt, fill: gold,
)[#t])

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
) = {
  set align(center)

  v(0.15cm)
  label(occasion_label)
  v(0.25em)
  ornament()
  v(0.5em)

  text(size: 12pt, hosts)

  v(0.45em)

  for line in invite_lines {
    text(size: 10.5pt, style: "italic", line)
    linebreak()
  }

  v(0.35em)
  petals_row()
  v(0.2em)

  // The names — visual centerpiece. Cormorant Garamond Italic is a
  // display-cut Garamond with elegant swashy forms, designed for
  // exactly this kind of ceremonial use at large size.
  text(
    font: "Cormorant Garamond", size: 26pt, style: "italic",
    fill: gold, tracking: 1pt,
  )[Prasanth]
  v(-0.3em)
  text(
    font: "Cormorant Garamond", size: 18pt, style: "italic", fill: ink,
  )[#sym.amp]
  v(-0.3em)
  text(
    font: "Cormorant Garamond", size: 26pt, style: "italic",
    fill: gold, tracking: 1pt,
  )[Sharon]

  v(0.5em)

  text(size: 10pt, ceremony_intro)
  v(0.25em)
  text(size: 11.5pt, weight: "semibold", venue)
  linebreak()
  text(size: 10pt, style: "italic", city)

  v(0.35em)
  text(size: 10pt, date_line)

  v(0.45em)
  mini_divider()
  v(0.3em)

  text(size: 9.5pt, style: "italic", reception)

  v(0.35em)
  ornament(w: 35%)
}

#invitation(
  "the wedding",
  [
    Dr. Shaji Tharasseril & Dr. Asha Haridas \
    #v(0.15em)
    #text(size: 9pt, fill: gold, style: "italic", tracking: 2pt)[together with] \
    #v(0.15em)
    Mr. Muthupeedika Devasy Laurance & Mrs. Smitha Laurance
  ],
  (
    [request the honour of your presence],
    [at the marriage of their beloved children],
  ),
  [the Nuptial Mass will be celebrated at the],
  [Holy Family Roman Catholic Church],
  [Kollam],
  [on _#h(0.3em)August 31, 2026#h(0.3em)_ at half past ten in the morning],
  [Reception to follow at the \ *Younus Convention Center, Kollam* \ from 12:00 noon to 4:00 in the afternoon],
)

