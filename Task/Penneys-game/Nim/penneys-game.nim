import os, random, sequtils, strutils

randomize()

let first = sample([false, true])

var you, me = ""
if first:
  me = newSeqWith(3, sample("HT")).join()
  echo "I choose first and will win on first seeing $# in the list of tosses." % me
  while you.len != 3 or not allCharsInSet(you, {'H', 'T'}) or you == me:
    stdout.write "What sequence of three Heads/Tails will you win with? "
    you = stdin.readLine()
else:
  while you.len != 3 or not allCharsInSet(you, {'H', 'T'}):
    echo "After you: what sequence of three Heads/Tails will you win with? "
    you = stdin.readLine()
  me = (if you[1] == 'T': 'H' else: 'T') & you[0..1]
  echo "I win on first seeing $# in the list of tosses" % me

var rolled = ""
stdout.write "Rolling:\n  "
while true:
  rolled.add sample("HT")
  stdout.write rolled[^1]
  stdout.flushFile()
  if rolled.endsWith(you):
    echo "\n  You win!"
    break
  elif rolled.endsWith(me):
    echo "\n  I win!"
    break
  sleep(1000)
