function lcp = longest_common_prefix(varargin)
ca    = char(varargin);
ix    = [any(ca~=ca(1,:),1),1];
lcp   = ca(1,1:find(ix,1)-1);
end

longest_common_prefix('aa', 'aa', 'aac')
