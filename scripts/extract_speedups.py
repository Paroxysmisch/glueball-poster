"""Recover the per-shape speedup data behind the paper's violin figure.

The figure PDF is vector: swarm points, violin outlines, median markers and tick labels can be
read back and calibrated against the tick labels. Output: figures/speedups.json
(used by poster.typ to redraw the plot natively with lilaq).

usage: pdftocairo -svg src/diagrams/best_by_experiment_violin.pdf /tmp/v.svg
       pdftotext -bbox src/diagrams/best_by_experiment_violin.pdf /tmp/bb.html
       python3 scripts/extract_speedups.py /tmp/v.svg /tmp/bb.html
"""
import re, sys, json, math, statistics
svg = open(sys.argv[1]).read(); bb = open(sys.argv[2]).read()
body = svg[svg.index("</defs>"):]

def pts(d):
    n = [float(v) for v in re.findall(r"-?\d+\.?\d*(?:e-?\d+)?", d)]
    return list(zip(n[0::2], n[1::2]))
def tf(el):
    m = re.search(r"matrix\(([^)]*)\)", el)
    return [float(v) for v in m.group(1).split(",")] if m else None
def apply(p, m):
    return (m[0] * p[0] + m[4], m[3] * p[1] + m[5]) if m else p

paths = re.findall(r"<path[^>]*/>", body)
panels, bodies, circles, dots = [], [], [], []
for el in paths:
    d = re.search(r' d="([^"]*)"', el).group(1); m = tf(el)
    fill = re.search(r'fill="rgb\(([^)]*)\)"', el); op = re.search(r'fill-opacity="([\d.]+)"', el)
    sw = re.search(r'stroke-width="([\d.]+)"', el)
    P = [apply(p, m) for p in pts(d)]
    if not fill:
        continue
    col = fill.group(1); o = float(op.group(1)) if op else 1
    green = col.startswith("15.6")
    if "100%, 100%, 100%" in col and not sw and len(P) <= 5:
        xs = [p[0] for p in P]; ys = [p[1] for p in P]
        if max(xs) - min(xs) < 800: panels.append((min(xs), max(xs), min(ys), max(ys)))
    elif abs(o - 0.18) < 1e-3: bodies.append((green, P))
    elif sw and abs(float(sw.group(1)) - 1.6) < 1e-3:
        st = re.search(r'stroke="rgb\(([^)]*)\)"', el).group(1)
        circles.append((sum(p[0] for p in P) / len(P), sum(p[1] for p in P) / len(P), st.startswith("15.6")))
    elif abs(o - 0.76) < 1e-3:
        dots.append((m[4], m[5], green))
panels = sorted(set(panels), key=lambda p: (round(p[2] / 100), p[0]))
words = [(float(a), float(b), float(c), float(d), w) for a, b, c, d, w in
         re.findall(r'xMin="([\d.]+)" yMin="([\d.]+)" xMax="([\d.]+)" yMax="([\d.]+)">([^<]*)</word>', bb)]
titles = ["GPT-OSS", "Qwen-3.5 MoE", "Mamba-2", "Cross-Entropy", "Llama-4 RoPE", "Neighborhood Attention"]
out = []
for k, (x0, x1, y0, y1) in enumerate(panels):
    inside = lambda x, y: x0 - 1 <= x <= x1 + 1 and y0 - 1 <= y <= y1 + 1
    ticks = [((w[1] + w[3]) / 2 - 0.3, float(w[4].rstrip("×")))
             for w in words if w[4].endswith("×") and x0 - 45 < w[2] <= x0 - 1 and y0 - 8 < (w[1] + w[3]) / 2 < y1 + 8
             and not re.fullmatch(r"\d+\.\d{3}×", w[4])]
    logscale = titles[k] in ("Cross-Entropy", "Neighborhood Attention")
    f = (lambda v: math.log(v)) if logscale else (lambda v: v)
    ty = [t[0] for t in ticks]; tv = [f(t[1]) for t in ticks]
    # refine with the printed median labels (3 decimals), matched to the median circles left-to-right
    cs0 = sorted([c for c in circles if inside(c[0], c[1])], key=lambda c: c[0])
    lab = sorted([w for w in words if re.fullmatch(r"\d+\.\d{3}×", w[4]) and inside((w[0] + w[2]) / 2, (w[1] + w[3]) / 2)],
                 key=lambda w: w[0])
    assert len(lab) == len(cs0) == 4, (titles[k], len(lab))
    ty = [c[1] for c in cs0]; tv = [f(float(w[4].rstrip("×"))) for w in lab]
    my, mv = statistics.mean(ty), statistics.mean(tv)
    a = sum((y - my) * (v - mv) for y, v in zip(ty, tv)) / sum((y - my) ** 2 for y in ty)
    val = lambda y: (math.exp if logscale else (lambda z: z))(mv + a * (y - my))
    cs = sorted([c for c in circles if inside(c[0], c[1])], key=lambda c: c[0])
    assert len(cs) == 4, (titles[k], len(cs))
    models = []
    for ci, c in enumerate(cs):
        mine = [d for d in dots if inside(d[0], d[1])]
        # nearest circle by x
        mine = [d for d in mine if min(range(4), key=lambda j: abs(cs[j][0] - d[0])) == ci]
        bod = [b for b in bodies if inside(*b[1][0]) and abs(sum(p[0] for p in b[1]) / len(b[1]) - c[0]) < 20][0]
        P = bod[1]; cx = c[0]
        # outline -> (value, half-width) on the right edge
        half = sorted({round(p[1], 3): abs(p[0] - cx) for p in P if p[0] > cx - 0.5}.items())
        models.append(dict(label=lab[ci][4].rstrip("×"), median=val(c[1]), vals=[val(d[1]) for d in mine],
                           off=[(d[0] - cx) for d in mine], good=c[2],
                           outline=[(val(y), w) for y, w in half][::2]))
    wmax = max(w for m in models for _, w in m["outline"])
    for m in models:
        m["outline"] = sorted((round(v, 5), round(w / wmax, 4)) for v, w in m["outline"])
        m["off"] = [round(o / wmax, 4) for o in m["off"]]
        m["vals"] = [round(v, 5) for v in m["vals"]]
    out.append(dict(name=titles[k], log=logscale, models=models, n=len(models[0]["vals"])))
json.dump(out, open("figures/speedups.json", "w"))
for e in out:
    print(e["name"], e["n"], [round(m["median"], 3) for m in e["models"]], [len(m["vals"]) for m in e["models"]])
