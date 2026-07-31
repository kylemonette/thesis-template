# A URI Graduate Thesis Template

This repository is a modern upgrade to the URI graduate school LaTeX thesis template, originally written by Tim Toolan and available at [web.uri.edu/engineering/thesisguide/template-files/](https://web.uri.edu/engineering/thesisguide/template-files/).

Major changes include:

- **`urithesis.cls`** - modernized internals, options rewritten with `etoolbox` instead of legacy `\newif`.
- **Unified bibliography** — the separate `urithesis-biblatex.cls` and its example files have been dropped entirely; there's now one class supporting both `oneref` (single end-of-thesis list) and `chapterref` (per-chapter reference lists) via BibTeX.
- **New `bibliography` class option** — lets you optionally emit a combined alphabetical bibliography section at the end (e.g. with `\nocite{*}`) without duplicating it by default, fixing a prior duplicate-bibliography issue.
- **Modernized `\@include` override** — now uses LaTeX 2020+ include hooks (`include/before`, `include/end`, `include/after`) so packages like `hyperref` behave correctly, adds an `\ifx\@nodocument\relax` guard, quotes filenames for path safety, and notifies packages of the current file via `\@filehook@set@CurrentFile`.
- **Auto-generated `genbib.sh`** — replaces the old plain-text `genbib.txt` instructions with a shell script that runs BibTeX per-chapter and re-runs `pdflatex` the correct number of times.
- **New/expanded class options**: `bibliography`, `draftbox`, `noprelim`, `nobib`, `simpleref`, plus clearer defaults (`masters`/`phd`, `oneref`/`chapterref`, `topnum`/`bottomnum`, `hardcopy`/`electronic`, `sequential`/`nonsequential`).
- **`\cl@chapter` and per-chapter counter handling cleaned up** to avoid the token-stream corruption that could occur when other packages (e.g. `listings`) extend LaTeX's counter-reset lists via `\AtBeginDocument`.
