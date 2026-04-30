-- 24 Sep 2025
include Setting
numeric digits 20

say 'DATE FORMAT'
say version
say
say 'Below examples may be coded with full option or only first letter.'
say 'Both uppercase and lowercase are accepted.'
say 'Not shown here, but the Date() function also supports conversions.'
say
w=18
say 'Date function...'
say 'Default  ' Left(Date(),w) 'same as Normal'
say 'Base     ' Left(Date('B'),w) 'days since Jan 1, 0001'
say 'Days     ' Left(Date('D'),w) 'days since Jan 1, this year'
say 'European ' Left(Date('E'),w) 'dd/mm/yy'
if Pos('ooRexx',version) > 0 then
   say 'Full     ' Left(Date('F'),w) 'microsecs since Jan 1, 0001, 00:00:00 (ooRexx)'
say 'ISO      ' Left(Date('I'),w) 'yyyy-mm-dd'
if Pos('ooRexx',version) > 0 then
   say 'Language ' Left(Date('L'),w) 'dd month yyyy (ooRexx NL)'
say 'Month    ' Left(Date('M'),w) 'Month name'
say 'Normal   ' Left(Date('N'),w) 'dd Mmm yyyy'
say 'Ordered  ' Left(Date('O'),w) 'yy/mm/dd'
say 'Standard ' Left(Date('S'),w) 'yyyymmdd'
say 'Ticks    ' Left(Date('T'),w) 'seconds since Jan 1, 1970, 00:00:00'
say 'USA      ' Left(Date('U'),w) 'mm/dd/yy'
say 'Weekday  ' Left(Date('W'),w) 'Day of week'
say
say 'Task...'
say Date('I')
say Date('W')',' Date('M') Right(Date('S'),2)/1',' Left(Date('S'),4)
exit

include Abend
