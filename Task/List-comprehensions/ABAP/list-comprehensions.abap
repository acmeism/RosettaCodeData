CLASS lcl_pythagorean_triplet DEFINITION CREATE PUBLIC.
  PUBLIC SECTION.
    TYPES: BEGIN OF ty_triplet,
             x TYPE i,
             y TYPE i,
             z TYPE i,
           END OF ty_triplet,
           tty_triplets TYPE STANDARD TABLE OF ty_triplet WITH NON-UNIQUE EMPTY KEY.

    CLASS-METHODS:
      get_triplets
        IMPORTING
          n                 TYPE i
        RETURNING
          VALUE(r_triplets) TYPE tty_triplets.

  PRIVATE SECTION.
    CLASS-METHODS:
      _is_pythagorean
        IMPORTING
          i_triplet               TYPE ty_triplet
        RETURNING
          VALUE(r_is_pythagorean) TYPE abap_bool.
ENDCLASS.

CLASS lcl_pythagorean_triplet IMPLEMENTATION.
  METHOD get_triplets.
    DATA(triplets) = VALUE tty_triplets( FOR x = 1 THEN x + 1 WHILE x <= n
                                         FOR y = x THEN y + 1 WHILE y <= n
                                         FOR z = y THEN z + 1 WHILE z <= n
                                            ( x = x y = y z = z ) ).

    LOOP AT triplets ASSIGNING FIELD-SYMBOL(<triplet>).
      IF _is_pythagorean( <triplet> ) = abap_true.
        INSERT <triplet> INTO TABLE r_triplets.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD _is_pythagorean.
    r_is_pythagorean = COND #( WHEN i_triplet-x * i_triplet-x + i_triplet-y * i_triplet-y = i_triplet-z * i_triplet-z THEN abap_true
                               ELSE abap_false ).
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  cl_demo_output=>display( lcl_pythagorean_triplet=>get_triplets( n = 20 ) ).
