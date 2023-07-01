 function t = last_fridays_of_year(y)
  t1 = datenum([y,1,1,0,0,0]);
  t2 = datenum([y,12,31,0,0,0]);
  t  = datevec(t1:t2);
  t  = t(strmatch('Friday', datestr(t,'dddd')), :);     % find all Fridays
  t  = t([find(diff(t(:,2)) > 0); end], :);     % find Fridays before change of month
  end;

  datestr(last_fridays_of_year(2012),'yyyy-mm-dd')		
