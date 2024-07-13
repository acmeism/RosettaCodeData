function StripControlCodes(s: string): string
  := s.Where(c -> c.Code in 32..126).JoinToString;

begin
  var s := #127'abc'#1#15#31'def'#12;
  Print(StripControlCodes(s));
end.
