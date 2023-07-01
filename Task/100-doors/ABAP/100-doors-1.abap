form open_doors_unopt.
  data: lv_door  type i,
        lv_count type i value 1.
  data: lt_doors type standard table of c initial size 100.
  field-symbols: <wa_door> type c.
  do 100 times.
    append initial line to lt_doors assigning <wa_door>.
    <wa_door> = 'X'.
  enddo.

  while lv_count < 100.
    lv_count = lv_count + 1.
    lv_door = lv_count.
    while lv_door < 100.
      read table lt_doors index lv_door assigning <wa_door>.
      if <wa_door> = ' '.
        <wa_door> = 'X'.
      else.
        <wa_door> = ' '.
      endif.
      add lv_count to lv_door.
    endwhile.
  endwhile.

  loop at lt_doors assigning <wa_door>.
    if <wa_door> = 'X'.
      write : / 'Door', (4) sy-tabix right-justified, 'is open' no-gap.
    endif.
  endloop.
endform.
