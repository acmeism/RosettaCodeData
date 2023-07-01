 repeat_string(a_string: STRING; times: INTEGER): STRING
 require
   times_positive: times > 0
 do
   Result := a_string.multiply(times)
 end
