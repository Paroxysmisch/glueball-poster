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

#let serif = "Libertinus Serif"
#let display = "Libertinus Serif"
#let sans = "Libre Franklin"
#let mono = "Source Code Pro"

// ───────────── page & text ─────────────
#set page(width: 841mm, height: 1189mm, fill: paper,
  margin: (x: 24mm, top: 18mm, bottom: 26mm),
  footer: align(center, text(size: 22pt, fill: muted, font: sans)[
    Glueball: Agentic Generation and Verification of Hardware-Optimized Gluon Kernels  ·  ICLR 2027 submission (double-blind)  ·  typeset with Typst]))
#set text(font: serif, size: 32pt, fill: ink, lang: "en", hyphenate: false, weight: 400)
#set par(justify: false, leading: 0.72em, spacing: 1.1em)
#set list(indent: 0pt, body-indent: 0.55em, spacing: 0.85em, marker: text(fill: sky.s, "●"))
#set enum(indent: 0pt, body-indent: 0.55em, spacing: 0.85em)
#show strong: set text(weight: 700)
#show math.equation: set text(font: "Libertinus Math")
#show raw: set text(font: mono)

// ───────────── building blocks ─────────────
#let card(num, title, pal, body) = showybox(
  frame: (
    title-color: pal.f, border-color: pal.s, body-color: white,
    thickness: 0pt, radius: 26pt,
    inset: (x: 40pt, y: 13pt), body-inset: (x: 44pt, y: 20pt),
  ),
  shadow: (color: rgb("#2b2d42").transparentize(88%), offset: (x: 0pt, y: 8pt)),
  title-style: (weight: 700, color: pal.d, boxed-style: none),
  title: [
    #box(fill: pal.s, radius: 100%, inset: (x: 18pt, y: 7pt),
      text(font: sans, size: 30pt, weight: 700, fill: white, num))
    #h(14pt)
    #text(font: serif, size: 50pt, weight: 700, fill: pal.d, title)
  ],
  breakable: false, width: 100%, body)

#let cap(body) = block(width: 100%, inset: (top: 14pt),
  text(font: sans, size: 25pt, fill: muted, body))
#let fig(body, caption) = block(width: 100%, breakable: false)[#align(center, body) #cap(caption)]
#let sub(t) = text(font: sans, size: 24pt, fill: muted, weight: 400, t)
#let nd(pal, pos, name, body, w: 230pt, dash: none) = node(pos, name: name, width: w, fill: pal.f,
  stroke: (paint: pal.s, thickness: 3pt, dash: dash), corner-radius: 16pt, inset: 14pt, body)
#let tag(pal, t) = text(font: sans, size: 25pt, weight: 600, fill: pal.d, t)

// ═════════════ HEADER (compact) ═════════════
#block(width: 100%, radius: 30pt, inset: (x: 64pt, y: 34pt),
  fill: gradient.linear(rgb("#dcd5f4"), rgb("#d3e4f7"), rgb("#d3efe3"), angle: 8deg))[
  #grid(columns: (auto, 1fr), column-gutter: 70pt, align: (left + horizon, left + horizon),
    text(font: serif, size: 132pt, weight: 700, tracking: -1pt, fill: ink)[Glueball],
    [
      #text(font: serif, size: 56pt, weight: 600, fill: ink)[Agentic Generation and Verification of \ Hardware-Optimized Gluon Kernels]
      #v(4pt)
      #text(font: sans, size: 28pt, fill: muted)[Anonymous authors #h(0.6em) · #h(0.6em) ICLR 2027 submission, under double-blind review]
    ])
]
#v(34pt)

// ═════════════ FULL-WIDTH PIPELINES ═════════════
#let fig-arch = {
  set par(justify: false); set text(font: sans, size: 28pt)
  diagram(
    node-inset: 12pt, spacing: (34pt, 40pt), edge-stroke: 3.5pt + ink.lighten(30%), mark-scale: 85%,
    nd(grey, (0, 0), <tri>, [*Triton model* \ #sub[$K$ kernels]], w: 230pt),
    nd(lav, (1, 0), <tr>, [*AST translation* \ #sub[each kernel, mechanical]], w: 260pt),
    nd(sun, (2, 0), <m>, [*Gluon model* \ $M^((r))$], w: 230pt),
    nd(sky, (3, 0), <pf>, [*Profile* \ #sub[agent per kernel]], w: 245pt),
    nd(sky, (4, 0), <pr>, [*Propose* \ #sub[ranked portfolio]], w: 245pt),
    nd(sky, (5, 0), <im>, [*Implement* \ #sub[step-by-step edits]], w: 245pt),
    nd(mint, (6, 0), <vf>, [*Verify* \ #sub[tests + Z3, per kernel]], w: 255pt),
    nd(grey, (7, 0), <bm>, [*Benchmark* \ #sub[full model]], w: 230pt),
    edge(<tri>, <tr>, "->"), edge(<tr>, <m>, "->"), edge(<m>, <pf>, "->"),
    edge(<pf>, <pr>, "->"), edge(<pr>, <im>, "->"), edge(<im>, <vf>, "->"), edge(<vf>, <bm>, "->"),
    edge(<vf>, (6, 0.95), (5, 0.95), <im>, "-->", stroke: 3.5pt + rose.s),
    node((5.5, 0.95), tag(rose, [reject: retry with feedback]), fill: white, stroke: none, inset: 6pt),
    edge(<bm>, (7, -0.95), (2, -0.95), <m>, "->", stroke: 3.5pt + sun.s),
    node((4.5, -0.95), tag(sun, [commit $M^((r+1))$ · repeat until max rounds]), fill: white, stroke: none, inset: 8pt),
    node(enclose: (<pf>, <vf>), stroke: (paint: grey.s, dash: "dashed", thickness: 3pt), corner-radius: 20pt, inset: 22pt),
    node((3.0, 0.62), text(font: sans, size: 22pt, weight: 700, fill: grey.d)[OPTIMIZATION ROUND $r$], stroke: none),
  )
}

#let fig-corr = {
  set par(justify: false); set text(font: sans, size: 28pt)
  diagram(
    node-inset: 12pt, spacing: (62pt, 20pt), edge-stroke: 3.5pt + ink.lighten(30%), mark-scale: 85%,
    nd(grey, (0, 0), <rt>, [Reference Triton], w: 290pt),
    nd(grey, (0, 1), <pt>, [PyTorch reference], w: 290pt),
    nd(sun, (0, 2), <pg>, [Previous Gluon], w: 290pt),
    nd(mint, (1, 1), <sa>, [*Split & align* \ #sub[regions → tuples]], w: 280pt),
    nd(mint, (2, 1), <eq>, [*Block-wise equivalence* \ #sub[LLM reasoning + Z3]], w: 340pt),
    nd(mint, (3, 1), <vd>, [*Verdict*], w: 220pt),
    nd(mint, (4, 1), <rp>, [*Correctness report*], w: 290pt),
    nd(rose, (3, 2), <ce>, [*Counterexample* \ #sub[witness on real GPU]], w: 290pt, dash: "dashed"),
    edge(<rt>, (0.5, 0), (0.5, 1), <sa>, "->"), edge(<pt>, <sa>, "->"), edge(<pg>, (0.5, 2), (0.5, 1), <sa>, "->"),
    edge(<sa>, <eq>, "->"), edge(<eq>, <vd>, "->"),
    edge(<vd>, <rp>, "->", stroke: 3.5pt + mint.s),
    node((3.5, 0.78), tag(mint, [correct]), stroke: none),
    edge(<vd>, <ce>, "->", stroke: 3.5pt + rose.s),
    node((3.28, 1.5), tag(rose, [incorrect]), stroke: none, fill: white, inset: 4pt),
    edge(<ce>, (1, 2), <sa>, "-->", stroke: 3.5pt + rose.s),
    node((2, 2), tag(rose, [does not reproduce → retry]), stroke: none, fill: white, inset: 6pt),
  )
}

#card("01", "System: optimize, verify, benchmark", sky)[
  #fig(fig-arch)[*Figure 1.* Each Triton kernel is mechanically translated to Gluon. Each round profiles, proposes, implements and verifies changes, then benchmarks the whole model on hidden, freshly randomized shapes. Rejected changes retry with compiler errors, numerical failures or Z3 counterexamples.]
]
#v(24pt)
#card("02", "Correctness pipeline: LLM reasoning with Z3 evidence", mint)[
  #fig(fig-corr)[*Figure 2.* Reference (PyTorch, Triton) and the previous Gluon kernel are split into symbolic regions and aligned. Aligned tuples are checked for equivalence and hardware properties; failures become counterexamples reproduced on GPU.]
]
#v(24pt)

// ═════════════ TWO COLUMNS ═════════════
#let code(body) = block(fill: rgb("#f6f4f9"), stroke: 2pt + grey.s, radius: 14pt, inset: 20pt, width: 100%,
  text(font: mono, size: 25pt, body))
#let hd(..a, b) = table.cell(fill: mint.f, ..a.named(), text(font: sans, fill: mint.d, weight: 700, size: 25pt, b))
#let pos(b) = text(fill: mint.d, weight: 700, b)
#let lab(pal, t) = text(font: sans, weight: 700, size: 27pt, fill: pal.d, t)

#let colL = [
  #card("03", "Motivation & contributions", rose)[
    Numerical tests cover little of the execution space, so agents can *overfit to tested inputs* and miss _data races_ and _barrier_ bugs, which Hopper and Blackwell's asynchronous TMA pipelines make more likely.

    *Glueball* is the first system to equip LLM agents with *theorem-proving tools* during GPU kernel generation. It targets *Gluon*, Triton's tile-level DSL with explicit layouts and warp roles, whose structured semantics suit formal reasoning.
    - *Interactive profiling:* profilers, debuggers and compilers.
    - *Theorem provers as tools:* Z3 via our Gluon-to-Z3 library.
    - *Real-world testing:* whole models, not isolated kernels.
  ]
  #v(1fr)
  #card("04", "Hardware-aware optimization", sky)[
    - *Profile:* a whole-model pass ranks kernels by run-time share; agents use Nsight Compute and source-level probes.
    - *Propose:* one agent merges reports and history into a ranked multi-kernel portfolio.
    - *Implement:* edits pass compilation, numerics (FpSan) and blockwise formal checks.
    - *Benchmark:* hidden, re-randomized inputs; only fully verified proposals commit.
  ]
  #v(1fr)
  #card("05", "Formal tools in the loop", mint)[
    Equivalence is undecidable and GPU state spaces explode, so verification is *hybrid*.
    - *Symbolic execution* maps IR ops to Z3 terms over symbolic inputs; softmax is recovered as $exp(x - m) / sum exp(x - m)$.
    - *Opaque operations* (reductions, memory, sync, loops) split a kernel into *symbolic regions*: Z3 reasons inside, the LLM across boundaries.
    - *Gluon-to-Z3 library* models async copies, barriers and shared memory to check race freedom and pipeline stage isolation.
  ]
  #v(1fr)
  #card("06", "Conclusions", lav)[
    Formal tools in the loop *find more bugs with fewer false positives*, while agents gain from data movement and algorithmic changes. *Next:* multi-GPU kernels and constraint-guided schedule search.
  ]
]

#let colR = [
  #card("07", "Whole-model speedups over Triton", sun)[
    #fig(image("figures/violin.pdf", width: 80%))[*Figure 3.* Best-round speedup per input shape (GB10, 6 rounds). Circle = median.]
    #v(8pt)
    - *GPT-OSS:* DeepSeek V4 Pro folds the QKV transpose into the TMA descriptor and indexes GQA heads in-kernel.
    - *Qwen-3.5 MoE:* *TMA gather* moves routed token rows; contiguous TMA moves expert weights.
    - *Neighborhood attention:* an algorithmic win, $O(L^2 D) arrow O(L W D)$, about *25×* median.
  ]
  #v(1fr)
  #card("08", "Verification finds more bugs", mint)[
    #fig(
      table(columns: (2.6fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr), align: (left + horizon, center + horizon),
        stroke: none, inset: 8pt,
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
      ))[*Figure 4.* Generic: 50 Liger cases; sync: 22 Gluon kernels. Δ = gain from adding Glueball; Z3 *cuts sync false positives sharply*.]
  ]
  #v(1fr)
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
