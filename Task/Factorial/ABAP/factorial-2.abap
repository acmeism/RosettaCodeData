form fac_rec using iv_val type i.
  data: lv_temp type i.

  if iv_val = 0.
    iv_val = 1.
  else.
    lv_temp = iv_val - 1.
    perform fac_rec using lv_temp.
    multiply iv_val by lv_temp.
  endif.
endform.
