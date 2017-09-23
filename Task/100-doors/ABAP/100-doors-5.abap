cl_demo_output=>display( REDUCE stringtab( INIT list TYPE stringtab
                                          FOR i = 1 WHILE i <= 10
                                         NEXT list = VALUE #( BASE list ( i * i ) ) ) ).
