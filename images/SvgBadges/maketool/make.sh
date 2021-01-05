#!/bin/bash
set -eu

TOOL_DIR=$(cd $(dirname $0); pwd)
ALL=`cat ${TOOL_DIR}/all.svg`
CHECK=`cat ${TOOL_DIR}/check.svg`
EYE=`cat ${TOOL_DIR}/eye.svg`
PEN=`cat ${TOOL_DIR}/pen.svg`
USER=`cat ${TOOL_DIR}/user.svg`
SMARTPHONE=`cat ${TOOL_DIR}/smartphone.svg`
FEATUREPHONE=`cat ${TOOL_DIR}/featurephone.svg`
BADGES_DIR=${TOOL_DIR/SvgBadges\/maketool/SvgBadges\/badges}

while IFS=, read data value
do
    eval $data=$value
done <  ${TOOL_DIR}/size.csv


while IFS=, read id code name num color
do

    TEMP=$ALL
    NUMLEN=`echo " scale=5; ${num} * ${STEPLEN} " | bc`
    FULLLENNUM=`echo " scale=5; ${NUMLEN} + ${FULLLEN} " | bc`
    ALENNUM=`echo " scale=5; ${NUMLEN} + ${ALEN} " | bc`
    BLENNUM=`echo " scale=5; ${NUMLEN} + ${BLEN} " | bc`
    CLENNUM=`echo " scale=5; ${NUMLEN} + ${CLEN} " | bc`
    DLENNUM=`echo " scale=5; ${NUMLEN} + ${DLEN} " | bc`

    TEMP=${TEMP//\{%cord%\}/${code}}
    TEMP=${TEMP//\{%name%\}/${name}}
    TEMP=${TEMP//\{%color%\}/${color}}
    TEMP=${TEMP//\{%full-length%\}/${FULLLENNUM}}
    TEMP=${TEMP//\{%a-length%\}/${ALENNUM}}
    TEMP=${TEMP//\{%b-length%\}/${BLENNUM}}
    TEMP=${TEMP//\{%c-length%\}/${CLENNUM}}
    TEMP=${TEMP//\{%d-length%\}/${DLENNUM}}

    echo ${TEMP} | sed -e "s|{%icon%}|$CHECK|g" > "${BADGES_DIR}/badge-user-${id}-check.svg"
    echo ${TEMP} | sed -e "s|{%icon%}|$EYE|g" > "${BADGES_DIR}/badge-user-${id}-eye.svg"
    echo ${TEMP} | sed -e "s|{%icon%}|$PEN|g" > "${BADGES_DIR}/badge-user-${id}-pen.svg"
    echo ${TEMP} | sed -e "s|{%icon%}|$USER|g" > "${BADGES_DIR}/badge-user-${id}-user.svg"
    echo ${TEMP} | sed -e "s|{%icon%}|$SMARTPHONE|g" > "${BADGES_DIR}/badge-user-${id}-smartphone.svg"
    echo ${TEMP} | sed -e "s|{%icon%}|$FEATUREPHONE|g" > "${BADGES_DIR}/badge-user-${id}-featurephone.svg"

done < ${TOOL_DIR}/data.csv
