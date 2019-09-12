#!/usr/bin/env golosh
----
This module demonstrates variadic functions.
----
module Variadic

import gololang.Functions

----
Varargs have the three dots after them just like Java.
----
function varargsFunc = |args...| {
  foreach arg in args {
    println(arg)
  }
}

function main = |args| {

  varargsFunc(1, 2, 3, 4, 5, "against", "one")

  # to call a variadic function with an array we use the unary function
  unary(^varargsFunc)(args)
}
