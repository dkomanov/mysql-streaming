package com.komanov.mysql.streaming.jmh

import java.util.concurrent.TimeUnit

import com.komanov.mysql.streaming._
import org.openjdk.jmh.annotations._

@State(Scope.Benchmark)
@BenchmarkMode(Array(Mode.AverageTime))
@OutputTimeUnit(TimeUnit.MICROSECONDS)
@Fork(value = 1, jvmArgs = Array("-Xmx1G"))
@Threads(1)
@Measurement(iterations = 5, time = 30, timeUnit = TimeUnit.SECONDS)
@Warmup(iterations = 2, time = 30, timeUnit = TimeUnit.SECONDS)
abstract class BenchmarkBase(driver: MysqlDriver) {

  MysqlRunner.run()

  @Benchmark
  def atOnce(): List[TestTableRow] = {
    Query.selectAtOnce(driver)
  }

  @Benchmark
  def stream(): List[TestTableRow] = {
    Query.selectViaStreaming(driver)
  }

}

class ConnectorJBenchmark extends BenchmarkBase(ConnectorJDriver)

class MariaDbBenchmark extends BenchmarkBase(MariaDbDriver)

class DrizzleBenchmark extends BenchmarkBase(DrizzleDriver)
