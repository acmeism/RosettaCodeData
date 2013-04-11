declare
  I = {NewCell 1024}
in
  for while:@I > 0 do
     {Show @I}
     I := @I div 2
  end
