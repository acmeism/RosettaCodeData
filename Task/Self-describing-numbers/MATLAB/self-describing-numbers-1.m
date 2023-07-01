function z = isSelfDescribing(n)
  s = int2str(n)-'0';    % convert to vector of digits
  y = hist(s,0:9);
  z = all(y(1:length(s))==s);
end;
