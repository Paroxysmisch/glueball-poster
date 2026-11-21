all: poster.pdf poster-cascade.pdf

poster.pdf: poster.typ figures/speedups.json
	typst compile poster.typ poster.pdf

poster-cascade.pdf: poster-cascade.typ figures/speedups.json latex-src/logos/cascade-logo-reversed.pdf
	typst compile poster-cascade.typ poster-cascade.pdf
