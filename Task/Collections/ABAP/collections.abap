REPORT z_test_rosetta_collection.

CLASS lcl_collection DEFINITION CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS: start.
ENDCLASS.

CLASS lcl_collection IMPLEMENTATION.
  METHOD start.
    DATA(itab) = VALUE int4_table( ( 1 ) ( 2 ) ( 3 ) ).

    cl_demo_output=>display( itab ).
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  NEW lcl_collection( )->start( ).
