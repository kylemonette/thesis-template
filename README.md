# A URI Graduate Thesis Template

### Author: Kyle Monette, [kylemonette.github.io](https://kylemonette.github.io)

#### Updated: October 28, 2026

---

This repository is a modern upgrade to the URI graduate school LaTeX thesis template, `urithesis.cls` version 2.0 by Timothy Toolan. It is a modified version of that work; see [License](#license) below.

The documentation is in [`urithesis-doc.pdf`](urithesis-doc.pdf).

Major changes include:

- **`urithesis.cls`**  &mdash; Modernized internals, options rewritten with `etoolbox` instead of legacy `\newif`.
- **Unified bibliography** &mdash; the separate `urithesis-biblatex.cls` and its example files have been dropped entirely; there's now one class supporting both `oneref` (single end-of-thesis list) and `chapterref` (per-chapter reference lists) via BibTeX.
- **New `bibliography`/`nobibliography` class options** &mdash; control the combined alphabetical bibliography section at the end (e.g. with `\nocite{*}`). It is on by default in standard format, where the Graduate School requires it, and off in manuscript format, where it is optional.
- **Modernized `\@include` override** &mdash; now uses LaTeX 2020+ include hooks (`include/before`, `include/end`, `include/after`) so packages like `hyperref` behave correctly.
- **Auto-generated `genbib.sh`** &mdash; replaces the old plain-text `genbib.txt` instructions with a shell script that runs BibTeX per-chapter and re-runs `pdflatex` the correct number of times. Only needed for manual offline builds; Overleaf and `latexmk` handle this automatically.
- **New/expanded class options**: `bibliography`, `nobibliography`, `draftbox`, `noprelim`, `nobib`, `simpleref`, plus clearer defaults (`masters`/`phd`, `oneref`/`chapterref`, `topnum`/`bottomnum`, `hardcopy`/`electronic`, `sequential`/`nonsequential`).
- **`\cl@chapter` and per-chapter counter handling cleaned up** to avoid the token-stream corruption that could occur when other packages (e.g. `listings`) extend LaTeX's counter-reset lists via `\AtBeginDocument`.

---

## Quick start

For offline setups, this requires a TeX distribution with LaTeX 2020-10-01 or newer providing `pdflatex` and `bibtex`.
Alternatively, Overleaf works well.

1. Edit the metadata in `thesis.tex` (title, author, department, committee, Dean) and choose your class options.
2. Write your chapters in `chapter1.tex`, `chapter2.tex`, etc., and add entries to `references.bib`.
3. Compile:

   - **Overleaf:** upload all the files and compile as usual. `genbib.sh` is not needed.
   - **Locally with latexmk:**

     ```bash
     latexmk -pdf thesis
     ```

   - **Locally without latexmk:** run `pdflatex thesis` once, then the script the class generates. It runs `bibtex` on each `.aux` file that needs it and then `pdflatex` twice more:

     ```bash
     sh genbib.sh
     ```

     On systems without `sh`, run the `bibtex` commands listed in `genbib.txt`, then `pdflatex thesis` twice.

See [`urithesis-doc.pdf`](urithesis-doc.pdf), or the comments at the top of `thesis.tex`, for the full list of class options.

## Files

| File | Purpose |
| --- | --- |
| `urithesis.cls` | The document class |
| `uriref.bst`, `uriapa.bst` | BibTeX styles for the numeric and author–year reference lists |
| `uribib.bst` | BibTeX style for the optional alphabetical bibliography |
| `thesis.tex` | Main file: options, metadata, and the list of chapters/appendices |
| `abstract.tex`, `acknowledgements.tex`, `dedication.tex`, `preface.tex` | Preliminary-page content |
| `chapter*.tex`, `appendixA.tex` | Sample chapters and appendix |
| `references.bib` | Sample BibTeX database |
| `thesis.pdf` | The compiled sample |
| `urithesis-doc.tex`, `urithesis-doc.pdf` | The documentation |
| `README.txt` | README for the CTAN package |
| `build-ctan.sh` | Builds the CTAN upload, `urithesis.zip` |

`genbib.sh` and `genbib.txt` are written by the class on each compile and are not stored in the repository.

## CTAN package

Run `sh build-ctan.sh` to compile the documentation and sample thesis and create `urithesis.zip`, which contains only the files listed above for CTAN (no `.git`, `.gitignore`, generated, or auxiliary files).

## License

This work may be distributed and/or modified under the conditions of the [LaTeX Project Public License](https://www.latex-project.org/lppl.txt), version 1.3c or later.

`urithesis.cls` is a modified version of `urithesis.cls` version 2.0 (2016), copyright University of Rhode Island, written by Timothy Toolan. Timothy Toolan does not support this modified version; report problems in the [issue tracker](https://github.com/kylemonette/thesis-template/issues). The changes are listed in the section "Changes from version 2.0" of `urithesis-doc.pdf`. The unmodified version 2.0 is available from <https://www.ele.uri.edu/info/thesis/dist/thesis.zip> and is archived at <https://web.archive.org/web/20260216180715/https://www.ele.uri.edu/info/thesis/dist/thesis.zip>.

The BibTeX styles keep the licenses stated in each file: `uriref.bst` and `uribib.bst` are based on `IEEEtran.bst` and `IEEEtranS.bst` by Michael Shell (Perl Artistic License), and `uriapa.bst` is based on `apalike.bst` by Oren Patashnik.