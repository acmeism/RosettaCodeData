def Leonardo(zero; one; incr):
  def leo:
    if . == 0 then zero
    elif . == 1 then one
    else ((.-1) |leo) + ((.-2) | leo) +  incr
    end;
  leo;
