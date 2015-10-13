TYPES: tty_int TYPE STANDARD TABLE OF i
                    WITH NON-UNIQUE DEFAULT KEY.

DATA(itab) = VALUE tty_int( ( 1 )
                            ( 2 )
                            ( 3 ) ).

INSERT 4 INTO TABLE itab.
APPEND 5 TO itab.
DELETE itab INDEX 1.

cl_demo_output=>display( itab ).
cl_demo_output=>display( itab[ 2 ] ).
