begin

comment - print odd squares between 100 and 1000;
integer oddsquare, nextgap;
oddsquare := 1;
nextgap   := 8;
while oddsquare < 100 do
    begin
        oddsquare := oddsquare + nextgap;
        nextgap   := nextgap + 8;
    end;
while oddsquare < 1000 do
    begin
        writeon(oddsquare);
        oddsquare := oddsquare + nextgap;
        nextgap   := nextgap + 8;
    end;

end
