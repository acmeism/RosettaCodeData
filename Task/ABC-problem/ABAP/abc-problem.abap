REPORT z_rosetta_abc.

" Type declaration for blocks of letters
TYPES: BEGIN OF block,
         s1 TYPE char1,
         s2 TYPE char1,
       END OF block,

       blocks_table TYPE STANDARD TABLE OF block.

DATA: blocks TYPE blocks_table.

CLASS word_maker DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS:
      can_make_word
        IMPORTING word          TYPE string
                  letter_blocks TYPE blocks_table
        RETURNING VALUE(found)  TYPE abap_bool.
ENDCLASS.

CLASS word_maker IMPLEMENTATION.
  METHOD can_make_word.

    " Create a reader stream that reads 1 character at a time
    DATA(reader) = NEW cl_abap_string_c_reader( word ).

    DATA(blocks) = letter_blocks.

    WHILE reader->data_available( ).

      DATA(ch) = to_upper( reader->read( 1 ) ).
      found = abap_false.

      LOOP AT blocks REFERENCE INTO DATA(b).
        IF ch = b->s1 OR ch = b->s2.
          found = abap_true.
          DELETE blocks INDEX sy-tabix.
          EXIT. " the inner loop once a character is found
        ENDIF.
      ENDLOOP.

      " If a character could not be found, stop looking further
      IF found = abap_false.
        RETURN.
      ENDIF.
    ENDWHILE.

  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.

  blocks = VALUE #( ( s1 = 'B' s2 = 'O' ) ( s1 = 'X' s2 = 'K' )
                    ( s1 = 'D' s2 = 'Q' ) ( s1 = 'C' s2 = 'P' )
                    ( s1 = 'N' s2 = 'A' ) ( s1 = 'G' s2 = 'T' )
                    ( s1 = 'R' s2 = 'E' ) ( s1 = 'T' s2 = 'G' )
                    ( s1 = 'Q' s2 = 'D' ) ( s1 = 'F' s2 = 'S' )
                    ( s1 = 'J' s2 = 'W' ) ( s1 = 'H' s2 = 'U' )
                    ( s1 = 'V' s2 = 'I' ) ( s1 = 'A' s2 = 'N' )
                    ( s1 = 'O' s2 = 'B' ) ( s1 = 'E' s2 = 'R' )
                    ( s1 = 'F' s2 = 'S' ) ( s1 = 'L' s2 = 'Y' )
                    ( s1 = 'P' s2 = 'C' ) ( s1 = 'Z' s2 = 'M' )
                  ).

  WRITE:/ COND string( WHEN word_maker=>can_make_word( word = 'A'        letter_blocks = blocks ) = abap_true THEN 'True' ELSE 'False' ).
  WRITE:/ COND string( WHEN word_maker=>can_make_word( word = 'BARK'     letter_blocks = blocks ) = abap_true THEN 'True' ELSE 'False' ).
  WRITE:/ COND string( WHEN word_maker=>can_make_word( word = 'BOOK'     letter_blocks = blocks ) = abap_true THEN 'True' ELSE 'False' ).
  WRITE:/ COND string( WHEN word_maker=>can_make_word( word = 'TREAT'    letter_blocks = blocks ) = abap_true THEN 'True' ELSE 'False' ).
  WRITE:/ COND string( WHEN word_maker=>can_make_word( word = 'COMMON'   letter_blocks = blocks ) = abap_true THEN 'True' ELSE 'False' ).
  WRITE:/ COND string( WHEN word_maker=>can_make_word( word = 'SQUAD'    letter_blocks = blocks ) = abap_true THEN 'True' ELSE 'False' ).
  WRITE:/ COND string( WHEN word_maker=>can_make_word( word = 'CONFUSE'  letter_blocks = blocks ) = abap_true THEN 'True' ELSE 'False' ).
