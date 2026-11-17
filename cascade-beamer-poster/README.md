# CASCADE Beamer poster theme

A0 poster templates for LaTeX users, matching the CASCADE PowerPoint posters.

| File | What it is |
|---|---|
| `beamerthemeCascade.sty` | The theme: colours, fonts, logos, header/footer, section style |
| `cascade-poster-portrait.tex` | A0 portrait example (red banner, three columns, red footer) |
| `cascade-poster-landscape.tex` | A0 landscape example (red side panel, peach section cards) |
| `logos/` | CASCADE logo (vector PDF) and University of Cambridge logo (white, PNG) |

## Building

```
latexmk -pdf cascade-poster-portrait.tex       # pdflatex (Helvetica)
latexmk -xelatex cascade-poster-portrait.tex   # uses Rubik + Arial if installed
```

Works on Overleaf: upload the whole folder and pick pdfLaTeX or XeLaTeX.
Rubik (the CASCADE website font) is free from Google Fonts. Without it,
headings fall back to the body font.

## Using the theme

```latex
\documentclass[final]{beamer}
\usepackage[size=a0,orientation=portrait,scale=1.4]{beamerposter}
\usetheme{Cascade}            % portrait banner layout
% \usetheme[panel]{Cascade}   % landscape side-panel layout (use orientation=landscape)
```

Metadata, set in the preamble:

```latex
\title{...}  \author{...}  \institute{...}
\event{Conference · City · Date}
\contact{name@cl.cam.ac.uk}
\qrurl{https://...}        % the QR code is generated from this URL
\supporters{...}           % portrait footer
\takeaway{...}             % landscape panel "In one sentence" box
```

Building blocks inside the frame:

- `\begin{block}{Title}` gives an automatically numbered section with a red chip
  (in the panel layout it is a peach card).
- `\begin{alertblock}{KEY TAKEAWAY}` gives a red takeaway box.
- `\begin{exampleblock}{}` or `\begin{cascadecard}` gives a plain peach card.
- `\cascadestat{2.3$\times$}{speed-up}` gives a large headline number with a label.
- `\cascadeplaceholder{30cm}` gives a dashed figure box. Replace it with
  `\includegraphics[width=\linewidth]{...}`.
- `cascade bars` is a pgfplots style for bar charts in the CASCADE colours.

Colours available: `cascadered`, `cascadepeach`, `cascadetext`, `cascadegrey`,
`cascadelightgrey`, `cascadedarkred`.
