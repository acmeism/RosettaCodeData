function r = comma_quibbling(varargin)
	if isempty(varargin)
		r = '';
	elseif length(varargin)==1;
		r = varargin{1};
	else
		r = [varargin{end-1},' and ', varargin{end}];
		for k=length(varargin)-2:-1:1,
			r = [varargin{k}, ', ', r];
		end
	end
end;
