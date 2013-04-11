fun div_check (x, y) = (
  ignore (x div y);
  false
) handle Div => true
