REPORT string_concatenation.

DATA(var1) = 'Hello'.
DATA(var2) = 'Literal'.

cl_demo_output=>new(
          )->begin_section( 'String concatenation using |{ }|'
          )->write( 'Statement: |{ var1 } { var2 }|'
          )->write( |{ var1 } { var2 }|
          )->begin_section( 'String concatenation with new string'
          )->write( 'Statement: |{ var1 } world!|'
          )->write( |{ var1 } world!|
          )->display( ).
