⍝⍝ GNU APL Version
∇listFile fname ;fileHandle;maxLineLen;line
  maxLineLen ← 128
  fileHandle ← ⎕FIO['fopen'] fname
readLoop:
  →(0=⍴(line ← maxLineLen ⎕FIO['fgets'] fileHandle))/eof
  ⍞ ← ⎕AV[1+line]  ⍝⍝ bytes to ASCII
  → readLoop
eof:
  ⊣⎕FIO['fclose'] fileHandle
  ⊣⎕FIO['errno'] fileHandle
∇

      listFile 'corpus/sample1.txt'
This is some sample text.
The text itself has multiple lines, and
the text has some words that occur multiple times
in the text.

This is the end of the text.
