def div_check(x, y)
  begin
    x.div y
  rescue ZeroDivisionError
    true
  else
    false
  end
end
