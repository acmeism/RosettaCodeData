#!/usr/bin/env golosh
----
This module is the Bulls and Cows game.
----
module Bullsandcows

import gololang.Decorators
import gololang.Functions
import gololang.IO
import java.util

function main = |args| {
  while true {
    let secret = create4RandomNumbers()
    println("Welcome to Bulls And Cows")
    while true {
      println("Please enter a 4 digit number")
      println("(with only the digits 1 to 9 and no repeated digits, for example 2537)")
      let guess = readln("guess: ")
      let result = validateGuess(guess)
      if result: isValid() {
        let bulls, cows = bullsAndOrCows(result: digits(), secret)
        if bulls is 4 {
          println("You win!")
          break
        }
        println("bulls: " + bulls)
        println("cows:  " + cows)
      } else {
        println(result: message())
      }
    }
  }
}

function create4RandomNumbers = {
  let numbers = vector[1, 2, 3, 4, 5, 6, 7, 8, 9]
  Collections.shuffle(numbers)
  let shuffled = numbers: subList(0, 4)
  return shuffled
}

union Result = {
  Valid = { digits }
  Invalid = { message }
}

@checkArguments(isString())
function validateGuess = |guess| {
  var digits = []
  try {
    let number = guess: toInt()
    digits = number: digits()
    if digits: exists(|d| -> d is 0) {
      return Result.Invalid("No zeroes please")
    }
    if digits: size() isnt 4  {
      return Result.Invalid("Four digits please")
    }
    let digitSet = set[ digit foreach digit in digits ]
    if digitSet: size() < digits: size() {
      return Result.Invalid("No duplicate numbers please")
    }
  } catch(e) {
    return Result.Invalid("Numbers only please")
  }
  return Result.Valid(digits)
}

let is4Vector = |arg| -> arg oftype java.util.List.class and arg: size() is 4

@checkArguments(is4Vector, is4Vector)
function bullsAndOrCows = |guess, secret| {
  var bulls = 0
  var cows = 0
  foreach i in [0..4] {
    let guessNum = guess: get(i)
    let secretNum = secret: get(i)
    if guessNum is secretNum {
      bulls = bulls + 1
    } else if secret: exists(|num| -> guessNum is num) {
      cows = cows + 1
    }
  }
  return [bulls, cows]
}

augment java.lang.Integer {

  function digits = |this| {
    var remaining = this
    let digits = vector[]
    while remaining > 0 {
      digits: prepend(remaining % 10)
      remaining = remaining / 10
    }
    return digits
  }
}
