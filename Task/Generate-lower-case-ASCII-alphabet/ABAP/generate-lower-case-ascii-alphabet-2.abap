REPORT lower_case_ascii.

cl_demo_output=>new(
          )->begin_section( |Generate lower case ASCII alphabet|
          )->write( REDUCE string( INIT out TYPE string
                                    FOR char = 1 UNTIL char > strlen( sy-abcde )
                                   NEXT out = COND #( WHEN out IS INITIAL THEN sy-abcde(1)
                                                      ELSE |{ out } { COND string( WHEN char <> strlen( sy-abcde ) THEN sy-abcde+char(1) ) }| ) )
          )->write( |Or use the system field: { sy-abcde }|
          )->display( ).
