#!/usr/bin/env regina
/* Rexx */

-- . ... 1 ... ... 2 ... ... 3 ... ... 4 ... ... 5
-- Usage: >----+---------+--+--------+----<>
--             +- lines -+  +- cols -+
--             +- . -----+  +- cols -+
--  lines : screen lines
--  cols  : screen width
--  .     : use a '.' as a placehoder to skip 'lines'
-- . ... 1 ... ... 2 ... ... 3 ... ... 4 ... ... 5

  -- The screen size: lines and columns from user
  -- [on bash it's $LINES $COLUMNS]
  parse arg lines columns .

  if \datatype(lines, 'w') then
    lines = 34 -- not supplied, choose sensible defaults

  if \datatype(columns, 'w') then
    columns = 80 -- not supplied, choose sensible defaults

  -- calculate column width & height - include a margin
  column = (columns - (6 * 2 + 7)) % 8
  lines = lines - 10

  ESC   = '1b'x                     -- escape control char
  block = copies('e29688'x, column) -- U+2588 'FULL BLOCK'
                                    -- UTF-8 0xE2 0x96 0x88 (e29688)

  parse value 'black red green yellow blue magenta cyan white' ,
        with   black red green yellow blue magenta cyan white

  -- colour escape sequences
  col.        = ''
  col.black   = esc || '[2;30m'
  col.red     = esc || '[2;31m'
  col.green   = esc || '[2;32m'
  col.yellow  = esc || '[2;33m'
  col.blue    = esc || '[2;34m'
  col.magenta = esc || '[2;35m'
  col.cyan    = esc || '[2;36m'
  col.white   = esc || '[2;37m'
  -- colour reset sequence
  terminate   = esc || '[0m'

  say
  say copies(' ', 6),
      col.black   || right(black,   column) || terminate,
      col.red     || right(red,     column) || terminate,
      col.green   || right(green,   column) || terminate,
      col.yellow  || right(yellow,  column) || terminate,
      col.blue    || right(blue,    column) || terminate,
      col.magenta || right(magenta, column) || terminate,
      col.cyan    || right(cyan,    column) || terminate,
      col.white   || right(white,   column) || terminate

  do lines
    say copies(' ', 6),
        col.black   || block || terminate,
        col.red     || block || terminate,
        col.green   || block || terminate,
        col.yellow  || block || terminate,
        col.blue    || block || terminate,
        col.magenta || block || terminate,
        col.cyan    || block || terminate,
        col.white   || block || terminate
  end
  say

  return
