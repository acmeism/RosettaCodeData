DATA(result) = COND #( WHEN condition1istrue = abap_true AND condition2istrue = abap_true THEN bothconditionsaretrue
                          WHEN condition1istrue = abap_true THEN firstconditionistrue
                          WHEN condition2istrue = abap_true THEN secondconditionistrue
                          ELSE noconditionistrue ).
