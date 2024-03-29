import os, strutils, tables

const Morse = {'A': ".-",     'B': "-...",   'C': "-.-.",    'D': "-..",    'E': ".",
               'F': "..-.",   'G': "--.",    'H': "....",    'I': "..",     'J': ".---",
               'K': "-.-",    'L': ".-..",   'M': "--",      'N': "-.",     'O': "---",
               'P': ".--.",   'Q': "--.-",   'R': ".-.",     'S': "...",    'T': "-",
               'U': "..-",    'V': "...-",   'W': ".--",     'X': "-..-",   'Y': "-.--",
               'Z': "--..",   '0': "-----",  '1': ".----",   '2': "..---",  '3': "...--",
               '4': "....-",  '5': ".....",  '6': "-....",   '7': "--...",  '8': "---..",
               '9': "----.",  '.': ".-.-.-", ',': "--..--",  '?': "..--..", '\'': ".----.",
               '!': "-.-.--", '/': "-..-.",  '(': "-.--.",   ')': "-.--.-", '&': ".-...",
               ':': "---...", ';': "-.-.-.", '=': "-...-",   '+': ".-.-.",  '-': "-....-",
               '_': "..--.-", '"': ".-..-.", '$': "...-..-", '@': ".--.-."}.toTable

proc morse(s: string): string =
  var r: seq[string]
  for c in s:
    r.add Morse.getOrDefault(c.toUpperAscii, "")
  result = r.join(" ")

var m: seq[string]
for arg in commandLineParams():
  m.add morse(arg)
echo m.join("   ")
