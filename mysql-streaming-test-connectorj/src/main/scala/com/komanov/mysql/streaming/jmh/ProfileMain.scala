package com.komanov.mysql.streaming.jmh

import org.openjdk.jmh.profile.StackProfiler
import org.openjdk.jmh.runner.Runner
import org.openjdk.jmh.runner.options.OptionsBuilder

object ProfileMain {

  def main(args: Array[String]): Unit = {
    // same as: -prof stack -jvmArgsAppend '-Djmh.stack.lines=10'
    val opt = new OptionsBuilder()
      .addProfiler(classOf[StackProfiler])
      .jvmArgsAppend("-Djmh.stack.lines=10")
      .build()

    new Runner(opt).run()
  }

}
