#!/usr/bin/env golosh
----
An accumulator factory example for Rosetta Code.
This one uses the box function to create an AtomicReference.
----
module rosetta.AccumulatorFactory

function accumulator = |n| {
  let number = box(n)
  return |i| -> number: accumulateAndGet(i, |a, b| -> a + b)
}

function main = |args| {
  let acc = accumulator(3)
  println(acc(1))
  println(acc(1.1))
  println(acc(10))
  println(acc(100.101))
}
