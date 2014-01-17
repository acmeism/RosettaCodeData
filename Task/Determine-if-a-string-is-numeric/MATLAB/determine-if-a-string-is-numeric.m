    % Is string numeric?
    function out = is_str_numeric(s)
        out = ~isempty(parse_float(s));
    end

    % Returns the float (double) if true, empty array otherwise.
    function f = parse_float(s)
        [f_in_cell, pos] = textscan(s, '%f');
        % Make sure there are no trailing chars. textscan(..) is greedy.
        if pos == length(s)
            f = f_in_cell{:};
        else
            f = [];
        end
    end
