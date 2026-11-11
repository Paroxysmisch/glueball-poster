// Glueball — A0 portrait research poster (Typst)
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "@preview/showybox:2.0.4": showybox

// ───────────── palette: soft pastels + deep ink ─────────────
#let ink = rgb("#2b2d42")
#let muted = rgb("#6b6f85")
#let paper = rgb("#faf7f2")
#let lav = (f: rgb("#ebe7f5"), s: rgb("#9d92c8"), d: rgb("#5a4a9a"))   // translation
#let sky = (f: rgb("#e1ebf6"), s: rgb("#8badd4"), d: rgb("#3b5f9a"))   // optimizer
#let mint = (f: rgb("#dff0e8"), s: rgb("#80bea4"), d: rgb("#2a7a62"))  // correctness
#let sun = (f: rgb("#f8eed3"), s: rgb("#d9bb6a"), d: rgb("#8a6a0c"))   // gluon / results
#let rose = (f: rgb("#f5e0dc"), s: rgb("#d9a096"), d: rgb("#a8483c"))  // retry / failure
#let grey = (f: rgb("#f0eef1"), s: rgb("#b9b6c0"), d: rgb("#5b586a"))

#let serif = "Source Serif 4"
#let display = "Source Serif 4 Display"
#let sans = "Libre Franklin"
#let mono = "Source Code Pro"

// ───────────── page & text ─────────────
#set page(width: 841mm, height: 1189mm, fill: paper,
  margin: (x: 24mm, top: 20mm, bottom: 20mm))
#set text(font: serif, size: 30pt, fill: ink, lang: "en", hyphenate: false, weight: 400)
#set par(justify: false, leading: 0.72em, spacing: 1.1em)
#set list(indent: 0pt, body-indent: 0.55em, spacing: 0.85em, marker: box(baseline: 0.0em, polygon.regular(size: 0.42em, vertices: 4, fill: sky.s, stroke: none)))
#set enum(indent: 0pt, body-indent: 0.55em, spacing: 0.85em)
#show strong: set text(weight: 700)
#show math.equation: set text(font: "Libertinus Math")
#show raw: set text(font: mono)

// ───────────── building blocks ─────────────
#let card(num, title, pal, body) = showybox(
  frame: (
    title-color: pal.f.lighten(45%), border-color: pal.s.lighten(35%), body-color: white,
    thickness: 1.6pt, radius: 10pt,
    inset: (x: 44pt, y: 16pt), body-inset: (x: 48pt, y: 18pt),
  ),
  shadow: (color: rgb("#2b2d42").transparentize(94%), offset: (x: 0pt, y: 4pt)),
  title-style: (boxed-style: none),
  title: text(font: serif, size: 40pt, weight: 700, fill: pal.d)[
    #box(fill: pal.s, radius: 100%, inset: (x: 15pt, y: 6pt), baseline: 0.02em,
      text(font: sans, size: 26pt, weight: 700, fill: white)[#num])#h(18pt)#title],
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
#block(width: 100%, radius: 10pt, inset: (x: 64pt, y: 30pt), stroke: 1.6pt + rgb("#d5d1e6"),
  fill: rgb("#eeecf6"))[
  #grid(columns: (auto, auto, auto, 1fr), column-gutter: 54pt, align: horizon,
    text(font: display, size: 120pt, weight: 700, tracking: -0.5pt, fill: ink)[Glueball],
    line(angle: 90deg, length: 120pt, stroke: 2pt + rgb("#c7c3dc")),
    text(font: serif, size: 54pt, weight: 600, fill: ink)[Agentic Generation and Verification of \ Hardware-Optimized Gluon Kernels],
    align(right, text(font: sans, size: 30pt, fill: muted)[Anonymous authors]),
  )
]
#v(30pt)

// ═════════════ FULL-WIDTH FIGURES ═════════════
#let fig-arch = {
  set par(justify: false); set text(font: serif, size: 31pt)
  let H = 96pt
  diagram(
    node-inset: 12pt, spacing: (62pt, 46pt), edge-stroke: 2.8pt + ink.lighten(30%), mark-scale: 85%,
    nd(lav, (0, 0), <tr>, [*AST translation* \ #sub[Triton kernels → Gluon]], w: 330pt, h: H),
    nd(sun, (1, 0), <m>, [*Gluon model* \ $M^((r))$], w: 250pt, h: H),
    nd(sky, (2, 0), <pf>, [*Profile* \ #sub[agent per kernel]], w: 270pt, h: H),
    nd(sky, (3, 0), <pr>, [*Propose* \ #sub[ranked portfolio]], w: 270pt, h: H),
    nd(sky, (4, 0), <im>, [*Implement* \ #sub[targeted edits]], w: 270pt, h: H),
    nd(mint, (5, 0), <vf>, [*Verify* \ #sub[tests + Z3 tools]], w: 270pt, h: H),
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
  let HI = 60pt
  let HM = 88pt
  diagram(
    node-inset: 12pt, spacing: (100pt, 16pt), edge-stroke: 2.8pt + ink.lighten(30%), mark-scale: 85%,
    nd(grey, (0, 0), <rt>, [Reference Triton], w: 340pt, h: HI),
    nd(grey, (0, 1), <pt>, [PyTorch reference], w: 340pt, h: HI),
    nd(sun, (0, 2), <pg>, [Previous Gluon], w: 340pt, h: HI),
    nd(mint, (1, 1), <sa>, [*Split & align* \ #sub[regions → tuples]], w: 310pt, h: HM),
    nd(mint, (2, 1), <eq>, [*Block-wise equivalence* \ #sub[LLM reasoning + Z3]], w: 400pt, h: HM),
    nd(mint, (3, 1), <vd>, [*Verdict*], w: 230pt, h: HM),
    nd(mint, (4, 1), <rp>, [*Correctness report*], w: 340pt, h: HM),
    nd(rose, (3, 3), <ce>, [*Counterexample* \ #sub[witness on real GPU]], w: 330pt, h: HM, dash: "dashed"),
    edge(<rt>, (0.5, 0), (0.5, 1), <sa>, "->"), edge(<pt>, <sa>, "->"), edge(<pg>, (0.5, 2), (0.5, 1), <sa>, "->"),
    edge(<sa>, <eq>, "->"), edge(<eq>, <vd>, "->"),
    edge(<vd>, <rp>, "->", stroke: 2.8pt + mint.s, label: tag(mint, [correct]), label-side: left, label-sep: 12pt),
    edge(<vd>, <ce>, "->", stroke: 2.8pt + rose.s, label: tag(rose, [incorrect]), label-side: left, label-sep: 14pt),
    edge(<ce>, (1, 3), <sa>, "-->", stroke: 2.8pt + rose.s),
    node((2, 3), tag(rose, [does not reproduce → retry]), stroke: none, fill: white, inset: 8pt),
  )
}

// median speedups, recovered from the paper's figure by scripts/extract_speedups.py
#let speed-data = json("figures/speedups.json")
#let agents = ("DeepSeek V4 Pro", "DeepSeek V4 Flash", "Meta Muse Spark 1.3", "GPT 5.6 Sol")
#let kind = ("Model", "Model", "Model", "Kernel", "Kernel", "Kernel")
#let th(pal, b, ..a) = table.cell(fill: pal.f, ..a, text(font: sans, weight: 700, size: 21pt, fill: pal.d, par(leading: 0.55em, b)))
#let ROW = 62pt

#let fig-speed = {
  let rows = ()
  for (k, e) in speed-data.enumerate() {
    let best = calc.max(..e.models.map(m => m.median))
    rows.push(table.cell(align: left + horizon, text(size: 28pt, weight: 700, e.name)))
    rows.push(table.cell(text(font: sans, size: 21pt, fill: muted, kind.at(k))))
    for m in e.models {
      let top = m.median == best
      rows.push(table.cell(fill: if top { sun.f.lighten(35%) },
        text(size: 29pt, weight: if top { 700 } else { 400 }, fill: if m.median >= 1 { mint.d } else { rose.d }, m.label + "×")))
    }
  }
  table(columns: (2.7fr, 0.95fr, 1.15fr, 1.15fr, 1.15fr, 1.05fr), rows: ROW, align: center + horizon, stroke: none, inset: (x: 10pt, y: 6pt),
    fill: (_, y) => if y > 0 and calc.odd(y) { rgb("#fbf9f3") },
    th(sun, align: left)[Workload], th(sun)[Type], ..agents.map(n => th(sun, n)),
    table.hline(stroke: 2pt + sun.s),
    ..rows,
    table.hline(stroke: 2pt + sun.s))
}

#let pos(b) = text(fill: mint.d, weight: 700, b)
#let fig-bugs = table(columns: (3.3fr, 1.1fr, 1fr, 1fr, 1fr, 1.1fr, 1fr, 1fr, 1fr), rows: ROW,
  align: (left + horizon, center + horizon), stroke: none, inset: (x: 8pt, y: 6pt),
  fill: (_, y) => if y > 1 and calc.even(y) { rgb("#f4faf7") },
  table.cell(rowspan: 2, th(mint, align: left)[Model]),
  table.cell(colspan: 4, th(mint)[Generic suite]), table.cell(colspan: 4, th(mint)[Sync suite]),
  th(mint)[Bugs↑], th(mint)[Δ], th(mint)[FP↓], th(mint)[Δ], th(mint)[Bugs↑], th(mint)[Δ], th(mint)[FP↓], th(mint)[Δ],
  table.hline(stroke: 2pt + mint.s),
  text(size: 24pt)[DeepSeek V4 Pro], [21], pos[+3], [0], [0], [10], [0], [7], pos[−5],
  text(size: 24pt)[DeepSeek V4 Flash], [22], pos[+2], [0], [0], [10], [0], [1], pos[−1],
  text(size: 24pt)[Meta Muse Spark 1.3], [22], pos[+2], [0], [0], [9], [0], [3], pos[−3],
  text(size: 24pt)[GPT 5.6 Sol], [21], pos[+2], [0], [0], [9], pos[+1], [1], pos[−1],
  table.hline(stroke: 2pt + mint.s))

#card("1", "System: optimize, verify, benchmark", sky)[
  #fig(fit(fig-arch))
]
#v(14pt)
#card("2", "Correctness pipeline: LLM reasoning with Z3 evidence", mint)[
  #fig(fit(fig-corr))
]
#v(14pt)
#pair(
  x => card("3", "Whole-model speedups over Triton", sun)[#fig(fig-speed)#v(x)],
  x => card("4", "Verification finds more bugs", mint)[#fig(fig-bugs)#v(x)],
)
#v(14pt)

// ───────── case study (full width) ─────────
#let code(body, h: auto) = block(fill: rgb("#f6f4f9"), stroke: 2pt + grey.s, radius: 6pt,
  inset: 20pt, width: 100%, height: h,
  text(font: mono, size: 23pt, body))
#let lab(pal, t) = block(below: 16pt, text(font: sans, weight: 700, size: 24pt, fill: pal.d, t))

#let case-cols(hm) = {
  let bh = if hm == none { auto } else { hm }
  let fx = if hm == none { auto } else { 1fr }
  (
  block(height: bh)[#lab(rose)[(a) The bug: waits for too few copies]
   #code[```python
# Correct
cp.wait_group(num_buffers - 1)
# Bug
cp.wait_group(num_buffers)

perform_add(
    a_smem[read_idx % num_buffers],
    b_smem[read_idx % num_buffers],
)
```]
   #v(18pt)
   #lab(rose)[(c) Z3 verdict]
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
wait_group(1):
RACE-FREE: proven
```]],
  block(height: bh)[#lab(rose)[(b) Symbolic model written by the LLM]
   #code(h: fx)[```python
def build(num_buffers, wait_arg):
    ctx = GluonVerificationContext()
    r0, w0 = ctx.map_async_copy_global_to_shared(
        0, src_addr=0x1000, dst_addr=0x100,
        size=4, label='copy0')
    ctx.map_async_commit_group(0)
    r1, w1 = ctx.map_async_copy_global_to_shared(
        0, src_addr=0x2000, dst_addr=0x200,
        size=4, label='copy1')
    ctx.map_async_commit_group(0)
    wait = ctx.map_async_wait_group(
        0, num_outstanding=wait_arg,
        label=f'wait({wait_arg})')
    load = ctx.map_load(
        0, 0x100, Space.SHARED,
        size=4, label='read buffer0')
    ctx.program_order(wait.id, load.id)
    return ctx

for wait_arg in [2, 1]:
    safe, model = build(
        2, wait_arg).check_async_race_freedom()
```]],
  block(height: bh)[#lab(rose)[(d) Pipeline-level witness]
   #code(h: fx)[```
check_pipeline_stage_isolation(
    num_stages=2, max_inflight=2)

PIPELINE COLLISION:
producer and consumer share a slot
witness: [iter_p = 2, lag = 2]
-> (False, [iter_p = 2, lag = 2])

max_inflight=1:

STAGE-ISOLATED:
num_stages=2 never aliases
with up to 1 in-flight iteration
-> (True, None)
```]
   #v(14pt)
   #text(size: 27pt)[Waiting for too few async copies lets the consumer read a buffer that is still being filled. The LLM encodes the pipeline (b); Z3 names the racing store and load (c), and a pipeline-level check yields a concrete iteration where producer and consumer share one slot (d).]
   ],
)
}

#card("5", "Case study: Z3 exposes a pipelining bug", rose)[
  #layout(size => {
    let cw = (size.width - 52pt) / 3.1
    let widths = (cw, cw * 1.2, cw * 0.9)
    let hs = case-cols(none).zip(widths).map(((c, w)) => measure(width: w, c).height)
    let hm = calc.max(..hs)
    grid(columns: (1fr, 1.2fr, 0.9fr), column-gutter: 26pt, ..case-cols(hm))
  })
]
#v(14pt)

// ═════════════ TWO COLUMNS: the two halves of the correctness system ═════════════
#let tag-chip(pal, t) = box(fill: pal.f, stroke: 1.5pt + pal.s, radius: 5pt, inset: (x: 10pt, y: 3pt),
  text(font: sans, size: 20pt, weight: 600, fill: pal.d, t))
#let mono-t(t) = text(font: mono, size: 22pt, t)

#let ttir-map = table(columns: (1.45fr, 2.1fr, 1.1fr), rows: 40pt, align: left + horizon, stroke: none, inset: (x: 10pt, y: 4pt),
  fill: (_, y) => if y > 0 and calc.odd(y) { rgb("#f4faf7") },
  th(mint)[TTIR op], th(mint)[Z3 term], th(mint)[Kind],
  table.hline(stroke: 2pt + mint.s),
  mono-t("tt.load"), mono-t("load_row"), tag-chip(rose, "fresh symbol"),
  mono-t("tt.reduce (max)"), mono-t("maxnumf_row_minus_max"), tag-chip(rose, "fresh symbol"),
  mono-t("arith.subf"), mono-t("load_row − maxnumf_…"), tag-chip(mint, "fpSub"),
  mono-t("math.exp"), mono-t("exp(load_row − …)"), tag-chip(sun, "uninterpreted fn"),
  mono-t("tt.reduce (sum)"), mono-t("addf_denominator"), tag-chip(rose, "fresh symbol"),
  mono-t("arith.divf"), mono-t("exp(…) / addf_denominator"), tag-chip(mint, "fpDiv"),
  table.hline(stroke: 2pt + mint.s))

#let dialects = table(columns: (0.7fr, 0.5fr, 3.2fr), rows: 44pt, align: left + horizon, stroke: none, inset: (x: 10pt, y: 4pt),
  fill: (_, y) => if y > 0 and calc.odd(y) { rgb("#f4faf7") },
  th(mint)[Dialect], th(mint)[Ops], th(mint)[How it is modeled],
  table.hline(stroke: 2pt + mint.s),
  mono-t("arith"), [51], text(size: 25pt)[native Z3 bit-vector / floating-point operators],
  mono-t("math"), [46], text(size: 25pt)[simple ops native; exp, log, sin … uninterpreted],
  mono-t("tt"), [52], text(size: 25pt)[reshapes alias; pointer math exact; load, reduce, dot opaque],
  mono-t("scf"), [12], text(size: 25pt)[if exact; for runs once; while opaque],
  mono-t("ttg"), [27], text(size: 25pt)[same interpreter on TTGIR; default warp partition only],
  table.hline(stroke: 2pt + mint.s))

#let card6(x) = [
  #card("6", "Symbolic execution: a Z3 model of TTIR", mint)[
    Each MLIR op becomes a Z3 term over one representative scalar per tensor. Ops the model cannot capture become *fresh opaque symbols* that split the kernel into *symbolic regions*; Z3 reasons inside, the LLM across.
    #v(8pt)
    #fig(ttir-map)
    #v(8pt)
    Chasing the stored value gives a single closed form, #text(font: mono, size: 22pt)[exp(load_row − maxnumf_row_minus_max) / addf_denominator], while the loads and reductions stay opaque.
  ]
]

#let ax-row(n, d) = (table.cell(text(font: sans, weight: 700, size: 22pt, fill: mint.d, n)), text(size: 25pt, d))
#let card7(x) = [
  #card("7", "The Gluon-to-Z3 library", mint)[
    Hardware actions become *events* in a bounded graph ordered by _happens-before_ and _program order_. *Axioms* encode ordering rules; each *theorem* asks Z3 to satisfy the *negation* of a property: *UNSAT* proves it for every schedule, *SAT* gives a counterexample.
    #v(10pt)
    #fig(table(columns: (1.15fr, 2.5fr), rows: 38pt, align: left + horizon, stroke: none, inset: (x: 10pt, y: 3pt),
      fill: (_, y) => if y > 0 and calc.odd(y) { rgb("#f4faf7") },
      th(mint, colspan: 2, align: left)[Axioms: hardware ordering rules],
      ..ax-row("Sequential consistency", "events form an acyclic timeline"),
      ..ax-row("CTA barrier", "gl.barrier(): before ⇒ after, all threads"),
      ..ax-row("Async-proxy fence", "orders generic writes before TMA / MMA reads"),
      ..ax-row("Mbarrier sync", "arrival and byte accounting; short ⇒ deadlock"),
      ..ax-row("Manual ordering", "assert or deny a happens-before edge"),
      th(rose, colspan: 2, align: left)[Theorems: safety properties],
      ..ax-row("Async race freedom", "no unordered access pair with a write"),
      ..ax-row("Bank-conflict freedom", "same-warp threads hit distinct banks"),
      ..ax-row("Global coalescing", "warp accesses fit one aligned cache line"),
      table.hline(stroke: 2pt + mint.s),
    ))
    #v(x)
  ]
]

#pair(card6, card7, gutter: 40pt)
