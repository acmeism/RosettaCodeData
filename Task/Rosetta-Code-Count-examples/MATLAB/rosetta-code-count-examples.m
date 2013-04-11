  function c = count_examples(url)
    c = 0;
    [s, success] = urlread (url);
    if ~success, return; end;
    c = length(strfind(s,'<h2><span class='));
  end;

  % script
  s   = urlread ('http://rosettacode.org/wiki/Category:Programming_Tasks');
  pat = '<li><a href="/wiki/';
  ix  = strfind(s,pat)+length(pat)-6;
  for k = 1:length(ix);
     % look through all tasks
     e = find(s(ix(k):end)==34,1)-2;
     t = s(ix(k)+[0:e]);    % task
     c = count_examples(['http://rosettacode.org',t]);
     printf('Task "%s" has %i examples.\n',t(7:end), c);  	
  end;
