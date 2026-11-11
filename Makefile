poster.pdf: poster.typ figures/speedups.json fonts/*
	typst compile --font-path fonts poster.typ poster.pdf
