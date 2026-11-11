// Glueball — A0 portrait research poster (Typst)
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "@preview/showybox:2.0.4": showybox

// ---------- palette (matches the paper's diagrams) ----------
#let c-trans = rgb(106, 61, 154)
#let c-trans-f = rgb(233, 223, 245)
#let c-opt = rgb(55, 71, 133)
#let c-opt-f = rgb(224, 229, 247)
#let c-corr = rgb(13, 110, 100)
#let c-corr-f = rgb(206, 235, 231)
#let c-gold = rgb(150, 110, 6)
#let c-gold-f = rgb(250, 232, 186)
#let c-retry = rgb(176, 34, 34)
#let c-gray = rgb(95, 95, 95)

#set page(width: 841mm, height: 1189mm, margin: (x: 24mm, top: 18mm, bottom: 26mm),
  footer: text(size: 20pt, fill: luma(90))[Poster built with Typst, fletcher and showybox. Content from "Glueball: Agentic Generation and Verification of Hardware-Optimized Gluon Kernels" (ICLR 2027 submission, under double-blind review).])
#set text(font: "Libertinus Serif", size: 24pt, lang: "en")
#set par(justify: true, leading: 0.62em, spacing: 0.95em)
#let sans = "Noto Sans"

// ---------- helpers ----------
#let section(title, body, color: c-opt) = showybox(
  frame: (
    title-color: color,
    border-color: color,
    body-color: white,
    thickness: 3pt,
    radius: 10pt,
    inset: (x: 22pt, y: 6pt),
    body-inset: 22pt,
  ),
  title-style: (weight: "bold", font: sans, size: 36pt, color: white),
  title: title,
  width: 100%,
  breakable: true,
  body,
)

#let cap(body) = text(size: 22pt, fill: luma(60), body)
#let fig(body, caption) = block(width: 100%, breakable: false)[
  #align(center, body)
  #v(6pt)
  #cap(caption)
]
#let hl(body) = text(weight: "bold", fill: c-corr, body)

// ---------- diagram node styles ----------
#let bx(color, fill, body, w: auto, dash: none, thick: 2.4pt) = node(
  stroke: (paint: color, thickness: thick, dash: dash), fill: fill, corner-radius: 8pt,
  inset: 14pt, width: w, body)

// ======================= HEADER =======================
#block(width: 100%, fill: gradient.linear(c-opt, c-corr, angle: 0deg), radius: 14pt, inset: 28pt)[
  #set text(fill: white, font: sans)
  #grid(columns: (1fr, auto), align: horizon,
    [
      #text(size: 90pt, weight: "black")[Glueball]
      #v(-6pt)
      #text(size: 42pt, weight: "medium")[Agentic Generation and Verification of Hardware-Optimized Gluon Kernels]
      #v(10pt)
      #text(size: 34pt)[Anonymous authors #h(1em) · #h(1em) Paper under double-blind review #h(1em) · #h(1em) ICLR 2027 submission]
    ],
    block(fill: white.transparentize(85%), radius: 12pt, inset: 26pt, stroke: 2pt + white)[
      #text(size: 30pt, weight: "bold")[Keywords]\
      #text(size: 28pt)[LLM agents · GPU kernels · Gluon / Triton\ Z3 theorem proving · Blackwell TMA]
    ])
]
#v(12pt)

// ======================= ABSTRACT =======================
#block(width: 100%, fill: c-gold-f, stroke: 3pt + c-gold, radius: 12pt, inset: 30pt)[
  #text(font: sans, weight: "bold", size: 40pt, fill: c-gold)[Abstract] \
  LLM agents are well suited to exploring the GPU optimization space through iterative code generation, but numerical testing alone covers little of the input and execution space: agents can overfit to tested inputs and miss correctness violations that stem from subtle hardware-execution semantics. *Glueball is the first system to equip LLM agents with theorem-proving tools to reason about correctness during GPU kernel generation.* It targets *Gluon*, Triton's tile-level DSL with direct access to GPU hardware, and optimizes single- and multi-kernel workloads using end-to-end model performance and theorem-prover guidance as feedback. Results show improved kernel bug detection and end-to-end performance competitive with already-performant Triton baselines.
]
#v(12pt)

// ======================= FIGURE 1 (full width) =======================
#section("System Architecture: Optimize → Verify → Benchmark", color: c-opt)[
  #fig(
    { set par(justify: false); diagram(
      node-inset: 12pt, spacing: (72pt, 22pt), edge-stroke: 2.4pt, mark-scale: 90%,
      label-size: 28pt, node-defocus: 0,
      // column 0..7
      node((0, 1), [*Triton Model*\ #text(size: 24pt)[$K$ kernels]], name: <src>,
        stroke: 2.4pt + luma(110), fill: luma(244), corner-radius: 8pt, width: 215pt),
      node((1, 0), [Kernel 1\ AST translation], name: <a1>, stroke: 2.4pt + c-trans, fill: c-trans-f, corner-radius: 8pt, width: 215pt),
      node((1, 1), [Kernel 2\ AST translation], name: <a2>, stroke: 2.4pt + c-trans, fill: c-trans-f, corner-radius: 8pt, width: 215pt),
      node((1, 2), [Kernel $K$\ AST translation], name: <a3>, stroke: 2.4pt + c-trans, fill: c-trans-f, corner-radius: 8pt, width: 215pt),
      node((2, 1), [*Gluon Model*\ $M^((r))$\ #text(size: 24pt)[$K$ kernels]], name: <state>,
        stroke: 3pt + c-gold, fill: c-gold-f, corner-radius: 8pt, width: 215pt),
      node((3, 0), [Kernel 1\ Profiling Agent], name: <p1>, stroke: 2.4pt + c-opt, fill: c-opt-f, corner-radius: 8pt, width: 215pt),
      node((3, 1), [Kernel 2\ Profiling Agent], name: <p2>, stroke: 2.4pt + c-opt, fill: c-opt-f, corner-radius: 8pt, width: 215pt),
      node((3, 2), [Kernel $K$\ Profiling Agent], name: <p3>, stroke: 2.4pt + c-opt, fill: c-opt-f, corner-radius: 8pt, width: 215pt),
      node((4, 1), [*Proposal*\ Agent], name: <prop>, stroke: 2.4pt + c-opt, fill: c-opt-f, corner-radius: 8pt, width: 215pt),
      node((5, 1), [*Implementation*\ Agent], name: <impl>, stroke: 2.4pt + c-opt, fill: c-opt-f, corner-radius: 8pt, width: 215pt),
      node((6, 0), [Kernel 1\ Verification], name: <v1>, stroke: 2.4pt + c-corr, fill: c-corr-f, corner-radius: 8pt, width: 215pt),
      node((6, 1), [Kernel 2\ Unchanged], name: <v2>, stroke: 2.4pt + luma(110), fill: luma(244), corner-radius: 8pt, width: 215pt),
      node((6, 2), [Kernel $K$\ Verification], name: <v3>, stroke: 2.4pt + c-corr, fill: c-corr-f, corner-radius: 8pt, width: 215pt),
      node((7, 1), [*Updated Gluon Model*\ $M^((r+1))$\ #text(size: 24pt)[$K$ kernels]], name: <next>,
        stroke: 3pt + c-gold, fill: c-gold-f, corner-radius: 8pt, width: 215pt),
      node((7, 0), [*Full-Model\ Benchmarking*], name: <bench>, stroke: 2.4pt + luma(110), fill: white, corner-radius: 8pt, width: 215pt),
      node((1, 0.5), $dots.v$), node((3, 0.5), $dots.v$), node((6, 0.5), $dots.v$),
      node((1, 1.5), $dots.v$), node((3, 1.5), $dots.v$), node((6, 1.5), $dots.v$),
      node(enclose: (<p1>, <p3>, <v1>, <v3>, <impl>), name: <round>,
        stroke: (paint: c-gray, dash: "dashed", thickness: 2.4pt), fill: none, corner-radius: 16pt, inset: 42pt),
      node((3.15, -0.78), text(fill: c-gray, weight: "bold")[Optimization round $r$], stroke: none, fill: white),
      node((4.5, 3.1), [*Held-out Testbench*], name: <test>, stroke: (paint: luma(110), dash: "dashed", thickness: 2.4pt), corner-radius: 8pt, width: 215pt),
      // flow
      edge(<src>, (0.5, 1), (0.5, 0), <a1>, "->"), edge(<src>, "->", <a2>), edge(<src>, (0.5, 1), (0.5, 2), <a3>, "->"),
      edge(<a1>, (1.5, 0), (1.5, 1), <state>, "->"), edge(<a2>, "->", <state>), edge(<a3>, (1.5, 2), (1.5, 1), <state>, "->"),
      edge(<state>, (2.5, 1), (2.5, 0), <p1>, "->"), edge(<state>, "->", <p2>), edge(<state>, (2.5, 1), (2.5, 2), <p3>, "->"),
      edge(<p1>, (3.5, 0), (3.5, 1), <prop>, "->"), edge(<p2>, "->", <prop>), edge(<p3>, (3.5, 2), (3.5, 1), <prop>, "->"),
      edge(<prop>, "->", <impl>),
      edge(<impl>, (5.5, 1), (5.5, 0), <v1>, "->"), edge(<impl>, "->", <v2>, stroke: (dash: "dotted")), edge(<impl>, (5.5, 1), (5.5, 2), <v3>, "->"),
      edge(<v1>, (6.5, 0), (6.5, 1), <next>, "->"), edge(<v2>, "->", <next>), edge(<v3>, (6.5, 2), (6.5, 1), <next>, "->"),
      edge(<next>, <bench>, "->"),
      edge(<bench>, (7, -1.7), (2, -1.7), <state>, "->"),
      node((4.5, -1.7), [Repeat until max rounds], fill: white, stroke: none),
      edge(<v3>, (6, 2.55), (5, 2.55), <impl>, "-->", stroke: (paint: c-retry, dash: "dashed")),
      node((5.5, 2.55), text(fill: c-retry, size: 22pt)[reject: retry with feedback], fill: white, stroke: none),
      edge(<src>, (0, 3.1), <test>, "-->", stroke: (paint: luma(110), thickness: 1.6pt)),
      edge(<next>, (7, 3.1), <test>, "-->", stroke: (paint: luma(110), thickness: 1.6pt)),
    ) },
    [*Figure 1.* The loop translates each Triton kernel to Gluon by AST rewriting, then each round _profiles_, _proposes_, _implements_ and _benchmarks_. Every candidate is formally and empirically validated by the correctness pipeline before benchmarking and committing; rejected changes retry with feedback.],
  )
]
#v(12pt)

#section("Correctness Pipeline", color: c-corr)[
  #fig(
    { set par(justify: false); diagram(
      node-inset: 10pt, spacing: (120pt, 22pt), edge-stroke: 2.2pt, mark-scale: 90%, label-size: 24pt,
      node((0, 0), [*Reference Triton*], name: <rt>, stroke: 2.2pt + luma(110), fill: luma(244), corner-radius: 8pt, width: 270pt),
      node((0, 1), [*PyTorch Reference*], name: <pt>, stroke: 2.2pt + luma(110), fill: luma(244), corner-radius: 8pt, width: 270pt),
      node((0, 2), [*Previous Gluon*], name: <pg>, stroke: 2.2pt + c-gold, fill: c-gold-f, corner-radius: 8pt, width: 270pt),
      node((1, 1), [*Splitter*\ #text(size: 22pt)[segments blocks]], name: <sp>, stroke: 2.2pt + c-corr, fill: c-corr-f, corner-radius: 8pt, width: 202pt),
      node((2, 1), [*Mapper*\ #text(size: 22pt)[aligns tuples]], name: <mp>, stroke: 2.2pt + c-corr, fill: c-corr-f, corner-radius: 8pt, width: 202pt),
      node((3, 1), [*Block-wise Equivalence*], name: <eq>, stroke: 2.2pt + c-corr, fill: c-corr-f, corner-radius: 8pt, width: 256pt),
      node((4, 1), [*Verdict*], name: <vd>, stroke: 2.2pt + c-corr, fill: c-corr-f, corner-radius: 8pt, width: 175pt),
      node((4, 2.5), [*Counterexample*\ #text(size: 22pt)[reproduce on GPU]], name: <ce>, stroke: (paint: c-retry, dash: "dotted", thickness: 2.4pt), fill: white, corner-radius: 8pt, width: 270pt),
      node((5, 1), [*Correctness Report*], name: <rp>, stroke: 3pt + c-corr, fill: c-corr-f, corner-radius: 8pt, width: 256pt),
      node(enclose: (<eq>, <vd>), stroke: (paint: c-corr, dash: "dashed", thickness: 2pt), corner-radius: 14pt, inset: 22pt,
        snap: false, name: <z3>),
      edge(<pt>, <sp>, "->"), edge(<rt>, (1.5, 0), (1.5, 1), <mp>, "->"), edge(<pg>, (1.5, 2), (1.5, 1), <mp>, "->"),
      edge(<sp>, <mp>, "->"), edge(<mp>, <eq>, "->"), edge(<eq>, <vd>, "->"),
      edge(<vd>, <rp>, "->", label: text(fill: c-corr)[correct], label-side: left),
      edge(<vd>, <ce>, "->", label: text(fill: c-retry)[incorrect], label-side: left, label-sep: 8pt),
      edge(<ce>, (5, 2.5), <rp>, "->"),
      edge(<ce>, (3, 2.5), (3, 2.2), (2, 2.2), <mp>, "-->", stroke: c-retry + 2pt, label: text(fill: c-retry)[retry], label-pos: 0.2, label-side: left),
    ) },
    [*Figure 2.* Reference and candidate programs are segmented and aligned; each region is checked with LLM reasoning and Z3 tools. Failures become concrete witnesses used for retry or the final verdict.],
  )
]
#v(12pt)

// ======================= TWO COLUMNS =======================
#columns(2, gutter: 28pt)[

#section("Motivation & Contributions", color: c-retry)[
  - Finite test suites miss *concurrency bugs* (races, barrier misuse). Hopper/Blackwell make this worse: warp specialization, TMA and multi-stage pipelines create a huge asynchronous state space.
  - LLMs adapt expert patterns per kernel, but reasoning about run-time GPU semantics is still a weak spot.
  + *Interactive profiling interface:* profilers, debuggers, compilers.
  + *Theorem provers as tools:* Z3 feedback via our *Gluon-to-Z3 library* (race, bank-conflict, barrier-order checks).
  + *Whole-model performance testing* on representative shapes.
  - *Why Gluon?* It sits _below_ Triton, exposing explicit layouts and warp specialization with tile-level semantics suited to formal reasoning.
]

#v(10pt)

#section("Optimization Pipeline (per round)", color: c-opt)[
  + *Profile:* Nsight Compute + source probes rank kernels by end-to-end impact.
  + *Propose:* one agent ranks multi-kernel transformations using IR, PTX and micro-benchmarks.
  + *Implement & verify:* compile, numerics (FpSan), blockwise formal checks; failures return *Z3 counterexamples*.
  + *Benchmark:* hidden, re-randomized inputs each round; only fully passing proposals are committed.
]

#v(10pt)

#section("Formal-Tools-Guided Verification", color: c-corr)[
  Equivalence is undecidable and GPU state spaces explode, so Glueball is *hybrid*: symbolic execution + LLM reasoning + targeted Z3 models.
  - *Symbolic execution:* IR ops → Z3 expressions over symbolic inputs; softmax is recovered as $"exp"(x - max) / "sum"$.
  - *Opaque ops* (reductions, memory, sync, loops) split kernels into *symbolic regions*: Z3 inside, LLM across boundaries.
  - *Gluon-to-Z3:* async-copy, barrier and shared-memory models.
]

#v(10pt)

#section("Correctness Results", color: c-corr)[
  #let hd(..a, b) = table.cell(fill: c-corr, ..a.named(), text(fill: white, weight: "bold", size: 21pt, b))
  #let dl(b) = text(fill: c-corr, weight: "bold", b)
  #fig(
    table(
      columns: (1.9fr, 0.8fr, 0.8fr, 0.9fr, 0.8fr, 0.8fr, 0.8fr, 0.9fr, 0.8fr),
      align: (left, center), stroke: 1pt + luma(190), inset: 10pt, fill: (_, y) => if y > 1 and calc.odd(y) { luma(245) },
      hd(rowspan: 3)[Model],
      hd(colspan: 4)[Generic Suite], hd(colspan: 4)[Synchronization Suite],
      hd(colspan: 2)[Detected ↑ (of 24)], hd(colspan: 2)[False pos. ↓ (of 26)],
      hd(colspan: 2)[Detected ↑ (of 10)], hd(colspan: 2)[False pos. ↓ (of 12)],
      ..for _ in range(4) { (hd[Base], hd[Δ]) },
      [DeepSeek V4 Pro], [21], dl[+3], [0], [0], [10], [0], [7], dl[−5],
      [DeepSeek V4 Flash], [22], dl[+2], [0], [0], [10], [0], [1], dl[−1],
      [Meta Muse Spark 1.3], [22], dl[+2], [0], [0], [9], [0], [3], dl[−3],
      [GPT 5.6 Sol], [21], dl[+2], [0], [0], [9], dl[+1], [1], dl[−1],
    ),
    [*Figure 4.* Glueball improves bug detection for all four models with no more false positives. Δ is the change when the Glueball pipeline is added to a baseline LLM.],
  )
  #v(8pt)
  - *Generic:* 50 cases (24 bugs, 26 controls) from 7 Liger operators; *zero false positives*.
  - *Synchronization:* 22 Gluon kernels (10 bugs, 12 controls); Z3 tools *cut false positives* sharply (7 → 2 for V4 Pro).
]

#v(10pt)

#section("Conclusions & Future Work", color: c-gold)[
  - First system to integrate formal verification into agentic GPU kernel optimization: more bugs found, fewer false positives, gains from data movement, hardware execution and algorithmic structure.
  - *Next:* multi-GPU and heterogeneous targets; constraint- and statistics-guided pipeline-schedule search.
]

#colbreak()

#section("Optimization Results", color: c-gold)[
  _Setup:_ DGX Spark (GB10), 6 rounds; agents DeepSeek V4 Pro/Flash, Meta Muse Spark 1.3, GPT 5.6 Sol; GPT-OSS, Qwen-3.5 MoE, Mamba-2 and 3 Liger kernels.
  #v(6pt)
  #fig(
    image("figures/violin.pdf", width: 76%),
    [*Figure 3.* Best-round speedup across input shapes (end-to-end). Violins show the per-shape density; the circle is the median (green ≥ parity, red below). Some panels are log-scale.],
  )
  #v(8pt)
  - *GPT-OSS:* DeepSeek V4 Pro folds the QKV transpose into the TMA descriptor and indexes GQA heads in-kernel, cutting memory traffic.
  - *Qwen-3.5 MoE:* *TMA gather* moves routed token rows; contiguous TMA moves weight tiles.
  - *Mamba-2:* Triton's pipeline is already strong; extra buffering cost more than it overlapped.
  - *Neighborhood attention:* algorithmic win, $O(L^2 D) arrow O(L W D)$, about *25× median*.
]

#v(10pt)

#section("Case Study: Z3 Exposes a Pipelining Bug", color: c-retry)[
  #let code(body, ..a) = block(fill: luma(247), stroke: 1.5pt + luma(180), radius: 6pt, inset: 16pt, width: 100%,
    text(font: "Source Code Pro", size: 18pt, body))
  #grid(columns: (1fr, 1fr), gutter: 18pt,
    [#text(weight: "bold", size: 24pt)[(a) Pipelining bug]
     #code(```python
# Correct
cp.wait_group(num_buffers - 1)
perform_add(a_smem[read_idx % n],
            b_smem[read_idx % n])

# Bug: copy still outstanding
cp.wait_group(num_buffers)
perform_add(a_smem[read_idx % n],
            b_smem[read_idx % n])
```)
     ],
    [#text(weight: "bold", size: 24pt, fill: c-retry)[(c) Z3 verdict]
     #code(```
wait_group(2): DATA RACE
  copy0 STORE SHARED@0x100
        proxy=ASYNC_COPY
  <-race->
  read buffer0
        LOAD SHARED@0x100
        proxy=GENERIC
wait_group(1): RACE-FREE: proven
```)],
    [#text(weight: "bold", size: 24pt, fill: c-retry)[(d) Pipeline witness]
     #code(```
check_pipeline_stage_isolation(
    num_stages=2, max_inflight=2)

PIPELINE COLLISION:
 producer and consumer share a slot
 witness: [iter_p = 2, lag = 2]

max_inflight=1:
STAGE-ISOLATED: num_stages=2
never aliases with up to 1
in-flight iteration
```)])
  #v(8pt)
  #cap[*Figure 5.* The buggy kernel waits for too few async copies. Z3 finds the conflicting async write and shared read, plus a concrete iteration witness where producer and consumer alias one slot.]
]

]

