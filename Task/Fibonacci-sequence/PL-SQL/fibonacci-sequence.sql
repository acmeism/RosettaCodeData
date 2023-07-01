create or replace function fnu_fibonacci(p_num integer) return integer is
  f integer;
  p integer;
  q integer;
begin
  case when p_num < 0 or p_num != trunc(p_num)
                            then raise_application_error(-20001, 'Invalid input: ' || p_num, true);
       when p_num in (0, 1) then f := p_num;
       else
            p := 0;
            q := 1;
            for i in 2 .. p_num loop
              f := p + q;
              p := q;
              q := f;
            end loop;
  end case;
  return(f);
end fnu_fibonacci;
/
