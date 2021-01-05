#!/bin/bash
# set -e をするとgrepのnotfoundで止まるよ
set -u

TOOL_DIR=$(cd $(dirname $0); pwd)
INDEX_DIR=${TOOL_DIR%%\/deletetool}

FILE_ARRAY=`find ${INDEX_DIR} -iname *.png  -type f`
FILE_ARRAY+=`find ${INDEX_DIR} -iname *.svg  -type f`
FILE_ARRAY+=`find ${INDEX_DIR} -iname *.adoc  -type f`

for FILE in ${FILE_ARRAY}
do
  NAME=`echo ${FILE} | awk -F / '{ print $NF }' `
  grep -r --include='*.adoc' ${NAME} ${INDEX_DIR}
  if [ $? = 1 ] && [[ ! ${NAME} =~ index.*.adoc ]] && [[ ! ${NAME} =~ title-.*.svg ]] && [[ ! ${NAME} =~ badge-.*.svg ]]
  then
    rm -f ${FILE}
  fi
done
