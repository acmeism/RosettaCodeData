try
  Z := DoDiv (X,Y);
except
  on EDivException do Z := 0;
end;
