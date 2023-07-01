FORM fibonacci_iter USING index TYPE i
                    CHANGING number_fib TYPE i.
  DATA: lv_old type i,
        lv_cur type i.
  Do index times.
    If sy-index = 1 or sy-index = 2.
      lv_cur = 1.
      lv_old = 0.
    endif.
    number_fib = lv_cur + lv_old.
    lv_old = lv_cur.
    lv_cur = number_fib.
  enddo.
ENDFORM.
