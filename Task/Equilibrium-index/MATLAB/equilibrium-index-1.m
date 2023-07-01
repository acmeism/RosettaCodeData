function indicies = equilibriumIndex(list)

    indicies = [];

    for i = (1:numel(list))
        if ( sum(-list(1:i)) == sum(-list(i:end)) )
            indicies = [indicies i];
        end
    end

end
