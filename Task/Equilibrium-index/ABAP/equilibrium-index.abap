REPORT equilibrium_index.

TYPES: y_i TYPE STANDARD TABLE OF i WITH EMPTY KEY.

cl_demo_output=>display( REDUCE y_i( LET sequences = VALUE y_i( ( -7 ) ( 1 ) ( 5 ) ( 2 ) ( -4 ) ( 3 ) ( 0 ) )
                                         total_sum = REDUCE #( INIT sum = 0
                                                                FOR sequence IN sequences
                                                               NEXT sum = sum + ( sequence ) ) IN
                                      INIT x = VALUE y_i( )
                                           y = 0
                                       FOR i = 1 UNTIL i > lines( sequences )
                                       LET z = sequences[ i ] IN
                                      NEXT x = COND #( WHEN y = ( total_sum - y - z ) THEN VALUE y_i( BASE x ( i - 1 ) ) ELSE x )
                                           y = y + z ) ).
