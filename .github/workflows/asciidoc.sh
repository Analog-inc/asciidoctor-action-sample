#!/bin/bash
set -eu

# make directory for Output Types
mkdir -p ./outputs/pdf
mkdir -p ./outputs/html

# Get file path
CURRENT_PATH=`pwd`
ASCIIDOCTOR_PDF_DIR=`gem contents asciidoctor-pdf --show-install-dir`

# 日本語環境を作成
export LANG=ja_JP.UTF-8
apk update
apk add --upgrade font-noto-cjk
apk add tzdata
cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime


echo ${GITHUB_EVENT_NAME}
echo ${GITHUB_REF}
echo ${GITHUB_BASE_REF}
echo ${GITHUB_HEAD_REF}

# asciidoctor command arguments
# -a, --attribute = ATTRIBUTE
# -B, --base-dir = DIR
# -D, --destination-dir = DIR
# -o, --out-file = OUT_FILE
# -R, --source-dir = DIR
# -b, --backend = BACKEND
# -d, --doctype = DOCTYPE
# -r, --require = LIBRARY

if ([[ ${GITHUB_EVENT_NAME} =~ .*pull_request.* ]] && [[ ${GITHUB_BASE_REF} =~ .*master ]]) || [[ ${GITHUB_REF} =~ .*/master ]]; then
  is_master=true
else
  is_master=false
fi

if ([[ ${GITHUB_EVENT_NAME} =~ .*pull_request.* ]] && [[ ${GITHUB_BASE_REF} =~ .*hotfix/.* ]]) || [[ ${GITHUB_REF} =~ .*/hotfix/.* ]]; then
  is_hotfix=true
else
  is_hotfix=false
fi

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

if [[ ${GITHUB_REF} =~ .*/target-readme/.* ]]; then
  if "${is_html}"; then
    is_r_h=true
  fi
  if  "${is_pdf}"; then
    is_r_p=true
  fi
else
  is_r_h=false
  is_r_p=false
fi

if [[ ${GITHUB_REF} =~ .*/target-sample/.* ]]; then
  if "${is_html}"; then
    is_s_h=true
  fi
  if  "${is_pdf}"; then
    is_s_p=true
  fi
else
  is_s_h=false
  is_s_p=false
fi

# hotfix用の出力設定
if "${is_hotfix}"; then
  # hotfixは最低限のみ
  is_r_h=false
  is_r_p=true
  is_s_h=true
  is_s_p=false
fi

# master用の出力設定
if "${is_master}"; then
  # masterは全ての権限
  is_r_h=true
  is_r_p=true
  is_s_h=true
  is_s_p=true
fi

# バッジを最新化
bash ${CURRENT_PATH}/images/SvgBadges/maketool/make.sh
# バージョンをindexに揃える
bash ${CURRENT_PATH}/images/title/maketool/revnumber.sh
# Unicode正規化がNFDで行われ、濁点・半濁点が親となる文字と分離した場合にwarningを出力
bash ${CURRENT_PATH}/shell-utility/search-diacritical-mark-NFD.sh
# 定義済の単語をガイドラインに自動出力
bash ${CURRENT_PATH}/shell-utility/make-define2literalList.sh

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


COMMON_PARAMETERS=" -B ${CURRENT_PATH}/ -a target-release -r asciidoctor-diagram -v --failure-level=ERROR --trace -r ${CURRENT_PATH}/lib/common-extensions.rb "
HTML_PARAMETERS=" -D ${CURRENT_PATH}/outputs/html/ -a docinfodir=${CURRENT_PATH}/docinfo ${DATA_URI} -a nofooter "
DEPLOY_INDEX_PARAMETERS=" -D ${CURRENT_PATH}/outputs/ -a docinfodir=${CURRENT_PATH}/docinfo ${DATA_URI} -a nofooter "
PDF_PARAMETERS=" -D ${CURRENT_PATH}/outputs/pdf/ -a chapter-label= -r ${CURRENT_PATH}/diagram-configs/config.rb -a pdf-styledir=${CURRENT_PATH}/themes -a pdf-fontsdir=${CURRENT_PATH}/fonts -a scripts=cjk -a allow-uri-read "
PREVIEW_TARGET_ATTRIBUTES=""

set -x

# Output HTML
if "${is_h_h}"; then
  asciidoctor ${COMMON_PARAMETERS} ${HTML_PARAMETERS} -o "index.html" -a target-sample index.adoc
  PREVIEW_TARGET_ATTRIBUTES+=" -a is_s_h"
fi
if "${is_g_h}"; then
  asciidoctor ${COMMON_PARAMETERS} ${HTML_PARAMETERS} -o "README.html" -a target-readme README.adoc
  PREVIEW_TARGET_ATTRIBUTES+=" -a is_r_h"
fi


# Output PDF
if "${is_h_p}"; then
  asciidoctor-pdf ${COMMON_PARAMETERS} ${PDF_PARAMETERS} -o "sample.pdf" -a target-sample -a pdf-style=${CURRENT_PATH}/themes/user-sample-theme.yml index.adoc
  PREVIEW_TARGET_ATTRIBUTES+=" -a is_s_p"
fi
if "${is_g_p}"; then
  asciidoctor-pdf ${COMMON_PARAMETERS} ${PDF_PARAMETERS} -o "README.pdf" -a target-readme -a pdf-style=${CURRENT_PATH}/themes/user-analog-theme.yml README.adoc
  PREVIEW_TARGET_ATTRIBUTES+=" -a is_r_p"
fi

if "${is_web}"; then
  asciidoctor ${COMMON_PARAMETERS} ${DEPLOY_INDEX_PARAMETERS} -o "index.html" ${PREVIEW_TARGET_ATTRIBUTES} index-preview.adoc
fi
