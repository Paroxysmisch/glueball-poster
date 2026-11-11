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

#let serif = "Libertinus Serif"
#let display = "Libertinus Serif"
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
    inset: (x: 44pt, y: 20pt), body-inset: (x: 48pt, y: 24pt),
  ),
  shadow: (color: rgb("#2b2d42").transparentize(94%), offset: (x: 0pt, y: 4pt)),
  title-style: (boxed-style: none),
  title: text(font: serif, size: 40pt, weight: 700, fill: pal.d)[
    #text(font: sans, size: 26pt, weight: 600, fill: pal.s, tracking: 1.5pt)[#num]#h(20pt)#title],
  breakable: false, width: 100%, body)

#let fit(body) = layout(size => {
  let m = measure(body)
  if m.width > size.width { scale(size.width / m.width * 100%, reflow: true, body) } else { body }
})
#let cap(body) = block(width: 100%, inset: (top: 14pt),
  text(font: sans, size: 25pt, fill: muted, body))
#let fig(body, caption) = block(width: 100%, breakable: false)[#align(center, body) #cap(caption)]
#let sub(t) = text(font: serif, size: 26pt, fill: muted, style: "italic", t)
#let nd(pal, pos, name, body, w: 230pt, dash: none) = node(pos, name: name, width: w, fill: pal.f,
  stroke: (paint: pal.s, thickness: 2.5pt, dash: dash), corner-radius: 7pt, inset: 20pt, outset: 7pt, body)
#let tag(pal, t) = text(font: serif, size: 28pt, style: "italic", weight: 600, fill: pal.d, t)

// ═════════════ HEADER ═════════════
#block(width: 100%, radius: 10pt, inset: (x: 64pt, y: 38pt), stroke: 1.6pt + rgb("#d5d1e6"),
  fill: gradient.linear(rgb("#ebe8f5"), rgb("#e4edf5"), rgb("#e2f0ea"), angle: 6deg))[
  #grid(columns: (auto, auto, auto, 1fr), column-gutter: 54pt, align: horizon,
    text(font: serif, size: 120pt, weight: 700, tracking: -0.5pt, fill: ink)[Glueball],
    line(angle: 90deg, length: 120pt, stroke: 2pt + rgb("#c7c3dc")),
    text(font: serif, size: 54pt, weight: 600, fill: ink)[Agentic Generation and Verification of \ Hardware-Optimized Gluon Kernels],
    align(right, text(font: sans, size: 30pt, fill: muted)[Anonymous authors]),
  )
]
#v(30pt)

// ═════════════ FULL-WIDTH FIGURES ═════════════
#let fig-arch = {
  set par(justify: false); set text(font: serif, size: 31pt)
  diagram(
    node-inset: 12pt, spacing: (62pt, 58pt), edge-stroke: 2.8pt + ink.lighten(30%), mark-scale: 85%,
    nd(lav, (0, 0), <tr>, [*AST translation* \ #sub[Triton kernels → Gluon]], w: 300pt),
    nd(sun, (1, 0), <m>, [*Gluon model* \ $M^((r))$], w: 250pt),
    nd(sky, (2, 0), <pf>, [*Profile* \ #sub[agent per kernel]], w: 270pt),
    nd(sky, (3, 0), <pr>, [*Propose* \ #sub[ranked portfolio]], w: 270pt),
    nd(sky, (4, 0), <im>, [*Implement* \ #sub[targeted edits]], w: 270pt),
    nd(mint, (5, 0), <vf>, [*Verify* \ #sub[tests + Z3 tools]], w: 270pt),
    nd(grey, (6, 0), <bm>, [*Benchmark* \ #sub[full model]], w: 250pt),
    edge(<tr>, <m>, "->"), edge(<m>, <pf>, "->"),
    edge(<pf>, <pr>, "->"), edge(<pr>, <im>, "->"), edge(<im>, <vf>, "->"), edge(<vf>, <bm>, "->"),
    edge((5, 0.41), (5, 0.85), (4, 0.85), (4, 0.41), "-->", snap-to: (none, none), stroke: 2.8pt + rose.s),
    node((4.5, 1.12), tag(rose, [reject: retry with feedback]), stroke: none),
    edge((6, -0.41), (6, -0.85), (1, -0.85), (1, -0.41), "->", snap-to: (none, none), stroke: 2.8pt + sun.s),
    node((3.5, -0.85), tag(sun, [commit $M^((r+1))$ · repeat until max rounds]), fill: white, stroke: none, inset: 8pt),
    node(enclose: (<pf>, <vf>), stroke: (paint: grey.s, dash: "dashed", thickness: 2.5pt), corner-radius: 10pt, inset: 26pt),
    node((3.0, 0.52), text(font: serif, size: 25pt, weight: 600, fill: grey.d, tracking: 1.5pt)[#smallcaps[optimization round] $r$], stroke: none, fill: white, inset: 6pt),
  )
}

#let fig-corr = {
  set par(justify: false); set text(font: serif, size: 31pt)
  diagram(
    node-inset: 12pt, spacing: (100pt, 34pt), edge-stroke: 2.8pt + ink.lighten(30%), mark-scale: 85%,
    nd(grey, (0, 0), <rt>, [Reference Triton], w: 340pt),
    nd(grey, (0, 1), <pt>, [PyTorch reference], w: 340pt),
    nd(sun, (0, 2), <pg>, [Previous Gluon], w: 340pt),
    nd(mint, (1, 1), <sa>, [*Split & align* \ #sub[regions → tuples]], w: 310pt),
    nd(mint, (2, 1), <eq>, [*Block-wise equivalence* \ #sub[LLM reasoning + Z3]], w: 400pt),
    nd(mint, (3, 1), <vd>, [*Verdict*], w: 230pt),
    nd(mint, (4, 1), <rp>, [*Correctness report*], w: 340pt),
    nd(rose, (3, 2), <ce>, [*Counterexample* \ #sub[witness on real GPU]], w: 330pt, dash: "dashed"),
    edge(<rt>, (0.5, 0), (0.5, 1), <sa>, "->"), edge(<pt>, <sa>, "->"), edge(<pg>, (0.5, 2), (0.5, 1), <sa>, "->"),
    edge(<sa>, <eq>, "->"), edge(<eq>, <vd>, "->"),
    edge(<vd>, <rp>, "->", stroke: 2.8pt + mint.s),
    node((3.5, 0.76), tag(mint, [correct]), stroke: none),
    edge(<vd>, <ce>, "->", stroke: 2.8pt + rose.s),
    node((3.26, 1.5), tag(rose, [incorrect]), stroke: none, fill: white, inset: 4pt),
    edge(<ce>, (1, 2), <sa>, "-->", stroke: 2.8pt + rose.s),
    node((2, 2), tag(rose, [does not reproduce → retry]), stroke: none, fill: white, inset: 8pt),
  )
}

// median speedups, recovered from the paper's figure by scripts/extract_speedups.py
#let speed-data = json("figures/speedups.json")
#let agents = ("DeepSeek V4 Pro", "DeepSeek V4 Flash", "Meta Muse Spark 1.3", "GPT 5.6 Sol")
#let kind = ("Model", "Model", "Model", "Kernel", "Kernel", "Kernel")
#let fig-speed = {
  let cell-h(b, ..a) = table.cell(fill: sun.f, ..a, text(font: sans, weight: 700, size: 27pt, fill: sun.d, b))
  let rows = ()
  for (k, e) in speed-data.enumerate() {
    let best = calc.max(..e.models.map(m => m.median))
    rows.push(table.cell(align: left + horizon, text(size: 34pt, weight: 700, e.name)))
    rows.push(table.cell(text(font: sans, size: 24pt, fill: muted, kind.at(k))))
    for m in e.models {
      let top = m.median == best
      rows.push(table.cell(fill: if top { sun.f.lighten(35%) },
        text(size: 36pt, weight: if top { 700 } else { 400 }, fill: if m.median >= 1 { mint.d } else { rose.d }, m.label + "×")))
    }
  }
  table(columns: (2.5fr, 0.9fr, 1.3fr, 1.3fr, 1.5fr, 1.2fr), rows: 70pt, align: center + horizon, stroke: none, inset: (x: 18pt, y: 8pt),
    fill: (_, y) => if y > 0 and calc.odd(y) { rgb("#fbf9f3") },
    cell-h(align: left)[Workload], cell-h[Type], ..agents.map(n => cell-h(n)),
    table.hline(stroke: 2pt + sun.s),
    ..rows,
    table.hline(stroke: 2pt + sun.s))
}

#card("01", "System: optimize, verify, benchmark", sky)[
  #fig(fit(fig-arch))[*Figure 1.* Triton kernels are translated to Gluon; each round profiles, proposes, implements and verifies changes, then benchmarks the whole model on hidden, re-randomized shapes.]
]
#v(20pt)
#card("02", "Correctness pipeline: LLM reasoning with Z3 evidence", mint)[
  #fig(fit(fig-corr))[*Figure 2.* Reference and previous kernels are split into aligned symbolic regions; failures become counterexamples reproduced on GPU.]
]
#v(20pt)
#card("03", "Whole-model speedups over Triton", sun)[
  #fig(fig-speed)[*Table 1.* Median best-round speedup over the Triton baseline across input shapes (NVIDIA DGX Spark GB10, 6 rounds). Green: at or above parity; shaded: best agent per workload.]
]
#v(20pt)

// ═════════════ TWO COLUMNS ═════════════
#let code(body) = block(fill: rgb("#f6f4f9"), stroke: 2pt + grey.s, radius: 6pt, inset: 22pt, width: 100%,
  text(font: mono, size: 26pt, body))
#let hd(..a, b) = table.cell(fill: mint.f, ..a.named(), text(font: sans, fill: mint.d, weight: 700, size: 24pt, b))
#let pos(b) = text(fill: mint.d, weight: 700, b)
#let lab(pal, t) = text(font: sans, weight: 700, size: 27pt, fill: pal.d, t)

#let colL = [
  #card("04", "Motivation & contributions", rose)[
    Tests cover little of the execution space, so agents can *overfit to tested inputs* and miss _races_ and _barrier_ bugs in asynchronous Hopper/Blackwell kernels.

    *Glueball* is the first system to equip LLM agents with *theorem-proving tools* during GPU kernel generation. It targets *Gluon*, Triton's tile-level DSL with explicit layouts and warp roles, whose structured semantics suit formal reasoning.
    - *Interactive profiling:* profilers, debuggers and compilers.
    - *Theorem provers as tools:* Z3 via our Gluon-to-Z3 library.
    - *Real-world testing:* whole models, not isolated kernels.
  ]
  #v(20pt, weak: false)#v(1fr)
  #card("05", "Formal tools in the loop", mint)[
    Equivalence is undecidable and GPU state spaces explode, so verification is *hybrid*.
    - *Symbolic execution* maps IR ops to Z3 terms over symbolic inputs; softmax is recovered as $exp(x - m) / sum exp(x - m)$.
    - *Opaque operations* (reductions, memory, sync) split a kernel into *symbolic regions*: Z3 inside, the LLM across.
    - *Gluon-to-Z3 library* models async copies, barriers and shared memory for race and pipeline checks.
  ]
  #v(20pt, weak: false)#v(1fr)
  #card("06", "Conclusions", lav)[
    Formal tools in the loop *find more bugs with fewer false positives*, while agents gain from data movement and algorithmic changes. *Next:* multi-GPU kernels and constraint-guided schedule search.
  ]
]

#let colR = [
  #card("07", "Hardware-aware optimization", sky)[
    - *Profile:* Nsight Compute and source probes rank kernels by run-time share.
    - *Propose:* one agent merges reports and history into a ranked multi-kernel portfolio.
    - *Implement:* edits pass compilation, numerics (FpSan) and formal checks.
    - *Benchmark:* hidden, re-randomized inputs; only verified proposals commit.
  ]
  #v(20pt, weak: false)#v(1fr)
  #card("08", "Verification finds more bugs", mint)[
    #fig(
      table(columns: (3.4fr, 1.3fr, 1fr, 1fr, 1fr, 1.3fr, 1fr, 1fr, 1fr), align: (left + horizon, center + horizon),
        rows: 50pt, stroke: none, inset: (x: 9pt, y: 6pt),
        fill: (_, y) => if y > 1 and calc.even(y) { rgb("#f4faf7") },
        table.cell(rowspan: 2, hd[Model]),
        table.cell(colspan: 4, hd[Generic suite]), table.cell(colspan: 4, hd[Sync suite]),
        hd[Bugs↑], hd[Δ], hd[FP↓], hd[Δ], hd[Bugs↑], hd[Δ], hd[FP↓], hd[Δ],
        table.hline(stroke: 2pt + mint.s),
        [DeepSeek V4 Pro], [21], pos[+3], [0], [0], [10], [0], [7], pos[−5],
        [DeepSeek V4 Flash], [22], pos[+2], [0], [0], [10], [0], [1], pos[−1],
        [Meta Muse Spark 1.3], [22], pos[+2], [0], [0], [9], [0], [3], pos[−3],
        [GPT 5.6 Sol], [21], pos[+2], [0], [0], [9], pos[+1], [1], pos[−1],
        table.hline(stroke: 2pt + mint.s),
      ))[*Figure 4.* Δ = gain from adding Glueball; Z3 *cuts sync false positives sharply*.]
  ]
  #v(20pt, weak: false)#v(1fr)
  #card("09", "Case study: a pipelining bug", rose)[
    #grid(columns: (1fr, 1fr), column-gutter: 24pt,
      [#lab(rose)[Buggy kernel] #v(4pt)
       #code[```python
# correct
wait_group(n - 1)
# bug: copy in flight
wait_group(n)
add(a_smem[i % n],
    b_smem[i % n])
```]],
      [#lab(rose)[Z3 verdict] #v(4pt)
       #code[```
wait_group(2): DATA RACE
 async STORE @0x100
 <-race->
 LOAD  @0x100
wait_group(1): RACE-FREE
witness: iter_p=2, lag=2
```]])
    #cap[*Figure 5.* Waiting for too few async copies leaves a live buffer; Z3 exposes the race.]
  ]
]

#block(height: 1fr, grid(columns: (1fr, 1fr), column-gutter: 40pt, colL, colR))
