CLASS lcl_binom DEFINITION CREATE PUBLIC.

  PUBLIC SECTION.
    CLASS-METHODS:
      calc
        IMPORTING n               TYPE i
                  k               TYPE i
        RETURNING VALUE(r_result) TYPE f.

ENDCLASS.

CLASS lcl_binom IMPLEMENTATION.

  METHOD calc.

    r_result = 1.
    DATA(i) = 1.
    DATA(m) = n.

    WHILE i <= k.
      r_result = r_result * m / i.
      i = i + 1.
      m = m - 1.
    ENDWHILE.

  ENDMETHOD.

ENDCLASS.
