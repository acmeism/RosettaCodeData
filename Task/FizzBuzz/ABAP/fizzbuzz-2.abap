cl_demo_output=>display( value stringtab( for i = 1 until i > 100
                                          let fizz = cond #( when i mod 3 = 0 then |fizz| else space )
                                              buzz = cond #( when i mod 5 = 0 then |buzz| else space )
                                              fb   = |{ fizz }{ buzz }| in
                                         ( switch #( fb when space then i else fb ) ) ) ).
