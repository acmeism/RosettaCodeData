function [result] = remove_vowels(text)
% http://rosettacode.org/wiki/Remove_vowels_from_a_string

flag=zeros(size(text));
for c='AEIOUaeiou'
        flag=flag|(text==c);
end
result=text(~flag);
end

remove_vowels('The AWK Programming Language')
remove_vowels('The quick brown fox jumps over the lazy dog')

%!test
%! assert(remove_vowels('The AWK Programming Language'),'Th WK Prgrmmng Lngg')
%!test
%! assert(remove_vowels('The quick brown fox jumps over the lazy dog'),'Th qck brwn fx jmps vr th lzy dg')
