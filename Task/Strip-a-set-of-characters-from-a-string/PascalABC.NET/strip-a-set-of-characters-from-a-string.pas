function StripChars(s,chars: string): string
  := s.Where(c -> c not in chars).JoinToString;

begin
  Print(StripChars('She was a soul stripper. She took my heart!','aei'));
end.
