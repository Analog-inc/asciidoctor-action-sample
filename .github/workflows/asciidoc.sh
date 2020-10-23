#!/bin/bash
set -e

# make directory for Output Types
mkdir -p ./outputs/pdf
mkdir -p ./outputs/html

# Get file path
CURRENT_PATH=`pwd`
ASCIIDOCTOR_PDF_DIR=`gem contents asciidoctor-pdf --show-install-dir`


echo ${GITHUB_EVENT_NAME}
echo ${GITHUB_REF}

# asciidoctor command arguments
# -a, --attribute = ATTRIBUTE
# -B, --base-dir = DIR
# -D, --destination-dir = DIR
# -o, --out-file = OUT_FILE
# -R, --source-dir = DIR
# -b, --backend = BACKEND
# -d, --doctype = DOCTYPE
# -r, --require = LIBRARY

if [[ ${GITHUB_EVENT_NAME} =~ .*release.* ]]; then
  is_release=true
else
  is_release=false
fi

DATA_URI=""

if "${is_release}"; then
  cp --parents -rf  ${CURRENT_PATH}/images ./outputs/html
  cp -rf  ${CURRENT_PATH}/azureFunctions/routes.json ./outputs/html
  cp --parents -rf  ${CURRENT_PATH}/azureFunctions/api ./outputs/html
else
  mkdir -p ./outputs/html/images
  cp -rf ${CURRENT_PATH}/images/video ./outputs/html/images
  DATA_URI="-a data-uri"
fi

COMMON_PARAMETERS=" -B ${CURRENT_PATH}/  -a target-release  -r asciidoctor-diagram -v "
HTML_PARAMETERS=" -D ${CURRENT_PATH}/outputs/html/ -a docinfodir=${CURRENT_PATH}/docinfo -a toc-title=目次 ${DATA_URI}"
PDF_PARAMETERS="  -D ${CURRENT_PATH}/outputs/pdf/  -a chapter-label=  -r ${CURRENT_PATH}/configs/config.rb -a pdf-styledir=${CURRENT_PATH}/themes -a pdf-fontsdir=${CURRENT_PATH}/fonts -a scripts=cjk -a allow-uri-read "

set -x


# Output HTML
asciidoctor ${COMMON_PARAMETERS}  ${HTML_PARAMETERS} -o "index.html"  -a target-sample  index.adoc
asciidoctor ${COMMON_PARAMETERS}  ${HTML_PARAMETERS} -o "README.html" README.adoc
# Output PDF
asciidoctor-pdf ${COMMON_PARAMETERS}  ${PDF_PARAMETERS} -o "サンプル.pdf"   -a target-sample   -a pdf-style=${CURRENT_PATH}/themes/user-sample-theme.yml   index.adoc
asciidoctor-pdf ${COMMON_PARAMETERS}  ${PDF_PARAMETERS} -o "README.pdf"   -a pdf-style=${CURRENT_PATH}/themes/common-theme.yml README.adoc
