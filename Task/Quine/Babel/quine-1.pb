% bin/babel quine.sp
{ "{ '{ ' << dup [val 0x22 0xffffff00 ] dup <- << << -> << ' ' << << ' }' << } !" { '{ ' << dup [val 0x22 0xffffff00 ] dup <- << << -> << ' ' << << '}' << } ! }%
%
% cat quine.sp
{ "{ '{ ' << dup [val 0x22 0xffffff00 ] dup <- << << -> << ' ' << << ' }' << } !" { '{ ' << dup [val 0x22 0xffffff00 ] dup <- << << -> << ' ' << << '}' << } ! }%
%
