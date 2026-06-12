showlanterns=: {{
  arrange=. ($ $ (* +/\)@,) y $&>1
  echo 'lantern ids:'
  echo rplc&(' 0';'  ')"1 ' ',.":|:arrange
  echo ''
  cols=. <@-.&0"1 arrange
  recur=: <@{{
    todo=. (#~ ~:&a:) y -.L:0 x
    if. #todo do.
      next=. {:@> todo
      ,x <@,S:0 every next recur todo
    else.
      <x
    end.
  }}"0 1
  echo 'all lantern removal sequences:'
  echo >a:-.~ -.&0 each;0 recur cols
}}
