#!/bin/bash
set -eu

TOOL_DIR=$(cd $(dirname $0); pwd)
TITLE_DIR=${TOOL_DIR%%\/maketool}
INDEX_DIR=${TOOL_DIR%%\/images\/title\/maketool}

REVISION_NUMBER=`cat ${INDEX_DIR}/index.adoc | grep revnumber | awk '{print $2}'`
TITLE_BACKGROUND=`cat ${TITLE_DIR}/title-background.svg`
echo ${TITLE_BACKGROUND} | sed -e "s|{%revnumber%}|$REVISION_NUMBER|g" > "${TITLE_DIR}/title-background.svg"

REVISION_DATE=`cat ${INDEX_DIR}/README.adoc | grep revdate | awk -F '[ -]'  '{print $2"/"$3"/"$4}'`
TITLE_BACKGROUND=`cat ${TITLE_DIR}/title-background-readme.svg`
echo ${TITLE_BACKGROUND} | sed -e "s|{%revdate%}|$REVISION_DATE|g" > "${TITLE_DIR}/title-background-readme.svg"
