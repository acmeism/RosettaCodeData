/* REXX */
infile ="in.txt"
outfile="out.txt"

s1=.copys~new(infile,outfile)
loop i=1 to 5
  s1~~input~~output
end
s1~close       -- close streams (files)
'type' outfile

::class copys
::attribute a
::attribute b
::attribute c
::attribute d

::method init     -- constructor
  expose instream outstream
  parse arg infile, outfile
  instream =.stream~new(infile)~~open
  outstream=.stream~new(outfile)~~open("replace")

::method input    -- read an input line
  expose instream a b c d
  parse value instream~linein with a +5 b +5 c +5 d +5

::method output   -- write an output line
  expose outstream a c
  outstream~lineout(a || c~c2x~left(2)'XXXXX')

::method close    -- close files
  expose instream outstream
  instream~close
  outstream~close
