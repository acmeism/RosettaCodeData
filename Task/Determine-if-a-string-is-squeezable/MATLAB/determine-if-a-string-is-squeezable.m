function r = squeezee(s,c)
  ix = [];
  c  = unique(c);
  for k=1:length(c)
    ix=[ix; find((s(1:end-1)==s(2:end)) & (s(1:end-1)==c(k)))+1];
  end
  r=s;
  r(ix)=[];

  fprintf(1,'Character to be squeezed: "%s"\n',c);
  fprintf(1,'Input:  <<<%s>>>  length: %d\n',s,length(s));
  fprintf(1,'Output: <<<%s>>>  length: %d\n',r,length(r));
  fprintf(1,'Character to be squeezed: "%s"\n',c);

end


squeezee('', ' ')
squeezee('║╚═══════════════════════════════════════════════════════════════════════╗', '-')
squeezee('║"If I were two-faced, would I be wearing this one?" --- Abraham Lincoln ║', '7')
squeezee('║..1111111111111111111111111111111111111111111111111111111111111117777888║', '.')
squeezee('║I never give ''em hell, I just tell the truth, and they think it''s hell. ║', '.')
squeezee('║                                                    --- Harry S Truman  ║', '.')
squeezee('║                                                    --- Harry S Truman  ║', '-')
squeezee('║                                                    --- Harry S Truman  ║', 'r')
