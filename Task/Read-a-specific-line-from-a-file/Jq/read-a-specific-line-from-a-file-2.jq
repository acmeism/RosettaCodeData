$line | tonumber
| if . > 0 then read_line
  else "$line (\(.)) should be a non-negative integer"
  end
