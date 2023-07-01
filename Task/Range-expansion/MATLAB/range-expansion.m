function L=range_expansion(S)
% Range expansion
if nargin < 1;
	S='[]';
end

if ~all(isdigit(S) | (S=='-')  | (S==',') | isspace(S))
	error 'invalid input';
end
ixr = find(isdigit(S(1:end-1)) & S(2:end) == '-')+1;
S(ixr)=':';
S=['[',S,']'];
L=eval(S);
