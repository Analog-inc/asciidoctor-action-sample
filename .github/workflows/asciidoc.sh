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
echo ${GITHUB_BASE_REF}

# asciidoctor command arguments
# -a, --attribute = ATTRIBUTE
# -B, --base-dir = DIR
# -D, --destination-dir = DIR
# -o, --out-file = OUT_FILE
# -R, --source-dir = DIR
# -b, --backend = BACKEND
# -d, --doctype = DOCTYPE
# -r, --require = LIBRARY

if [[ ${GITHUB_REF} =~ .*/html/.* ]]; then
  is_html=true
else
  is_html=false
fi

if [[ ${GITHUB_REF} =~ .*/pdf/.* ]]; then
  is_pdf=true
else
  is_pdf=false
fi

if [[ ${GITHUB_REF} =~ .*/web/.* ]]; then
  is_web=true
else
  is_web=false
fi

if [[ ${GITHUB_REF} =~ .*/master ]]; then
  is_master=true
  is_web=true
else
  is_master=false
fi

if [[ ${GITHUB_EVENT_NAME} =~ .*pull_request.* ]]; then
  if [[ ${GITHUB_BASE_REF} =~ .*master ]]; then
    is_master=true
    is_web=true
  fi
fi

# バッジを最新化
bash ${CURRENT_PATH}/images/SvgBadges/maketool/make.sh
# バージョンをindexに揃える
bash ${CURRENT_PATH}/images/title/maketool/revnumber.sh

DATA_URI=""

if "${is_web}"; then
  mkdir -p ./outputs/html/images/pages/
  mkdir -p ./outputs/html/images/SvgBadges
  cp -rf ${CURRENT_PATH}/images/SvgBadges/badges ./outputs/html/images/SvgBadges
  cp -rf ${CURRENT_PATH}/images/video ./outputs/html/images
  cp -rf ${CURRENT_PATH}/js ./outputs/html
  cp -rf ${CURRENT_PATH}/css ./outputs/html
  cp -rf ${CURRENT_PATH}/js ./outputs
  cp -rf ${CURRENT_PATH}/css ./outputs
  # 不要ファイルを削除
  find ./outputs/html/images -name "*.adoc" -exec rm -rf {} \;
  DATA_URI="-a allow-uri-read "
else
  mkdir -p ./outputs/html/images
  cp -rf ${CURRENT_PATH}/images/video ./outputs/html/images
  cp -rf ${CURRENT_PATH}/js ./outputs/html
  cp -rf ${CURRENT_PATH}/css ./outputs/html
  DATA_URI="-a data-uri -a allow-uri-read "
fi


COMMON_PARAMETERS=" -B ${CURRENT_PATH}/ -a target-release -r asciidoctor-diagram -v --failure-level=ERROR "
HTML_PARAMETERS=" -D ${CURRENT_PATH}/outputs/html/ -a docinfodir=${CURRENT_PATH}/docinfo -a toc-title=目次 ${DATA_URI} -a nofooter "
DEPLOY_INDEX_PARAMETERS=" -D ${CURRENT_PATH}/outputs/ -a docinfodir=${CURRENT_PATH}/docinfo -a toc-title=目次 ${DATA_URI} -a nofooter "
PDF_PARAMETERS=" -D ${CURRENT_PATH}/outputs/pdf/ -a chapter-label= -r ${CURRENT_PATH}/diagram-configs/config.rb -a pdf-styledir=${CURRENT_PATH}/themes -a pdf-fontsdir=${CURRENT_PATH}/fonts -a scripts=cjk -a allow-uri-read "

set -x


# Output HTML
if "${is_html}" || "${is_master}"; then
  asciidoctor ${COMMON_PARAMETERS}  ${HTML_PARAMETERS} -o "index.html"  -a target-sample  index.adoc
fi
asciidoctor ${COMMON_PARAMETERS}  ${HTML_PARAMETERS} -o "README.html" README.adoc


# Output PDF
if "${is_pdf}" || "${is_master}"; then
  asciidoctor-pdf ${COMMON_PARAMETERS}  ${PDF_PARAMETERS} -o "sample.pdf"   -a target-sample   -a pdf-style=${CURRENT_PATH}/themes/user-sample-theme.yml   index.adoc
fi
asciidoctor-pdf ${COMMON_PARAMETERS}  ${PDF_PARAMETERS} -o "README.pdf"   -a pdf-style=${CURRENT_PATH}/themes/user-sample-analog.yml README.adoc

if "${is_web}"; then
  asciidoctor ${COMMON_PARAMETERS} ${DEPLOY_INDEX_PARAMETERS} -o "index.html" -a target-helpdesk index-preview.adoc
fi
