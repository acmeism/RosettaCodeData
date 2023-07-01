from math import sqrt
import times

import bignum

#---------------------------------------------------------------------------------------------------

func sqrt(value, guess: Int): Int =
  result = guess
  while true:
    let term = value div result
    if abs(term - result) <= 1:
      break
    result = (result + term) shr 1

#---------------------------------------------------------------------------------------------------

func isr(term, guess: Int): Int =
  var term = term
  result = guess
  let value = term * result
  while true:
    if abs(term - result) <= 1:
      break
    result = (result + term) shr 1
    term = value div result

#---------------------------------------------------------------------------------------------------

func calcAGM(lam, gm: Int; z: var Int; ep: Int): Int =
  var am: Int
  var lam = lam
  var gm = gm
  var n = 1
  while true:
    am = (lam + gm) shr 1
    gm = isr(lam, gm)
    let v = am - lam
    let zi = v * v * n
    if zi < ep:
      break
    dec z, zi
    inc n, n
    lam = am
  result = am

#---------------------------------------------------------------------------------------------------

func bip(exp: int; man = 1): Int {.inline.} = man * pow(10, culong(exp))

#---------------------------------------------------------------------------------------------------

func compress(str: string; size: int): string =
  if str.len <= 2 * size: str
  else: str[0..<size] & "..." & str[^size..^1]

#———————————————————————————————————————————————————————————————————————————————————————————————————

import os
import parseutils
import strutils

const DefaultDigits = 25_000

var d = DefaultDigits
if paramCount() > 0:
  if paramStr(1).parseInt(d) > 0:
    if d notin 1..999_999:
      d = DefaultDigits

let t0 = getTime()

let am = bip(d)
let gm = sqrt(bip(d + d - 1, 5), bip(d - 15, int(sqrt(0.5) * 1e15)))
var z = bip(d + d - 2, 25)
let agm = calcAGM(am, gm, z, bip(d + 1))
let pi = agm * agm * bip(d - 2) div z

var piStr = $pi
piStr.insert(".", 1)

let dt = (getTime() - t0).inMicroseconds.float
let timestr = if dt > 1_000_000:
                (dt / 1e6).formatFloat(ffDecimal, 2) & " s"
              elif dt > 1000:
                $(dt / 1e3).toInt & " ms"
              else:
                $dt.toInt & " µs"
echo "Computed ", d, " digits in ", timeStr

echo "π = ", compress(piStr, 20), "..."
