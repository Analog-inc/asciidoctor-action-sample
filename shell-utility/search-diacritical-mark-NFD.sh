#!/bin/bash
# set -e をするとgrepのnotfoundで止まるよ
set -u

TOOL_DIR=$(cd $(dirname $0); pwd)
INDEX_DIR=${TOOL_DIR%%\/shell-utility}

# 濁点「 ゙ 」を検索
LOG_ARRAY=`grep -rn '゙' ${INDEX_DIR}`
for LOG in ${LOG_ARRAY}
do
  # BusyBoxのgrepは--includeが使えないので後判断
  if [[ ${LOG} =~ .*.adoc.* ]]
  then
    echo "WARNING: Unicode normalization NFD! diacritical mark exists. 「 ゙ 」 ${LOG}"
  fi
done

# 半濁点「 ゚ 」を検索
LOG_ARRAY=`grep -rn '゚' ${INDEX_DIR}`

for LOG in ${LOG_ARRAY}
do
  # BusyBoxのgrepは--includeが使えないので後判断
  if [[ ${LOG} =~ .*.adoc.* ]]
  then
    echo "WARNING: Unicode normalization NFD! diacritical mark exists. 「 ゚ 」 ${LOG}"
  fi
done
