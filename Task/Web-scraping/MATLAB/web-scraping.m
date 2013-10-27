s  = urlread('http://tycho.usno.navy.mil/cgi-bin/timer.pl');
ix = [findstr(s,'<BR>'), length(s)+1];
for k = 2:length(ix)
     tok = s(ix(k-1)+4:ix(k)-1);
     if findstr(tok,'UTC')
	disp(tok);
     end;
end;
