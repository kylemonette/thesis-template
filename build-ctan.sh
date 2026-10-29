#!/bin/sh
# build-ctan.sh --- build rhode-island-thesis.zip for upload to CTAN.
#
# Compiles the documentation and the sample thesis, then copies the
# package files (and nothing else) into rhode-island-thesis/ and zips it.
# Generated files such as genbib.sh, genbib.txt, and .aux files, and
# macOS .DS_Store files, are left out, as CTAN requires.

set -e

latexmk -pdf -silent rhode-island-thesis-doc
latexmk -pdf -silent rhode-island-thesis

rm -rf rhode-island-thesis rhode-island-thesis.zip
mkdir rhode-island-thesis
cp README.txt rhode-island-thesis.cls rhode-island-thesis-ref.bst rhode-island-thesis-bib.bst rhode-island-thesis-apa.bst \
   rhode-island-thesis-doc.tex rhode-island-thesis-doc.pdf \
   rhode-island-thesis.tex abstract.tex acknowledgements.tex dedication.tex preface.tex \
   chapter1.tex chapter2.tex chapter3.tex appendixA.tex references.bib \
   rhode-island-thesis.pdf \
   rhode-island-thesis/
# macOS Finder can create .DS_Store files, which CTAN does not accept.
find rhode-island-thesis -name .DS_Store -delete
zip -r -q rhode-island-thesis.zip rhode-island-thesis -x '*.DS_Store'
rm -rf rhode-island-thesis

echo "Created rhode-island-thesis.zip"
