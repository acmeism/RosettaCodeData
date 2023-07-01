function s = StructFromArrays(allKeys, allVals)
% allKeys must be cell array of strings of valid field-names
% allVals can be cell array or array of numbers
% Assumes arrays are same size and valid types
    s = struct;
    if iscell(allVals)
        for k = 1:length(allKeys)
            s.(allKeys{k}) = allVals{k};
        end
    else
        for k = 1:length(allKeys)
            s.(allKeys{k}) = allVals(k);
        end
    end
end
