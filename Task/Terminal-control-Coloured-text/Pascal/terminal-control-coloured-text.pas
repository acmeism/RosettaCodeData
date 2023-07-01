program Colorizer;

uses CRT;

const SampleText = 'Lorem ipsum dolor sit amet';

var fg, bg: 0..15;

begin
    ClrScr;
    for fg := 0 to 7 do begin
        bg := 15 - fg;
        TextBackground(bg);
        TextColor(fg);
        writeln(SampleText)
    end;
    TextBackground(White);
    TextColor(Black);
end.
