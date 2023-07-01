function lcp = longest_common_dirpath(varargin)
ix    = find(varargin{1}=='/');
ca    = char(varargin);
flag  = all(ca==ca(1,:),1);
for k = length(ix):-1:1,
	if all(flag(1:ix(k))); break; end
end
lcp = ca(1,1:ix(k));
end

longest_common_dirpath('/home/user1/tmp/coverage/test', '/home/user1/tmp/covert/operator', '/home/user1/tmp/coven/members')
