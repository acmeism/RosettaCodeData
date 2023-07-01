function r = collapse(s)
  ix=find((s(1:end-1)==s(2:end))+1;
  r=s;
  r(ix)=[];

  fprintf(1,'Input:  <<<%s>>>  length: %d\n',s,length(s));
  fprintf(1,'Output: <<<%s>>>  length: %d\n',r,length(r));
  fprintf(1,'Character to be squeezed: "%s"\n',c);

end


collapse('', ' ')
collapse('║╚═══════════════════════════════════════════════════════════════════════╗', '-')
collapse('║"If I were two-faced, would I be wearing this one?" --- Abraham Lincoln ║', '7')
collapse('║..1111111111111111111111111111111111111111111111111111111111111117777888║', '.')
collapse('║I never give ''em hell, I just tell the truth, and they think it''s hell. ║', '.')
collapse('║                                                    --- Harry S Truman  ║', '.')
collapse('║                                                    --- Harry S Truman  ║', '-')
collapse('║                                                    --- Harry S Truman  ║', 'r')
