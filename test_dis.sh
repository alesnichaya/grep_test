!/bin/bash

set -e

for PATH_NAME in $(find . -type d -name test);
do
        for LOC in $(grep -lir '@Test' ${PATH_NAME}); do
                if [ -n "$LOC" ]; then
                echo $LOC;
                else
                echo '';
                fi

        done

done > all_test.txt

for TEST_NAME in $(cat all_test.txt);
do
        if [[ $TEST_NAME = \./sql*  ]]; then
        export A=4;
        else
        echo $TEST_NAME;
        fi
done > temp.txt

for TEST_PATH_LOCAL in $(cat temp.txt);
        do
        get_project_name() {
             local TEST_PATH=$1
             echo $TEST_PATH | awk -F "/src" '{ print $1 }' | awk -F "/" '{ print $NF }'
        }

        get_class_name() {
             local TEST_PATH=$1
             echo $TEST_PATH | sed -re 's/^(.)*java\/(.+).java$/\2/' | tr '/' '.'
        }

        for TEST_PATH in $TEST_PATH_LOCAL; do
                PROJECT_NAME=$(get_project_name ${TEST_PATH})
                CLASS_NAME=$(get_class_name ${TEST_PATH})
                echo ./build/mvn -Dtest=${CLASS_NAME} test -pl ${PROJECT_NAME}
        done
done > test.sh
