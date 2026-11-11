// Glueball — A0 portrait research poster (Typst)
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "@preview/showybox:2.0.4": showybox

// ───────────── palette: soft pastels + deep ink ─────────────
#let ink = rgb("#2b2d42")
#let muted = rgb("#6b6f85")
#let paper = rgb("#faf7f2")
#let lav = (f: rgb("#e7e1f6"), s: rgb("#8f7fc9"), d: rgb("#5a4a9a"))   // translation
#let sky = (f: rgb("#dce9f8"), s: rgb("#7ea6d9"), d: rgb("#3b5f9a"))   // optimizer
#let mint = (f: rgb("#d8f0e5"), s: rgb("#74c3a1"), d: rgb("#2a7a62"))  // correctness
#let sun = (f: rgb("#fbefc9"), s: rgb("#e5c15d"), d: rgb("#8a6a0c"))   // gluon / results
#let rose = (f: rgb("#fadcd7"), s: rgb("#e59a8f"), d: rgb("#a8483c"))  // retry / failure
#let grey = (f: rgb("#efedf0"), s: rgb("#b9b6c0"), d: rgb("#5b586a"))

#let display = "Montserrat"
#let body-font = "Libre Franklin"
#let mono = "Source Code Pro"

// ───────────── page & text ─────────────
#set page(width: 841mm, height: 1189mm, fill: paper,
  margin: (x: 26mm, top: 22mm, bottom: 28mm),
  footer: align(center, text(size: 22pt, fill: muted, font: body-font)[
    Glueball: Agentic Generation and Verification of Hardware-Optimized Gluon Kernels  ·  ICLR 2027 submission (double-blind)  ·  typeset with Typst]))
#set text(font: body-font, size: 39pt, fill: ink, lang: "en", hyphenate: false, weight: 400)
#set par(justify: false, leading: 0.72em, spacing: 1.1em)
#set list(indent: 0pt, body-indent: 0.55em, spacing: 0.85em, marker: text(fill: sky.s, "●"))
#set enum(indent: 0pt, body-indent: 0.55em, spacing: 0.85em)
#show strong: set text(weight: 700)
#show math.equation: set text(font: "New Computer Modern Math")
#show raw: set text(font: mono)

// ───────────── building blocks ─────────────
#let card(num, title, pal, body) = showybox(
  frame: (
    title-color: pal.f, border-color: pal.s, body-color: white,
    thickness: 0pt, radius: 28pt,
    inset: (x: 40pt, y: 18pt), body-inset: (x: 44pt, y: 36pt),
  ),
  shadow: (color: rgb("#2b2d42").transparentize(88%), offset: (x: 0pt, y: 8pt)),
  title-style: (weight: 800, color: pal.d, boxed-style: none),
  title: [
    #box(fill: pal.s, radius: 100%, inset: (x: 18pt, y: 8pt),
      text(font: display, size: 34pt, weight: 800, fill: white, num))
    #h(14pt)
    #text(font: display, size: 44pt, weight: 800, fill: pal.d, title)
  ],
  breakable: false, width: 100%, body)

#let cap(body) = block(width: 100%, inset: (top: 14pt),
  text(size: 28pt, fill: muted, style: "normal", body))
#let fig(body, caption) = block(width: 100%, breakable: false)[#align(center, body) #cap(caption)]
#let kw(body) = text(weight: 700, fill: sky.d, body)

#let nbox(pal, body, w: auto, dashed: false, bold: false) = (
  stroke: (paint: pal.s, thickness: 3pt, dash: if dashed { "dashed" }),
  fill: pal.f, corner-radius: 18pt, inset: 18pt, width: w,
)

// ═════════════ HEADER ═════════════
#block(width: 100%, radius: 36pt, inset: (x: 70pt, y: 42pt),
  fill: gradient.linear(rgb("#dcd5f4"), rgb("#d3e4f7"), rgb("#d3efe3"), angle: 8deg))[
  #grid(columns: (1fr, auto), column-gutter: 60pt, align: (left + horizon, right + horizon),
    [
      #text(font: display, size: 150pt, weight: 800, tracking: -3pt, fill: ink)[Glueball]
      #v(-20pt)
      #text(font: display, size: 54pt, weight: 600, fill: ink.lighten(10%))[
        Agentic Generation and Verification of \ Hardware-Optimized Gluon Kernels]
      #v(16pt)
      #text(size: 34pt, fill: muted)[Anonymous authors #h(0.8em) • #h(0.8em) ICLR 2027 submission, under double-blind review]
    ],
    stack(dir: ttb, spacing: 16pt,
      ..("LLM agents", "GPU kernels", "Gluon · Triton", "Z3 theorem proving", "Blackwell TMA").map(t =>
        box(fill: white.transparentize(30%), stroke: 2pt + white, radius: 100%, inset: (x: 28pt, y: 12pt),
          text(size: 30pt, weight: 600, fill: ink.lighten(15%), t)))),
  )
]
#v(40pt)

// ═════════════ FIGURES ═════════════
#let sub(t) = text(size: 25pt, fill: muted, t)
#let nd(pal, pos, name, body, w: 230pt, dash: none) = node(pos, name: name, width: w, fill: pal.f,
  stroke: (paint: pal.s, thickness: 3pt, dash: dash), corner-radius: 18pt, inset: 16pt, body)

#let fig-arch = {
  set par(justify: false); set text(size: 34pt)
  diagram(
    node-inset: 14pt, spacing: (62pt, 74pt), edge-stroke: 3.5pt + ink.lighten(30%), mark-scale: 85%,
    nd(grey, (0, 0), <tri>, [*Triton model* \ #sub[$K$ kernels]], w: 270pt),
    nd(lav, (1, 0), <tr>, [*AST translation* \ #sub[Triton → Gluon]], w: 270pt),
    nd(sun, (2, 0), <m>, [*Gluon model* \ $M^((r))$], w: 270pt),
    nd(sky, (2, 1), <pf>, [*Profile* \ #sub[per-kernel agents]], w: 270pt),
    nd(sky, (1, 1), <pr>, [*Propose* \ #sub[ranked portfolio]], w: 270pt),
    nd(sky, (0, 1), <im>, [*Implement* \ #sub[targeted edits]], w: 270pt),
    nd(mint, (0, 2), <vf>, [*Verify* \ #sub[tests + Z3 tools]], w: 270pt),
    nd(grey, (1, 2), <bm>, [*Benchmark* \ #sub[hidden shapes]], w: 270pt),
    nd(sun, (2, 2), <m2>, [*Commit* $M^((r+1))$ \ #sub[next round]], w: 270pt, dash: "dashed"),
    edge(<tri>, <tr>, "->"), edge(<tr>, <m>, "->"), edge(<m>, <pf>, "->"),
    edge(<pf>, <pr>, "->"), edge(<pr>, <im>, "->"),
    edge(<im>, <vf>, "->", shift: 22pt), edge(<vf>, <im>, "-->", shift: 22pt, stroke: 3.5pt + rose.s),
    node((0.55, 1.5), text(fill: rose.d, size: 27pt, weight: 700)[reject → retry], stroke: none),
    edge(<vf>, <bm>, "->"), edge(<bm>, <m2>, "->", stroke: 3.5pt + sun.s),
  )
}

#let fig-corr = {
  set par(justify: false); set text(size: 30pt)
  diagram(
    node-inset: 14pt, spacing: (46pt, 54pt), edge-stroke: 3pt + ink.lighten(30%), mark-scale: 85%,
    nd(grey, (0, 0), <rt>, [Reference \ Triton], w: 215pt),
    nd(grey, (0, 1), <pt>, [PyTorch \ reference], w: 215pt),
    nd(sun, (0, 2), <pg>, [Previous \ Gluon], w: 215pt),
    nd(mint, (1, 1), <sa>, [*Split & \ align*], w: 210pt),
    nd(mint, (2, 1), <eq>, [*Block-wise \ equivalence*], w: 240pt),
    nd(mint, (3, 1), <vd>, [*Verdict*], w: 200pt),
    nd(mint, (3, 0), <rp>, [*Correctness \ report*], w: 215pt),
    nd(rose, (3, 2), <ce>, [*Counter-\example*], w: 215pt, dash: "dashed"),
    edge(<rt>, "r", <sa>, "->", corner: right), edge(<pt>, <sa>, "->"), edge(<pg>, "r", <sa>, "->", corner: left),
    edge(<sa>, <eq>, "->"), edge(<eq>, <vd>, "->"),
    edge(<vd>, <rp>, "->", stroke: 3pt + mint.s),
    node((3.52, 0.5), text(fill: mint.d, size: 25pt, weight: 600)[correct], stroke: none),
    edge(<vd>, <ce>, "->", stroke: 3pt + rose.s),
    node((3.55, 1.5), text(fill: rose.d, size: 25pt, weight: 600)[incorrect], stroke: none),
    edge(<ce>, (1, 2), <sa>, "-->", stroke: 3pt + rose.s),
    node((2, 2), text(fill: rose.d, size: 25pt, weight: 600)[no repro → retry], stroke: none, fill: white, inset: 6pt),
    node(enclose: (<eq>, <vd>), stroke: (paint: mint.s, dash: "dotted", thickness: 3pt), corner-radius: 22pt, inset: 26pt),
  )
}

// ═════════════ BODY: TWO COLUMNS ═════════════
#let colL = [
  #card("01", "Abstract", sun)[
    On Hopper and Blackwell, *asynchronous* warp specialization, TMA and pipelines hide races from *finite test suites*.

    *Glueball* is the first system to give LLM agents *theorem-proving tools* (Z3) while they generate and optimize *Gluon* kernels, guided by end-to-end model speed and prover feedback.
  ]
  #v(1fr)
  #card("02", "System: optimize, verify, benchmark", sky)[
    #fig(fig-arch)[*Figure 1.* Each Triton kernel is translated to Gluon, then every round profiles, proposes, implements and benchmarks. Only changes that pass the correctness pipeline are committed.]
    #v(10pt)
    Whole-model benchmarking on _hidden, re-randomized_ shapes keeps agents from overfitting to tests.
  ]
  #v(1fr)
  #card("03", "Formal tools in the loop", mint)[
    #fig(fig-corr)[*Figure 2.* Reference and candidate are split into aligned regions, each checked by LLM reasoning plus Z3. Failures become runnable witnesses.]
    #v(10pt)
    - *Symbolic execution:* IR ops become Z3 terms; opaque ops split kernels into regions.
    - *Gluon-to-Z3 library:* models async copies, barriers and shared memory to prove race freedom.
  ]
]

#let code(body) = block(fill: rgb("#f6f4f9"), stroke: 2pt + grey.s, radius: 16pt, inset: 22pt, width: 100%,
  text(font: mono, size: 27pt, body))
#let hd(..a, b) = table.cell(fill: mint.f, ..a.named(), text(fill: mint.d, weight: 700, size: 28pt, b))
#let pos(b) = text(fill: mint.d, weight: 700, b)

#let colR = [
  #card("04", "Whole-model speedups over Triton", sun)[
    #fig(image("figures/violin.pdf", width: 100%))[*Figure 3.* Best-round speedup per input shape on GB10 (DeepSeek V4 Pro / Flash, Meta Muse Spark 1.3, GPT 5.6 Sol). Circle = median.]
    #v(10pt)
    - *GPT-OSS:* TMA descriptors absorb the QKV transpose and GQA indexing.
    - *Qwen-3.5 MoE:* *TMA gather* moves routed token rows directly to shared memory.
    - *Neighborhood attention:* an algorithmic win, $O(L^2 D) arrow O(L W D)$, about *25×*.
  ]
  #v(1fr)
  #card("05", "Verification finds more bugs", mint)[
    #fig(
      table(columns: (2.6fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr), align: (left + horizon, center + horizon),
        stroke: none, inset: 11pt, row-gutter: 0pt,
        fill: (_, y) => if y > 1 and calc.even(y) { rgb("#f4faf7") },
        table.cell(rowspan: 2, hd[Model]),
        table.cell(colspan: 4, hd[Generic suite]), table.cell(colspan: 4, hd[Sync suite]),
        hd[Bugs ↑], hd[Δ], hd[FP ↓], hd[Δ], hd[Bugs ↑], hd[Δ], hd[FP ↓], hd[Δ],
        table.hline(stroke: 2pt + mint.s),
        [V4 Pro], [21], pos[+3], [0], [0], [10], [0], [7], pos[−5],
        [V4 Flash], [22], pos[+2], [0], [0], [10], [0], [1], pos[−1],
        [Muse Spark], [22], pos[+2], [0], [0], [9], [0], [3], pos[−3],
        [GPT 5.6 Sol], [21], pos[+2], [0], [0], [9], pos[+1], [1], pos[−1],
        table.hline(stroke: 2pt + mint.s),
      ))[*Figure 4.* Bugs detected (of 24 / 10) and false positives (of 26 / 12); Δ is the gain from the Glueball pipeline.]
    #v(10pt)
    Z3 evidence *cuts sync false positives sharply* (7 → 2 for V4 Pro) and recovers missed bugs.
  ]
  #v(1fr)
  #card("06", "Case study: a pipelining bug", rose)[
    #grid(columns: (1fr, 1fr), column-gutter: 26pt,
      [#text(font: display, weight: 700, size: 28pt, fill: rose.d)[Buggy kernel]
       #v(4pt)
       #code[```python
# correct
wait_group(n - 1)
# bug: copy in flight
wait_group(n)
add(a_smem[i % n],
    b_smem[i % n])
```]],
      [#text(font: display, weight: 700, size: 28pt, fill: rose.d)[Z3 verdict]
       #v(4pt)
       #code[```
wait_group(2): DATA RACE
 async STORE @0x100
 <-race->
 LOAD  @0x100
wait_group(1): RACE-FREE
witness: iter_p=2, lag=2
```]])
    #cap[*Figure 5.* The agent encodes the pipeline in Z3, which exposes the async write racing with the shared-memory read and a concrete iteration witness.]
  ]
]

#block(height: 1fr, grid(columns: (1fr, 1fr), column-gutter: 44pt, colL, colR))
