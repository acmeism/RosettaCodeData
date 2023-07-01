with Ada.Text_IO, Ada.Integer_Text_IO, Ada.Command_Line;

procedure Floyd_Triangle is
  rows : constant Natural := Natural'Value(Ada.Command_Line.Argument(1));
begin
  for r in 1..rows loop
    for i in 1..r loop
      Ada.Integer_Text_IO.put (r*(r-1)/2+i, Width=> Natural'Image(rows*(rows-1)/2+i)'Length);
    end loop;
    Ada.Text_IO.New_Line;
  end loop;
end Floyd_Triangle;
