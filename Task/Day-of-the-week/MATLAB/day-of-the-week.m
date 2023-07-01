  t  = datenum([[2008:2121]',repmat([12,25,0,0,0], 2121-2007, 1)]);
  t  = t(strmatch('Sunday', datestr(t,'dddd')), :);
  datestr(t,'yyyy')		
