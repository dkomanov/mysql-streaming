#!/bin/sh -e

ec() {
    echo $* 1>&2
    $*
}

ec mvn -f mysql-streaming-core/pom.xml dependency:build-classpath -Dmdep.outputFile=`pwd`/cp.txt

# https://docs.oracle.com/javase/tutorial/essential/environment/paths.html
export CLASSPATH=`cat cp.txt`:mysql-streaming-core/target/classes

echo CLASSPATH
echo $CLASSPATH

# tests
ec java -Xms16m com.komanov.mysql.streaming.tests.MemoryConsumptionApp ConnectorJ streaming success
ec java -Xms16m com.komanov.mysql.streaming.tests.MemoryConsumptionApp MariaDB streaming success
ec java -Xms16m com.komanov.mysql.streaming.tests.MemoryConsumptionApp Drizzle streaming oom
ec java -Xms16m com.komanov.mysql.streaming.tests.MemoryConsumptionApp ConnectorJ at-once oom
ec java -Xms16m com.komanov.mysql.streaming.tests.MemoryConsumptionApp MariaDB at-once oom
ec java -Xms16m com.komanov.mysql.streaming.tests.MemoryConsumptionApp Drizzle at-once oom
