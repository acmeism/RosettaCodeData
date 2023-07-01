procedure dcr(step,dir:integer;length:real);
 begin;
  step:=step -1;
  length:= length/sqrt(2);
  if dir > 0 then
   begin
     if step > 0 then
     begin
       turnright(45);
       dcr(step,1,length);
       turnleft(90);
       dcr(step,0,length);
       turnright(45);
     end
     else
     begin
       turnright(45);
       forward(length);
       turnleft(90);
       forward(length);
       turnright(45);
     end;
   end
  else
   begin
     if step > 0 then
     begin
       turnleft(45);
       dcr(step,1,length);
       turnright(90);
       dcr(step,0,length);
       turnleft(45);
     end
     else
     begin
       turnleft(45);
       forward(length);
       turnright(90);
       forward(length);
       turnleft(45);
     end;
   end;
end;
