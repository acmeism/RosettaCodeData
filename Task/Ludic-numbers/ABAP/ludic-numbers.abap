CLASS lcl_ludic DEFINITION CREATE PUBLIC.

  PUBLIC SECTION.
    TYPES: t_ludics TYPE SORTED TABLE OF i WITH UNIQUE KEY table_line.
    TYPES: BEGIN OF t_triplet,
             i1 TYPE i,
             i2 TYPE i,
             i3 TYPE i,
           END OF t_triplet.
    TYPES: t_triplets TYPE STANDARD TABLE OF t_triplet WITH EMPTY KEY.

    CLASS-METHODS:
      ludic_up_to
        IMPORTING i_int           TYPE i
        RETURNING VALUE(r_ludics) TYPE t_ludics,
      get_triplets
        IMPORTING i_ludics          TYPE t_ludics
        RETURNING VALUE(r_triplets) TYPE t_triplets.

    "RETURNING parameters (CallByValue) only used for readability of the demo
    "in "Real Life" you should use EXPORTING (CallByRef) for tables

ENDCLASS.

cl_demo_output=>begin_section( 'First 25 Ludics' ).
cl_demo_output=>write( lcl_ludic=>ludic_up_to( 110 ) ).

cl_demo_output=>begin_section( 'Ludics up to 1000' ).
cl_demo_output=>write( lines( lcl_ludic=>ludic_up_to( 1000 ) ) ).

cl_demo_output=>begin_section( '2000th - 2005th Ludics' ).
DATA(ludics) = lcl_ludic=>ludic_up_to( 22000 ).
cl_demo_output=>write( VALUE lcl_ludic=>t_ludics( FOR i = 2000 WHILE i <= 2005 ( ludics[ i ] ) ) ).

cl_demo_output=>begin_section( 'Triplets up to 250' ).
cl_demo_output=>write( lcl_ludic=>get_triplets( lcl_ludic=>ludic_up_to( 250 ) ) ).

cl_demo_output=>display( ).

CLASS lcl_ludic IMPLEMENTATION.

  METHOD ludic_up_to.

    r_ludics = VALUE #( FOR i = 2 WHILE i <= i_int ( i ) ).

    DATA(cursor) = 0.

    WHILE cursor < lines( r_ludics ).

      cursor = cursor + 1.
      DATA(this_ludic) = r_ludics[ cursor ].
      DATA(remove_cursor) = cursor + this_ludic.

      WHILE remove_cursor <= lines( r_ludics ).
        DELETE r_ludics INDEX remove_cursor.
        remove_cursor = remove_cursor + this_ludic - 1.
      ENDWHILE.

    ENDWHILE.

    INSERT 1 INTO TABLE r_ludics.  "add one as the first Ludic number (per definition)

  ENDMETHOD.

  METHOD get_triplets.

    DATA(i) = 0.
    WHILE i < lines( i_ludics ) - 2.
      i = i + 1.

      DATA(this_ludic) = i_ludics[ i ].
      IF  line_exists( i_ludics[ table_line = this_ludic + 2 ] )
      AND line_exists( i_ludics[ table_line = this_ludic + 6 ] ).
        r_triplets = VALUE #(
           BASE r_triplets
           ( i1 = i_ludics[ table_line = this_ludic ]
             i2 = i_ludics[ table_line = this_ludic + 2 ]
             i3 = i_ludics[ table_line = this_ludic + 6 ]
           )
        ).
      ENDIF.

    ENDWHILE.

  ENDMETHOD.

ENDCLASS.
