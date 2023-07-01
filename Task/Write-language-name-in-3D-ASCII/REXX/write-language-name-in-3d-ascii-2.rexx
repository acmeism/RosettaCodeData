/* Rexx */

drop !top !bot
x = 0
x = x + 1; txt.0 = x; txt.x = '   *****'
x = x + 1; txt.0 = x; txt.x = '   *    *'
x = x + 1; txt.0 = x; txt.x = '   *    * ***** *   * *   *'
x = x + 1; txt.0 = x; txt.x = '   *****  *      * *   * *'
x = x + 1; txt.0 = x; txt.x = '   *  *   ***     *     *'
x = x + 1; txt.0 = x; txt.x = '   *   *  *      * *   * *'
x = x + 1; txt.0 = x; txt.x = '   *    * ***** *   * *   *'
x = x + 1; txt.0 = x; txt.x = ''

call Banner3D isTrue()
do ll = 1 to txt.0
  say txt.ll.!top
  say txt.ll.!bot
  end ll

return
exit

Banner3D:
procedure expose txt.
  drop !top !bot
  parse arg slope .

  select
    when slope = isTrue() then nop
    when slope = isFalse() then nop
    otherwise do
      if slope = '' then slope = isFalse()
                    else slope = isTrue()
      end
    end

  do ll = 1 to txt.0
    txt.ll.!top = txt.ll
    txt.ll.!bot = txt.ll
    txt.ll.!top = changestr(' ', txt.ll.!top, '   ')
    txt.ll.!bot = changestr(' ', txt.ll.!bot, '   ')
    txt.ll.!top = changestr('*', txt.ll.!top, '///')
    txt.ll.!bot = changestr('*', txt.ll.!bot, '\\\')
    txt.ll.!top = txt.ll.!top || ' '
    txt.ll.!bot = txt.ll.!bot || ' '
    txt.ll.!top = changestr('/ ', txt.ll.!top, '/\')
    txt.ll.!bot = changestr('\ ', txt.ll.!bot, '\/')
    end ll

  if slope then do
    do li = txt.0 to 1 by -1
      ll = txt.0 - li + 1
      txt.ll.!top = insert('', txt.ll.!top, 1, li - 1, ' ')
      txt.ll.!bot = insert('', txt.ll.!bot, 1, li - 1, ' ')
      end li
    end

  return
exit

isTrue:
procedure
  return 1 == 1

isFalse:
procedure
  return \isTrue()
