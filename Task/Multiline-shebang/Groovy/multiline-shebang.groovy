#!/bin/bash
script_dir="$(cd $(dirname $0) >/dev/null; pwd -P)"

if [ -z "${GROOVY_HOME}" ]
then
  echo 'GROOVY_HOME must be defined.' >&2
  exit 1
fi

CLASSPATH="${script_dir}" "${GROOVY_HOME}/bin/groovy" -e "$(sed -e '1,/^!#$/d' $0)" "${@:1}"
exit
!#
println 'aoeu'
