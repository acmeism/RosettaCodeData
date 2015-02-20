/* Rexx */

i_ = 0
i_ = i_ + 1; lists.0 = i_; lists.i_ = '[]'
i_ = i_ + 1; lists.0 = i_; lists.i_ = '["ABC"]'
i_ = i_ + 1; lists.0 = i_; lists.i_ = '["ABC", ''DEF'']'
i_ = i_ + 1; lists.0 = i_; lists.i_ = '[ABC, DEF, G, H]'

say
do i_ = 1 to lists.0
  list = lists.i_
  say right(list, 30) ':' quibbling03(list)
  end i_
exit

quibbling03:
procedure
  parse arg '[' lst ']'
  lst = changestr('"', changestr("'", lst, ''), '') -- remove double & single quotes
  lc = lastpos(',', lst)
  if lc > 0 then
    lst = overlay(' ', insert('and', lst, lc), lc)
  lst = space(lst, 1) -- remove extra spaces
  return '{'lst'}'
