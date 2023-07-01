form open_doors_opt.
  data: lv_square type i value 1,
        lv_inc    type i value 3.
  data: lt_doors  type standard table of c initial size 100.
  field-symbols: <wa_door> type c.
  do 100 times.
    append initial line to lt_doors assigning <wa_door>.
    if sy-index = lv_square.
      <wa_door> = 'X'.
      add: lv_inc to lv_square, 2 to lv_inc.
      write : / 'Door', (4) sy-index right-justified, 'is open' no-gap.
    endif.
  enddo.
endform.
