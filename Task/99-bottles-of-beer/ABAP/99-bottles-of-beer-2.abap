REPORT YCL_99_BOTTLES.

DATA it_99_bottles TYPE TABLE OF string WITH EMPTY KEY.
DATA(cr_lf) = cl_abap_char_utilities=>cr_lf.
it_99_bottles = VALUE #(
    FOR i = 99 THEN i - 1 UNTIL i = 0 ( COND string( LET  lv = ( i - 1 )
                                                          lr = i && | bottles of beer on the wall|
                                                                 && cr_lf
                                                                 && i && | bottles of beer|
                                                                 && cr_lf
                                                                 && |Take one down, pass it around|
                                                                 && cr_lf
                                                                 && lv && | bottles of beer on the wall|
                                                                 && cr_lf IN WHEN 1 = 1 THEN lr )
                                      )
                         ).
cl_demo_output=>write( it_99_bottles ).
cl_demo_output=>display( ).
