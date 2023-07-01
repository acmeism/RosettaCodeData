REPORT guess_the_number.

DATA prng TYPE REF TO cl_abap_random_int.

cl_abap_random_int=>create(
  EXPORTING
    seed = cl_abap_random=>seed( )
    min  = 1
    max  = 10
  RECEIVING
    prng = prng ).

DATA(number) = prng->get_next( ).

DATA(field) = VALUE i( ).

cl_demo_input=>add_field( EXPORTING text = |Choice one number between 1 and 10| CHANGING field = field ).
cl_demo_input=>request( ).

WHILE number <> field.
  cl_demo_input=>add_field( EXPORTING text = |You miss, try again| CHANGING field = field ).
  cl_demo_input=>request( ).
ENDWHILE.

cl_demo_output=>display( |Well Done| ).
