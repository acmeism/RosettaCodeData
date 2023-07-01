REPORT zspiral_matrix.

CLASS lcl_spiral_matrix DEFINITION FINAL.
  PUBLIC SECTION.

    TYPES:
      BEGIN OF ty_coordinates,
        dy    TYPE i,
        dx    TYPE i,
        value TYPE i,
      END OF ty_coordinates,
      ty_t_coordinates TYPE STANDARD TABLE OF ty_coordinates WITH EMPTY KEY.

    DATA mv_dimention TYPE i.
    DATA mv_initial_value TYPE i.

    METHODS:
      constructor IMPORTING iv_dimention     TYPE i
                            iv_initial_value TYPE i,

      get_coordinates RETURNING VALUE(rv_result) TYPE ty_t_coordinates,

      print.

  PRIVATE SECTION.
    DATA lt_coordinates TYPE ty_t_coordinates.

    METHODS create RETURNING VALUE(ro_result) TYPE REF TO lcl_spiral_matrix.

ENDCLASS.

CLASS lcl_spiral_matrix IMPLEMENTATION.
  METHOD constructor.

    mv_dimention = iv_dimention.
    mv_initial_value = iv_initial_value.

    create( ).

  ENDMETHOD.

  METHOD create.

    DATA dy TYPE i.
    DATA dx TYPE i.
    DATA value TYPE i.
    DATA seq_number TYPE i.
    DATA seq_dimention TYPE i.
    DATA sign_coef TYPE i VALUE -1.

    value = mv_initial_value.

    " Fill in the first row (index 0)
    DO mv_dimention TIMES.
      APPEND VALUE #( dy = dy dx = dx value = value ) TO lt_coordinates.
      value = value + 1.
      dx = dx + 1.
    ENDDO.

    seq_dimention = mv_dimention.

    " Find the row and column numbers and set the values.
    DO ( 2 * mv_dimention - 2 ) / 2 TIMES.
      sign_coef = - sign_coef.
      seq_dimention = seq_dimention - 1.

      DO 2 TIMES.
        seq_number = seq_number + 1.

        DO seq_dimention TIMES.

          IF seq_number MOD 2 <> 0.
            dy = dy + 1 * sign_coef.
          ELSE.
            dx = dx - 1 * sign_coef.
          ENDIF.

          APPEND VALUE #( dy = dy dx = dx value = value ) TO lt_coordinates.
          value = value + 1.
        ENDDO.

      ENDDO.

    ENDDO.

    ro_result = me.

  ENDMETHOD.

  METHOD get_coordinates.
    rv_result = lt_coordinates.
  ENDMETHOD.

  METHOD print.

    DATA cnt TYPE i.
    DATA line TYPE string.

    SORT lt_coordinates BY dy dx ASCENDING.

    LOOP AT lt_coordinates ASSIGNING FIELD-SYMBOL(<ls_coordinates>).

      cnt = cnt + 1.
      line = |{ line } { <ls_coordinates>-value }|.

      IF cnt MOD mv_dimention = 0.
        WRITE / line.
        CLEAR line.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

START-OF-SELECTION.

  DATA(go_spiral_matrix) = NEW lcl_spiral_matrix( iv_dimention     = 5
                                                  iv_initial_value = 0 ).
  go_spiral_matrix->print( ).
