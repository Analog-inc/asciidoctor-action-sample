#!/bin/bash
set -eu

TOOL_DIR=$(cd $(dirname $0); pwd)
TITLE_DIR=${TOOL_DIR%%\/maketool}
INDEX_DIR=${TOOL_DIR%%\/images\/title\/maketool}
REVISION_NUMBER=`cat ${INDEX_DIR}/index.adoc | grep revnumber | awk '{print $2}'`

TITLE_ALL=`cat ${TITLE_DIR}/title-all.svg`
echo ${TITLE_ALL} | sed -e "s|{%revnumber%}|$REVISION_NUMBER|g" > "${TITLE_DIR}/title-all.svg"

TITLE_BACKGROUND=`cat ${TITLE_DIR}/title-background.svg`
echo ${TITLE_BACKGROUND} | sed -e "s|{%revnumber%}|$REVISION_NUMBER|g" > "${TITLE_DIR}/title-background.svg"
