def is_numeric?(s)
  begin
    Float(s)
  rescue
    false # not numeric
  else
    true # numeric
  end
end
