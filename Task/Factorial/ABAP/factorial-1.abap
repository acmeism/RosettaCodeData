form factorial using iv_val type i.
  data: lv_res type i value 1.
  do iv_val times.
    multiply lv_res by sy-index.
  enddo.

  iv_val = lv_res.
endform.
