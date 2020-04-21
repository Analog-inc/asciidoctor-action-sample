#!/bin/bash
set -e

mkdir -p ./outputs/pdf
mkdir -p ./outputs/html
mkdir -p ./outputs/ebub


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

asciidoctor -B ${CURRENT_PATH}/ -D ${CURRENT_PATH}/outputs/html/ -o index.html  -a imagesdir=${CURRENT_PATH}/images  -r asciidoctor-diagram   index.adoc

asciidoctor-pdf -B ${CURRENT_PATH}/ -D ${CURRENT_PATH}/outputs/pdf/ -o sample.pdf -a imagesdir=${CURRENT_PATH}/images  -a scripts@=cjk    -a pdf-styledir=${ASCIIDOCTOR_PDF_DIR}/data/themes    -a allow-uri-read index.adoc

asciidoctor-epub3 -B ${CURRENT_PATH}/ -D ${CURRENT_PATH}/outputs/ebub/ -o sample.epub  -r asciidoctor-diagram -a imagesdir=${CURRENT_PATH}/images  index.adoc
