#!/bin/bash
set -u

TOOL_DIR=$(cd $(dirname $0); pwd)
INDEX_DIR=${TOOL_DIR%%\/shell-utility}
FILE_ARRAY=()

##############################
# 以下にに定義した値を 「literal-list.adoc」として出力します
##############################
FILE_ARRAY+=("${INDEX_DIR}/define-literal.adoc")

##############################
# 以下に出力します
##############################
CSV_FILE="${INDEX_DIR}/literal-list.adoc"

echo "" > "${CSV_FILE}"

for FILE in "${FILE_ARRAY[@]}"
do

  while read data value1 value2 value3
  do
    if  [[ ${data} =~ :name-.*:  ]] ||  [[ ${data} =~ :flow-.*:  ]] ||  [[ ${data} =~ :link-.*:  ]]
    then
      echo "| "${data//:/}" | "${value1}" "${value2}" "${value3} | sed 's/+/+\'$'\n/g' >> ${CSV_FILE}
    fi
    if  [[ ${data} =~ //.* ]] && [[ ! ${data} =~ ////.* ]]
    then
      echo "2+h| "${data//\/\//}" "${value1}" "${value2}" "${value3} >> ${CSV_FILE}
    fi
  done < ${FILE}

done
