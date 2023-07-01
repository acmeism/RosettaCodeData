declare @n int
set @n=123
if @n=123
  BEGIN --begin/end needed if more than one statement inside
    print 'one two three'
  END
ELSE
  if @n=124 print 'one two four'
  else print 'other'
