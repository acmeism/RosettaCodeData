with Ada.Text_IO;

procedure LoopsAndHalf is
begin
  for i in 1 .. 10 loop
    Ada.Text_IO.put (i'Img);
    exit when i = 10;
    Ada.Text_IO.put (",");
  end loop;
  Ada.Text_IO.new_line;
end LoopsAndHalf;
