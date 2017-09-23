cl_demo_output=>display( VALUE stringtab( FOR i = 1 WHILE i <= 100 ( COND #(  LET m3 = i MOD 3 m5 = i MOD 5 IN
                                                                             WHEN m3 = 0 AND m5 = 0 THEN |FIZZBUZZ|
                                                                             WHEN m3 = 0            THEN |FIZZ|
                                                                             WHEN m5 = 0            THEN |BUZZ|
                                                                             ELSE i ) ) ) ).
