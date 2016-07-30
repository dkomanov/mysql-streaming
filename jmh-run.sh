#!/bin/sh -e

ec() {
    echo $* 1>&2
    $*
}

# expecting a gh-pages symlink in a root directory
GH_PAGES_PATH=`readlink gh-pages`
# ensure that git repository exists there
ec git -C $GH_PAGES_PATH status > /dev/null

ec mvn clean install

ec java -jar mysql-streaming-test-connectorj/target/benchmarks.jar -rf json -rff jmh-connectorj-result.json > jmh-connectorj.log
ec java -jar mysql-streaming-test-mariadb/target/benchmarks.jar -rf json -rff jmh-mariadb-result.json > jmh-mariadb.log

echo '[' > jmh-results.json
cat jmh-connectorj-result.json >> jmh-results.json
echo ',' >> jmh-results.json
cat jmh-mariadb-result.json >> jmh-results.json
echo ']' >> jmh-results.json

ec mv jmh-results.json $GH_PAGES_PATH

echo "Don't forget to push gh-pages!"
