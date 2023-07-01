create or replace package ethiopian is

  function multiply
    ( left    in  integer,
      right   in  integer)
  return integer;

end ethiopian;
/

create or replace package body ethiopian is

  function is_even(item  in integer) return boolean is
  begin
    return item mod 2 = 0;
  end is_even;

  function double(item  in integer) return integer is
  begin
    return item * 2;
  end double;

  function half(item  in integer) return integer is
  begin
    return trunc(item / 2);
  end half;

  function multiply
    ( left   in integer,
      right  in integer)
    return Integer
  is
    temp     integer := 0;
    plier    integer := left;
    plicand  integer := right;
  begin

    loop
      if not is_even(plier) then
        temp := temp + plicand;
      end if;
      exit when plier <= 1;
      plier := half(plier);
      plicand := double(plicand);
    end loop;

    return temp;

  end multiply;

end ethiopian;
/

/* example call */
begin
  dbms_output.put_line(ethiopian.multiply(17, 34));
end;
/
