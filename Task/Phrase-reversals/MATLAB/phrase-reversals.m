function r=revstr(s,d)
slist=strsplit(s,d);
for k=1:length(slist)
        rlist{k}=slist{k}(end:-1:1);
end;
fprintf(1,'%s\n',s)
fprintf(1,'%s %c',slist{end:-1:1},d)
fprintf(1,'\n');
fprintf(1,'%s %c',rlist{:},d)
fprintf(1,'\n');
fprintf(1,'%s\n',s(end:-1:1))
end

revstr('Rosetta Code Phrase Reversal', ' ')
