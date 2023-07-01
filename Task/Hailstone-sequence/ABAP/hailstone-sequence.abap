CLASS lcl_hailstone DEFINITION.
  PUBLIC SECTION.
    TYPES: tty_sequence TYPE STANDARD TABLE OF i
                             WITH NON-UNIQUE EMPTY KEY,
           BEGIN OF ty_seq_len,
             start TYPE i,
             len   TYPE i,
           END OF ty_seq_len,
           tty_seq_len TYPE HASHED TABLE OF ty_seq_len
                            WITH UNIQUE KEY start.

    CLASS-METHODS:
      get_next
        IMPORTING
          n                           TYPE i
        RETURNING
          VALUE(r_next_hailstone_num) TYPE i,

      get_sequence
        IMPORTING
          start             TYPE i
        RETURNING
          VALUE(r_sequence) TYPE tty_sequence,

      get_longest_sequence_upto
        IMPORTING
          limit                     TYPE i
        RETURNING
          VALUE(r_longest_sequence) TYPE ty_seq_len.

  PRIVATE SECTION.
    TYPES: BEGIN OF ty_seq,
             start TYPE i,
             seq   TYPE tty_sequence,
           END OF ty_seq.
    CLASS-DATA: sequence_buffer TYPE HASHED TABLE OF ty_seq
                                     WITH UNIQUE KEY start.
ENDCLASS.

CLASS lcl_hailstone IMPLEMENTATION.
  METHOD get_next.
    r_next_hailstone_num = COND #( WHEN n MOD 2 = 0 THEN n / 2
                                   ELSE ( 3 * n ) + 1 ).
  ENDMETHOD.

  METHOD get_sequence.
    INSERT start INTO TABLE r_sequence.
    IF start = 1.
      RETURN.
    ENDIF.

    READ TABLE sequence_buffer ASSIGNING FIELD-SYMBOL(<buff>)
                               WITH TABLE KEY start = start.
    IF sy-subrc = 0.
      INSERT LINES OF <buff>-seq INTO TABLE r_sequence.
    ELSE.
      DATA(seq) = get_sequence( get_next( start ) ).
      INSERT LINES OF seq INTO TABLE r_sequence.
      INSERT VALUE ty_seq( start = start
                           seq   = seq ) INTO TABLE sequence_buffer.
    ENDIF.
  ENDMETHOD.

  METHOD get_longest_sequence_upto.
    DATA: max_seq TYPE ty_seq_len,
          act_seq TYPE ty_seq_len.

    DO limit TIMES.
      act_seq-len = lines( get_sequence( sy-index ) ).

      IF act_seq-len > max_seq-len.
        max_seq-len   = act_seq-len.
        max_seq-start = sy-index.
      ENDIF.
    ENDDO.

    r_longest_sequence = max_seq.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  cl_demo_output=>begin_section( |Hailstone sequence of 27 is: | ).
  cl_demo_output=>write( REDUCE string( INIT result = ``
                                        FOR item IN lcl_hailstone=>get_sequence( 27 )
                                        NEXT result = |{ result } { item }| ) ).
  cl_demo_output=>write( |With length: { lines( lcl_hailstone=>get_sequence( 27 ) ) }| ).
  cl_demo_output=>begin_section( |Longest hailstone sequence upto 100k| ).
  cl_demo_output=>write( lcl_hailstone=>get_longest_sequence_upto( 100000 ) ).
  cl_demo_output=>display( ).
