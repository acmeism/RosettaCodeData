DATA: tab TYPE TABLE OF string.

tab = VALUE #(
  FOR i = 1 WHILE i <= 100 (
    COND string( LET r3 = i MOD 3
                     r5 = i MOD 5 IN
                 WHEN r3 = 0 AND r5 = 0 THEN |FIZZBUZZ|
                 WHEN r3 = 0            THEN |FIZZ|
                 WHEN r5 = 0            THEN |BUZZ|
                 ELSE i ) ) ).

cl_demo_output=>write( tab ).
cl_demo_output=>display( ).
