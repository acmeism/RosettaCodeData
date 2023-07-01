  a="BALL";
  b="BELL";

  if a==b, disp('The strings are equal'); end;
  if strcmp(a,b), disp('The strings are equal'); end;
  if a~=b, disp('The strings are not equal'); end;
  if ~strcmp(a,b), disp('The strings are not equal'); end;
  if a > b, disp('The first string is lexically after than the second'); end;
  if a < b, disp('The first string is lexically before than the second'); end;
  if a >= b, disp('The first string is not lexically before than the second'); end;
  if a <= b, disp('The first string is not lexically after than the second'); end;

  % to make a case insensitive comparison convert both strings to the same lettercase:
  a="BALL";
  b="ball";
  if strcmpi(a,b), disp('The first and second string are the same disregarding letter case'); end;
  if lower(a)==lower(b), disp('The first and second string are the same disregarding letter case'); end;
