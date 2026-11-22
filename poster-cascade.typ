// Glueball — A0 portrait research poster (Typst), CASCADE theme.
// Same structure and content as poster.typ; colours, fonts, section styling and header follow the
// CASCADE poster theme (cascade-beamer-poster/beamerthemeCascade.sty).
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "@preview/showybox:2.0.4": showybox
#import "@preview/zebra:0.1.0": qrcode

// ───────────── palette: CASCADE (www.cl.cam.ac.uk/research/cascade) ─────────────
#let cascade-red = rgb("#DD3025")
#let cascade-darkred = rgb("#A3221A")
#let cascade-peach = rgb("#FFE2C8")
#let ink = rgb("#232830")          // cascadetext
#let muted = rgb("#5B6270")        // cascadegrey
#let paper = white
// role palettes (f = fill, s = stroke, d = dark text); names kept from the pastel theme
#let lav = (f: rgb("#F5EFED"), s: rgb("#C9B3AD"), d: rgb("#6B5651"))   // translation: warm grey
#let sky = (f: rgb("#FFEEE8"), s: rgb("#EE9A8A"), d: rgb("#B03A2E"))   // optimizer: light red
#let mint = (f: rgb("#FCE0DB"), s: rgb("#DD3025"), d: rgb("#A3221A"))  // correctness: CASCADE red
#let sun = (f: rgb("#FFE2C8"), s: rgb("#F0A06A"), d: rgb("#9C4A12"))   // gluon / results: CASCADE peach
#let rose = (f: rgb("#F6D0CB"), s: rgb("#A3221A"), d: rgb("#7D1A14"))  // retry / failure: dark red
#let grey = (f: rgb("#F1F2F4"), s: rgb("#9AA0AB"), d: rgb("#5B6270"))  // CASCADE greys (inputs only)
#let ok = (f: rgb("#E2F3E8"), s: rgb("#3FA76B"), d: rgb("#1E7A47"))    // success: verify, correct, improvements
#let amber = (f: rgb("#FDEFD6"), s: rgb("#E8A33D"), d: rgb("#9A6410"))
#let charcoal = (f: rgb("#E7E9EC"), s: rgb("#3C4250"), d: rgb("#2A2F38"))
#let stripe = rgb("#FFF5F1")       // alternating table rows
#let stripe-warm = rgb("#FFF8F0")

#let serif = "Nimbus Sans"
#let body-font = "Nimbus Sans"
#let display = "Nimbus Sans"
#let sans = "Nimbus Sans"
#let mono = "Source Code Pro"

// ───────────── page & text ─────────────
#let footer-h = 58mm
#let qr-url = "https://openreview.net/pdf?id=4Lpg8unVZd"
#set page(width: 841mm, height: 1189mm, fill: paper,
  margin: (x: 24mm, top: 18mm, bottom: footer-h + 12mm),
  background: place(bottom, rect(width: 100%, height: footer-h, fill: cascade-red)),
  foreground: place(bottom + left, block(width: 100%, height: footer-h, inset: (x: 24mm + 40pt, y: 10mm),
    grid(columns: (auto, 1fr, auto), column-gutter: 60pt, align: horizon,
      image("latex-src/logos/ucam-logo-white.png", height: 26mm),
      stack(spacing: 14pt,
        text(font: "Nimbus Sans", size: 30pt, weight: 700, fill: white)[Computer Architecture and Semiconductor Design Centre],
        text(font: "Nimbus Sans", size: 24pt, fill: cascade-peach)[Department of Computer Science and Technology, University of Cambridge]),
      box(fill: white, radius: 8pt, inset: 6pt, qrcode(qr-url, width: 38mm, quiet-zone: 2, background-fill: white)),
    ))))
#set text(font: body-font, size: 25.5pt, fill: ink, lang: "en", hyphenate: false, weight: 400)
#set par(justify: false, leading: 0.72em, spacing: 1.1em)
#set list(indent: 0pt, body-indent: 0.55em, spacing: 0.85em, marker: box(baseline: -0.05em, circle(radius: 0.17em, fill: cascade-red, stroke: none)))
#set enum(indent: 0pt, body-indent: 0.55em, spacing: 0.85em)
#show strong: set text(weight: 700)
#show math.equation: set text(font: "New Computer Modern Math")
#show raw: set text(font: mono)

// ───────────── building blocks ─────────────
#let chip(n) = box(width: 42pt, height: 42pt, fill: cascade-red, radius: 5pt, baseline: -5pt,
  align(center + horizon, text(font: sans, size: 26pt, weight: 700, fill: cascade-peach)[#n]))
#let card(num, title, pal, body) = showybox(
  frame: (
    title-color: white, border-color: rgb("#F0C6B6"), body-color: white,
    thickness: 1.6pt, radius: 8pt,
    inset: (x: 44pt, y: 15pt), body-inset: (x: 56pt, y: 18.5pt),
  ),
  title-style: (boxed-style: none, sep-thickness: 0pt),
  title: text(font: sans, size: 34pt, weight: 700, fill: ink)[#chip(num)#h(16pt)#title],
  breakable: false, width: 100%, body)

#let fit(body) = layout(size => {
  let m = measure(body)
  if m.width > size.width { scale(size.width / m.width * 100%, reflow: true, body) } else { body }
})
#let pair(a, b, gutter: 28pt) = layout(size => {
  let w = (size.width - gutter) / 2
  let ha = measure(width: w, a(0pt)).height
  let hb = measure(width: w, b(0pt)).height
  let hm = calc.max(ha, hb)
  grid(columns: (1fr, 1fr), column-gutter: gutter, a(hm - ha), b(hm - hb))
})
#let cap(body) = block(width: 100%, inset: (top: 14pt),
  text(font: sans, size: 25pt, fill: muted, body))
#let fig(body) = block(width: 100%, breakable: false, align(center, body))
#let sub(t) = text(font: serif, size: 26pt, fill: muted, style: "italic", t)
#let nd(pal, pos, name, body, w: 230pt, h: auto, dash: none) = node(pos, name: name, width: w, height: h, fill: pal.f,
  stroke: (paint: pal.s, thickness: 2.5pt, dash: dash), corner-radius: 7pt, inset: 20pt, outset: 7pt, body)
#let tag(pal, t) = text(font: serif, size: 28pt, style: "italic", weight: 600, fill: pal.d, t)

// ═════════════ HEADER ═════════════
// One red banner holding the title row and the authors; the CASCADE logo spans both rows. The red starts 18mm above
// the text area (outset into the top margin); the bottom inset is kept smaller so there is no empty band under the authors.
#let authors = "Yash Shah, Mantas Baksys, Sean B. Holden, Timothy M. Jones"
#block(width: 100%, fill: cascade-red, outset: (x: 24mm, top: 18mm), inset: (x: 40pt, top: 0mm, bottom: 12mm), below: 0pt)[
  #grid(columns: (auto, auto, 1fr, auto), column-gutter: 50pt, row-gutter: 40pt, align: horizon,
    text(font: display, size: 100pt, weight: 700, tracking: -1pt, fill: white)[Glueball],
    line(angle: 90deg, length: 100pt, stroke: 3pt + cascade-peach),
    text(font: serif, size: 42pt, weight: 700, fill: white)[Agentic Generation and Verification of \ Hardware-Optimized Gluon Kernels],
    grid.cell(rowspan: 2, align: right + horizon, image("latex-src/logos/cascade-logo-reversed.pdf", height: 160pt)),
    grid.cell(colspan: 3, align: left + horizon,
      box(fill: cascade-peach, radius: 10pt, inset: (x: 26pt, y: 14pt),
        text(font: sans, size: 30pt, weight: 700, fill: ink, authors))),
  )
]
#v(17pt)

// ═════════════ FULL-WIDTH FIGURES ═════════════
#let fig-arch = {
  set par(justify: false); set text(font: serif, size: 31pt)
  let H = 96pt
  diagram(
    node-inset: 12pt, spacing: (62pt, 46pt), edge-stroke: 2.8pt + ink.lighten(30%), mark-scale: 85%,
    nd(lav, (0, 0), <tr>, [*AST translation* \ #sub[Triton kernels → Gluon]], w: 340pt, h: H),
    nd(sun, (1, 0), <m>, [*Gluon model*], w: 250pt, h: H),
    nd(sky, (2, 0), <pf>, [*Profile* \ #sub[NCU · Proton · probes]], w: 370pt, h: H),
    nd(sky, (3, 0), <pr>, [*Propose*], w: 270pt, h: H),
    nd(sky, (4, 0), <im>, [*Implement*], w: 270pt, h: H),
    nd(ok, (5, 0), <vf>, [*Verify* \ #sub[Z3 tools]], w: 270pt, h: H),
    nd(grey, (6, 0), <bm>, [*Benchmark* \ #sub[full model]], w: 250pt, h: H),
    edge(<tr>, <m>, "->"), edge(<m>, <pf>, "->"),
    edge(<pf>, <pr>, "->"), edge(<pr>, <im>, "->"), edge(<im>, <vf>, "->"), edge(<vf>, <bm>, "->"),
    // retry loop (below) and repeat loop (above); endpoints sit ~20pt clear of the boxes
    edge((5, 0.46), (5, 0.84), (4, 0.84), (4, 0.46), "-->", snap-to: (none, none), stroke: 2.8pt + rose.s),
    node((4.5, 1.1), tag(rose, [reject: retry with feedback]), stroke: none),
    edge((6, -0.46), (6, -0.84), (1, -0.84), (1, -0.46), "->", snap-to: (none, none), stroke: 2.8pt + sun.s),
    node((3.5, -0.84), tag(sun, [repeat until max. rounds]), fill: white, stroke: none, inset: 10pt),
  )
}

#let fig-corr = {
  set par(justify: false); set text(font: serif, size: 31pt)
  let HI = 66pt
  let HM = 96pt
  diagram(
    node-inset: 12pt, spacing: (168pt, 12pt), edge-stroke: 2.8pt + ink.lighten(30%), mark-scale: 85%,
    nd(grey, (0, 0), <rt>, [*Reference Triton*], w: 340pt, h: HI),
    nd(grey, (0, 1), <pt>, [*PyTorch reference*], w: 340pt, h: HI),
    nd(sun, (0, 2), <pg>, [*Previous Gluon*], w: 340pt, h: HI),
    nd(mint, (1, 1), <sa>, [*Split & align*], w: 310pt, h: HM),
    nd(mint, (2, 1), <eq>, [*Block-wise equivalence* \ #sub[LLM reasoning + Z3]], w: 400pt, h: HM),
    nd(mint, (3, 1), <vd>, [*Verdict*], w: 230pt, h: HM),
    nd(ok, (4, 1), <rp>, [*Correctness report*], w: 340pt, h: HM),
    nd(rose, (3, 3), <ce>, [*Counterexample* \ #sub[witness on real GPU]], w: 330pt, h: HM, dash: "dashed"),
    edge(<rt>, (0.5, 0), (0.5, 1), <sa>, "->"), edge(<pt>, <sa>, "->"), edge(<pg>, (0.5, 2), (0.5, 1), <sa>, "->"),
    edge(<sa>, <eq>, "->"), edge(<eq>, <vd>, "->"),
    edge(<vd>, <rp>, "->", stroke: 2.8pt + ok.s, label: tag(ok, [correct]), label-side: left, label-sep: 12pt),
    edge(<vd>, <ce>, "->", stroke: 2.8pt + rose.s, label: tag(rose, [incorrect]), label-side: left, label-sep: 14pt),
    edge(<ce>, (1, 3), <sa>, "-->", stroke: 2.8pt + rose.s),
    node((2, 3), tag(rose, [does not reproduce bug → retry]), stroke: none, fill: white, inset: 8pt),
  )
}

// median speedups, recovered from the paper's figure by scripts/extract_speedups.py
#let speed-data = json("figures/speedups.json")
#let agents = ("DeepSeek V4 Pro", "DeepSeek V4 Flash", "Meta Muse Spark 1.3", "GPT 5.6 Sol")
#let kind = ("Model", "Model", "Model", "Kernel", "Kernel", "Kernel")
#let astra = ("1.13", "0.99", "1.00", "1.02", "1.10", "4.69")   // GPT 6 Astra + CODEX baseline
#let th(pal, b, ..a) = table.cell(fill: pal.f, ..a, text(font: sans, weight: 700, size: 21pt, fill: pal.d, par(leading: 0.55em, b)))
#let ROW = 40pt

#let fig-speed = {
  let rows = ()
  for (k, e) in speed-data.enumerate() {
    let vals = e.models.map(m => m.median)
    let base = float(astra.at(k))
    let best = calc.max(..vals, base)
    rows.push(table.cell(align: left + horizon, text(size: 24pt, weight: 700, e.name)))
    rows.push(table.cell(text(font: sans, size: 21pt, fill: muted, kind.at(k))))
    rows.push(table.cell(fill: if base == best { ok.f },
      text(size: 27pt, weight: if base == best { 700 } else { 400 }, fill: if base >= 1 { ok.d } else { cascade-red }, astra.at(k) + "×")))
    for m in e.models {
      let top = m.median == best
      rows.push(table.cell(fill: if top { ok.f },
        text(size: 27pt, weight: if top { 700 } else { 400 }, fill: if m.median >= 1 { ok.d } else { cascade-red }, m.label + "×")))
    }
  }
  table(columns: (3.1fr, 0.7fr, 1.15fr, 1.05fr, 1.05fr, 1.45fr, 0.95fr), rows: (66pt, ROW), align: center + horizon, stroke: none, inset: (x: 8pt, y: 6pt),
    fill: (_, y) => if y > 0 and calc.odd(y) { stripe },
    th(mint, align: left)[Workload], th(mint)[Type], th(mint)[Astra + CODEX], ..agents.map(n => th(mint, n)),
    table.hline(stroke: 2pt + mint.s),
    ..rows)
}

#let pos(b) = text(fill: ok.d, weight: 700, b)
#let fig-bugs = table(columns: (3.3fr, 1.1fr, 1fr, 1fr, 1fr, 1.1fr, 1fr, 1fr, 1fr), rows: (36pt, 46pt, ROW),
  align: (left + horizon, center + horizon), stroke: none, inset: (x: 8pt, y: 6pt),
  fill: (_, y) => if y > 1 and calc.even(y) { stripe },
  table.cell(rowspan: 2, th(mint, align: left)[Model]),
  table.cell(colspan: 4, th(mint)[Generic suite]), table.cell(colspan: 4, th(mint)[Sync suite]),
  th(mint)[Bugs↑], th(mint)[Δ], th(mint)[FP↓], th(mint)[Δ], th(mint)[Bugs↑], th(mint)[Δ], th(mint)[FP↓], th(mint)[Δ],
  table.hline(stroke: 2pt + mint.s),
  text(size: 24pt)[DeepSeek V4 Pro], [21], pos[+3], [0], [0], [10], [0], [7], pos[−5],
  text(size: 24pt)[DeepSeek V4 Flash], [22], pos[+2], [0], [0], [10], [0], [1], pos[−1],
  text(size: 24pt)[Meta Muse Spark 1.3], [22], pos[+2], [0], [0], [9], [0], [3], pos[−3],
  text(size: 24pt)[GPT 5.6 Sol], [21], pos[+2], [0], [0], [9], pos[+1], [1], pos[−1])

// both diagrams are drawn at the same scale (that of the wider system diagram), so text and boxes match
#let same-scale(body) = layout(size => {
  let k = calc.min(1.0, size.width / measure(fig-arch).width, size.width / measure(body).width)
  align(center, scale(k * 100%, reflow: true, body))
})
#card("1", "System: profile, optimize, verify, benchmark", sky)[
  #same-scale(fig-arch)
]
#v(17pt)
#card("2", "Correctness pipeline: LLM reasoning with Z3 tools", mint)[
  #same-scale(fig-corr)
]
#v(17pt)
#pair(
  x => card("3", "Whole-model speedups over Triton", sun)[#fig(fig-speed)#v(x)],
  x => card("4", "Verification finds more bugs", mint)[#fig(fig-bugs)#v(x)],
)
#v(17pt)
#let arm-names = ("Both tools", "Z3 library only", "Symbolic exec. only", "Neither (raw model)")
#let arm-col = (ok, mint, amber, charcoal)
#let abl-bar(val, mx, pal) = stack(dir: ltr, spacing: 8pt,
  box(width: val * 10pt, height: 22pt, radius: 3pt, fill: pal.s),
  text(size: 24pt, weight: 700, fill: pal.d)[#val M])
#let fig-abl = table(columns: (2.4fr, 1fr, 1fr, 1fr, 1fr, 1fr), rows: (36pt, 66pt, ROW), align: (left + horizon, center + horizon),
  stroke: none, inset: (x: 8pt, y: 6pt), fill: (_, y) => if y > 1 and calc.even(y) { stripe },
  table.cell(rowspan: 2, th(mint, align: left)[Test arm]),
  table.cell(colspan: 2, th(mint)[Bug detection]), table.cell(colspan: 3, th(mint)[Idiomatic, bug-free code]),
  th(mint)[Found /30↑], th(mint)[Tokens↓], th(mint)[False pos. /21↓], th(mint)[Tokens↓], th(mint)[Tool calls↓],
  table.hline(stroke: 2pt + mint.s),
  text(size: 25pt)[Both tools], pos[28], pos[0.93 M], pos[0], pos[3.63 M], [47.6],
  text(size: 25pt)[Z3 library only], pos[28], [1.21 M], pos[0], pos[3.52 M], pos[43.6],
  text(size: 25pt)[Symbolic exec. only], [27], [1.40 M], pos[0], [4.29 M], [50.9],
  text(size: 25pt)[Neither (raw model)], [27], [1.52 M], text(fill: cascade-red, weight: 700)[7], [4.44 M], [71.2])
#let defects = (("cpasync_barrier", (0.42, 0.62, 1.47, 1.75)), ("arrive_before_fence", (1.24, 0.90, 3.19, 3.69)), ("missing_fence", (1.77, 2.05, 2.68, 3.33)))
#let fig-defects = table(columns: (2.3fr, 1fr, 1fr, 1fr, 1fr), rows: (40pt, ROW), align: (left + horizon, left + horizon),
  stroke: none, inset: (x: 8pt, y: 6pt), fill: (_, y) => if y > 0 and calc.odd(y) { stripe },
  th(mint, align: left)[Tokens per defect], ..arm-names.zip(arm-col).map(((n, p)) => th(p, align: left)[#n.split(" ").first()]),
  table.hline(stroke: 2pt + mint.s),
  ..defects.map(((d, v)) => (text(font: mono, size: 21pt)[#d], ..v.zip(arm-col).map(((x, p)) => abl-bar(x, 3.75, p)))).flatten())
#card("5", "Z3 tools greatly reduce token usage and therefore verification cost", sky)[
  #grid(columns: (1.2fr, 1fr), column-gutter: 40pt, align: horizon, fig(fig-abl), fig(fig-defects))

]

// ───────── case study (full width) ─────────
#let code(body, h: auto) = block(fill: rgb("#FAF7F6"), stroke: 2pt + grey.s, radius: 6pt,
  inset: 20pt, width: 100%, height: h,
  text(font: mono, size: 22pt, body))
#let lab(pal, t) = block(below: 16pt, text(font: sans, weight: 700, size: 24pt, fill: pal.d, t))

#let case-cols(hm) = {
  let bh = if hm == none { auto } else { hm }
  let fx = if hm == none { auto } else { 1fr }
  (
  block(height: bh)[#lab(rose)[(a) The bug: waits for too few copies]
   #code(h: fx)[```python
# Correct
cp.wait_group(num_buffers - 1)
# Bug
cp.wait_group(num_buffers)

perform_add(
    a_smem[read_idx % num_buffers],
    b_smem[read_idx % num_buffers],
)
```]],
  block(height: bh)[#lab(rose)[(b) Symbolic model: the relevant part]
   #code(h: fx)[```python
r0, w0 = ctx.map_async_copy_global_to_shared(
    0, src_addr=0x1000, dst_addr=0x100,
    size=4, label='copy0')
...
wait = ctx.map_async_wait_group(
    0, num_outstanding=wait_arg,
    label=f'wait({wait_arg})')
load = ctx.map_load(
    0, 0x100, Space.SHARED,
    size=4, label='read buffer0')
ctx.program_order(wait.id, load.id)

safe, model = ctx.check_async_race_freedom()
```]],
  block(height: bh)[#lab(rose)[(c) Z3 verdict: the race]
   #code(h: fx)[```
wait_group(2):
DATA RACE detected:
  copy0.smem_write
    STORE SHARED@0x100
    proxy=ASYNC_COPY
  <-race->
  read buffer0
    LOAD SHARED@0x100
    proxy=GENERIC
```]],
  block(height: bh)[#lab(rose)[(d) Pipeline-level witness]
   #code(h: fx)[```
check_pipeline_stage_isolation(
    num_stages=2, max_inflight=2)

PIPELINE COLLISION:
producer and consumer share a slot
witness: [iter_p = 2, lag = 2]
```]],
)
}

#card("6", "Case study: Z3 exposes a pipelining bug", rose)[
  #layout(size => {
    let fr = (515, 634, 436, 476)
    let cw = (size.width - 3 * 26pt) / fr.sum()
    let hs = case-cols(none).zip(fr).map(((c, f)) => measure(width: f * cw, c).height)
    let hm = calc.max(..hs)
    grid(columns: fr.map(f => f * 1fr), column-gutter: 26pt, ..case-cols(hm))
  })
]
#v(17pt)

// ═════════════ TWO COLUMNS: the two halves of the correctness system ═════════════
// Compact representations (no tables): op chips colour-coded by how they are modelled, and the axiom/theorem names.
// Label and chips share one fixed height and the same baseline shift, and the label sits in the same line as its
// chips (later lines hang under the first chip), so labels line up with the chips exactly.
#let CHIP-H = 34pt
#let LABEL-W = 124pt
#let chip-box(body, pal: none, inset-x: 0pt) = box(height: CHIP-H, baseline: 28%, radius: 6pt, inset: (x: inset-x),
  fill: if pal == none { none } else { pal.f }, stroke: if pal == none { none } else { 1.8pt + pal.s },
  align(horizon, body))
#let op-chip(pal, t) = chip-box(pal: pal, inset-x: 8pt, text(font: mono, size: 17.5pt, fill: pal.d, t))
#let name-chip(pal, t) = chip-box(pal: pal, inset-x: 14pt, text(font: sans, size: 22pt, weight: 700, fill: pal.d, t))
#let chip-row(label, chips) = par(leading: 8pt, hanging-indent: LABEL-W + 8pt,
  [#chip-box(box(width: LABEL-W, text(font: sans, size: 21pt, weight: 700, fill: muted, upper(label))))#h(8pt)#chips.join(h(8pt))])
#let legend(pal, t) = box[#box(width: 18pt, height: 18pt, radius: 4pt, fill: pal.f, stroke: 1.8pt + pal.s, baseline: 15%) #h(6pt)#text(size: 21pt, fill: muted, t)]

#let card6(x) = [
  #card("7", "Symbolic execution: a Z3 model of TTIR", mint)[
    Each MLIR op becomes a Z3 term; ops the model cannot capture become *opaque symbols* that split the kernel into *symbolic regions*. Softmax ops break down:
    #v(4pt)
    #chip-row("TTIR ops", (op-chip(rose, "tt.load"), op-chip(rose, "tt.reduce max"), op-chip(ok, "arith.subf"),
      op-chip(amber, "math.exp"), op-chip(rose, "tt.reduce sum"), op-chip(ok, "arith.divf")))
    #v(4pt)
    #chip-row("Z3 term", (chip-box(text(font: mono, size: 23pt)[out = exp(load_row − max_row) / denominator]),))
    #v(8pt)
    #legend(rose, [opaque symbol]) #h(24pt) #legend(amber, [uninterpreted function]) #h(24pt) #legend(ok, [native Z3 FP op]) 
    #v(x)
  ]
]

#let card7(x) = [
  #card("8", "The Gluon-to-Z3 library", mint)[
    Hardware operations become *events* ordered by _happens-before_. Each *theorem* asks Z3 to satisfy the *negation* of a property, such that *SAT* gives a counterexample.
    #v(4pt)
    #chip-row("Axioms", ("Sequential consistency", "CTA barrier", "Async-proxy fence", "Mbarrier sync", "Manual ordering").map(t => name-chip(mint, t)))
    #v(4pt)
    #chip-row("Theorems", ("Async race freedom", "Bank-conflict freedom", "Global coalescing").map(t => name-chip(ok, t)))
    #v(x)
  ]
]

#pair(card6, card7, gutter: 40pt)
#v(17pt)
#card("9", "Future directions", lav)[
  #grid(columns: (1fr, 1fr, 1fr), column-gutter: 48pt,
    [*Multi-GPU and heterogeneous targets.* Extend generation and verification to distributed kernels (ParallelKernelBench) and other accelerators, with proof obligations for collective ordering and distributed races.],
    [*Constraint- and statistics-guided search.* Prune pipelining schedule families with resource and safety checks before codegen, and use past feedback to cut costly LLM iterations.],
    [*Verification across the compilation stack.* Integrate further formal tools, such as a formal PTX model, to verify at several levels of the compilation stack (Gluon, TTGIR, PTX).],
  )
  #v(2pt)
]
