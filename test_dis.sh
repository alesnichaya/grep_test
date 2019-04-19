!/bin/bash

set -e

for PATH_NAME in $(find . -type d -name test); do
  for LOC in $(grep -lir '@Test' ${PATH_NAME}); do
    for TEST_NAME in $LOC; do
      if [[ $TEST_NAME = \./sql*  ]]; then
        continue
      fi

      for  TEST_PATH_LOCAL in $TEST_NAME; do
        PROJECT_NAME=$(echo $TEST_PATH_LOCAL | awk -F "/src" '{ print $1 }' | awk -F "/" '{ print $NF }')
        CLASS_NAME=$(echo $TEST_PATH_LOCAL | sed -re 's/^(.)*java\/(.+).java$/\2/' | tr '/' '.')
        echo ./build/mvn -Dtest=${CLASS_NAME} test -pl ${PROJECT_NAME}
      done
    done
  done
done
