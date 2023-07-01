function variadicFunction(varargin)

    for i = (1:numel(varargin))
        disp(varargin{i});
    end

end
