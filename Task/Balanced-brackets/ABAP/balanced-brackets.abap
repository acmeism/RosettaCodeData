CLASS lcl_balanced_brackets DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS:
      class_constructor,

      are_brackets_balanced
        IMPORTING
          seq                            TYPE string
        RETURNING
          VALUE(r_are_brackets_balanced) TYPE abap_bool,

      get_random_brackets_seq
        IMPORTING
          n                    TYPE i
        RETURNING
          VALUE(r_bracket_seq) TYPE string.

  PRIVATE SECTION.
    CLASS-DATA: random_int TYPE REF TO cl_abap_random_int.

    CLASS-METHODS:
      _split_string
        IMPORTING
          i_text         TYPE string
        RETURNING
          VALUE(r_chars) TYPE stringtab,

      _rand_bool
        RETURNING
          VALUE(r_bool) TYPE i.
ENDCLASS.

CLASS lcl_balanced_brackets IMPLEMENTATION.
  METHOD class_constructor.
    random_int = cl_abap_random_int=>create( seed = CONV #( sy-uzeit )
                                             min  = 0
                                             max  = 1 ).
  ENDMETHOD.

  METHOD are_brackets_balanced.
    DATA: open_bracket_count TYPE i.

    DATA(chars) = _split_string( seq ).

    r_are_brackets_balanced = abap_false.

    LOOP AT chars ASSIGNING FIELD-SYMBOL(<c>).
      IF <c> = ']' AND open_bracket_count = 0.
        RETURN.
      ENDIF.

      IF <c> = ']'.
        open_bracket_count = open_bracket_count - 1.
      ENDIF.

      IF <c> = '['.
        open_bracket_count = open_bracket_count + 1.
      ENDIF.
    ENDLOOP.

    IF open_bracket_count > 0.
      RETURN.
    ENDIF.

    r_are_brackets_balanced = abap_true.
  ENDMETHOD.

  METHOD get_random_brackets_seq.
    DATA(itab) = VALUE stringtab( FOR i = 1 THEN i + 1 WHILE i <= n
                                     ( COND #( WHEN _rand_bool( ) = 0 THEN '['
                                               ELSE ']' ) ) ).
    r_bracket_seq = concat_lines_of( itab ).
  ENDMETHOD.

  METHOD _rand_bool.
    r_bool = random_int->get_next( ).
  ENDMETHOD.

  METHOD _split_string.
    DATA: off TYPE i VALUE 0.

    DO strlen( i_text ) TIMES.
      INSERT i_text+off(1) INTO TABLE r_chars.
      off = off + 1.
    ENDDO.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  DO 10 TIMES.
    DATA(seq) = lcl_balanced_brackets=>get_random_brackets_seq( 10 ).
    cl_demo_output=>write( |{ seq } => { COND string( WHEN lcl_balanced_brackets=>are_brackets_balanced( seq ) = abap_true THEN 'OK'
                                                      ELSE 'NOT OK' ) }| ).
  ENDDO.
  cl_demo_output=>display( ).
