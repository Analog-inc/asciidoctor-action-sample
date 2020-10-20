#!/bin/bash

ALL=`cat ./all.svg`
CHECK=`cat ./check.svg`
EYE=`cat ./eye.svg`
PEN=`cat ./pen.svg`
USER=`cat ./user.svg`
SMARTPHONE=`cat ./smartphone.svg`
FEATUREPHONE=`cat ./featurephone.svg`


while IFS=, read data value
do
    eval $data=$value
done <  ./size.csv
    
    
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

    echo ${TEMP} | sed -e "s|{%icon%}|$CHECK|g" > "badge-user-${id}-check.svg"
    echo ${TEMP} | sed -e "s|{%icon%}|$EYE|g" > "badge-user-${id}-eye.svg"
    echo ${TEMP} | sed -e "s|{%icon%}|$PEN|g" > "badge-user-${id}-pen.svg"
    echo ${TEMP} | sed -e "s|{%icon%}|$USER|g" > "badge-user-${id}-user.svg"
    echo ${TEMP} | sed -e "s|{%icon%}|$SMARTPHONE|g" > "badge-user-${id}-smartphone.svg"
    echo ${TEMP} | sed -e "s|{%icon%}|$FEATUREPHONE|g" > "badge-user-${id}-featurephone.svg"
    
done < ./data.csv
