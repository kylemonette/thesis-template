#!/bin/sh
# build-ctan.sh --- build urithesis.zip for upload to CTAN.
#
# Compiles the documentation and the sample thesis, then copies the
# package files (and nothing else) into urithesis/ and zips it.
# Generated files such as genbib.sh, genbib.txt, and .aux files, and
# macOS .DS_Store files, are left out, as CTAN requires.

set -e

latexmk -pdf -silent urithesis-doc
latexmk -pdf -silent thesis

rm -rf urithesis urithesis.zip
mkdir urithesis
cp README.txt urithesis.cls uriref.bst uribib.bst uriapa.bst \
   urithesis-doc.tex urithesis-doc.pdf \
   thesis.tex abstract.tex acknowledgements.tex dedication.tex preface.tex \
   chapter1.tex chapter2.tex chapter3.tex appendixA.tex references.bib \
   thesis.pdf \
   urithesis/
# macOS Finder can create .DS_Store files, which CTAN does not accept.
find urithesis -name .DS_Store -delete
zip -r -q urithesis.zip urithesis -x '*.DS_Store'
rm -rf urithesis

echo "Created urithesis.zip"
