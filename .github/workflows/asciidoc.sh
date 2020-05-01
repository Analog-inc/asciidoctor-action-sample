#!/bin/bash
set -e

# make directory for Output Types
mkdir -p ./outputs/pdf
mkdir -p ./outputs/html
mkdir -p ./outputs/ebub

# Get file path
CURRENT_PATH=`pwd`
ASCIIDOCTOR_PDF_DIR=`gem contents asciidoctor-pdf --show-install-dir`


# asciidoctor command arguments
# -a, --attribute = ATTRIBUTE
# -B, --base-dir = DIR
# -D, --destination-dir = DIR
# -o, --out-file = OUT_FILE
# -R, --source-dir = DIR
# -b, --backend = BACKEND
# -d, --doctype = DOCTYPE
# -r, --require = LIBRARY

set -x

# Output HTML
asciidoctor -B ${CURRENT_PATH}/ -D ${CURRENT_PATH}/outputs/html/ -o index.html   -r asciidoctor-diagram index.adoc
# Output PDF
asciidoctor-pdf -B ${CURRENT_PATH}/ -D ${CURRENT_PATH}/outputs/pdf/ -o sample.pdf  -r asciidoctor-diagram -r ${CURRENT_PATH}/configs/config.rb -a pdf-styledir=${ASCIIDOCTOR_PDF_DIR}/data/themes -a pdf-fontsdir=${CURRENT_PATH}/fonts -a scripts@=cjk -a allow-uri-read index.adoc
# Output ePub
asciidoctor-epub3 -B ${CURRENT_PATH}/ -D ${CURRENT_PATH}/outputs/ebub/ -o sample.epub  -r asciidoctor-diagram index.adoc
