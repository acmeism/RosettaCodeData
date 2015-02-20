function tokenizeString(string,delimeter)

    tokens = {};

    while not(isempty(string))
        [tokens{end+1},string] = strtok(string,delimeter);
    end

    for i = (1:numel(tokens)-1)
        fprintf([tokens{i} '.'])
    end

    fprintf([tokens{end} '\n'])
end
