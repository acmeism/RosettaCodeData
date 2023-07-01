Parse Version v
Say 'Version='v
If a() | b() Then Say 'a and b are true'
If \a() | b() Then Say  'Surprise'
              Else Say 'ok'
If a(), b() Then Say 'a is true'
If \a(), b() Then Say  'Surprise'
             Else Say 'ok: \a() is false'
Select
  When \a(), b() Then Say 'Surprise'
  Otherwise           Say 'ok: \a() is false (Select)'
  End
Exit
a: Say 'a returns .true'; Return .true
b: Say 'b returns 1'; Return 1
