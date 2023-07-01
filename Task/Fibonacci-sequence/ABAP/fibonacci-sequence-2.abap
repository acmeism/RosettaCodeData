cl_demo_output=>display( REDUCE #( INIT fibnm = VALUE stringtab( ( |0| ) ( |1| ) )
                                        n TYPE string
                                        x = `0`
                                        y = `1`
                                      FOR i = 1 WHILE i <= 100
                                     NEXT n = ( x + y )
                                          fibnm = VALUE #( BASE fibnm ( n ) )
                                          x = y
                                          y = n ) ).
