cl_demo_output=>display( REDUCE stringtab( INIT list TYPE stringtab
                                              aux TYPE i
                                          FOR door = 1 WHILE door <= 100
                                          FOR pass = 1 WHILE pass <= 100
                                         NEXT aux   = COND #( WHEN pass = 1 THEN 1
                                                              WHEN door MOD pass = 0 THEN aux + 1 ELSE aux  )
                                              list  = COND #( WHEN pass = 100
                                                                THEN COND #( WHEN aux MOD 2 <> 0 THEN VALUE #( BASE list ( CONV #( door ) ) )
                                                                              ELSE list ) ELSE list ) ) ).
