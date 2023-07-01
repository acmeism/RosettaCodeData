//Written for TU Berlin
//Compiled with fpc
Program yingyang;
Uses Math;
const
 scale_x=2;
 scale_y=1;
 black='#';
 white='.';
 clear=' ';

function inCircle(centre_x:Integer;centre_y:Integer;radius:Integer;x:Integer;y:Integer):Boolean ;
begin
inCircle:=power(x-centre_x,2)+power(y-centre_y,2)<=power(radius,2);
end;

function bigCircle(radius:Integer;x:Integer;y:Integer):Boolean ;
begin
bigCircle:=inCircle(0,0,radius,x,y);
end;

function whiteSemiCircle(radius:Integer;x:Integer;y:Integer):Boolean ;
begin
whiteSemiCircle:=inCircle(0,radius div 2 ,radius div 2,x,y);
end;


function smallBlackCircle(radius:Integer;x:Integer;y:Integer):Boolean ;
begin
smallBlackCircle:=inCircle(0,radius div 2 ,radius div 6,x,y);
end;

function blackSemiCircle(radius:Integer;x:Integer;y:Integer):Boolean ;
begin
blackSemiCircle:=inCircle(0,-radius div 2 ,radius div 2,x,y);
end;

function smallWhiteCircle(radius:Integer;x:Integer;y:Integer):Boolean ;
begin
smallWhiteCircle:=inCircle(0,-radius div 2 ,radius div 6,x,y);
end;

var
radius,sy,sx,x,y:Integer;
begin
   writeln('Please type a radius:');
   readln(radius);
   if radius<3 then begin writeln('A radius bigger than 3');halt end;
   sy:=round(radius*scale_y);
   while(sy>=-round(radius*scale_y)) do begin
      sx:=-round(radius*scale_x);
      while(sx<=round(radius*scale_x)) do begin
        x:=sx div scale_x;
        y:=sy div scale_y;
        if bigCircle(radius,x,y) then begin
                if (whiteSemiCircle(radius,x,y)) then if smallblackCircle(radius,x,y) then write(black) else write(white) else if blackSemiCircle(radius,x,y) then if smallWhiteCircle(radius,x,y) then write(white) else write(black) else if x>0 then write(white) else write(black);
                end
              else write(clear);
        sx:=sx+1
      end;
      writeln;
      sy:=sy-1;
   end;
end.
