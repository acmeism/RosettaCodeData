def div_check(x, y)
  begin
    x / y
  rescue ZeroDivisionError
    true
  else
    false
  end
end
