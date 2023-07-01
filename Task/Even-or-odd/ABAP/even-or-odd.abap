cl_demo_output=>display(
  VALUE string_table(
    FOR i = -5 WHILE i < 6 (
      COND string(
        LET r = i MOD 2 IN
        WHEN r = 0 THEN |{ i } is even|
        ELSE |{ i } is odd|
      )
    )
  )
).
