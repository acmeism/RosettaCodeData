function testMTF
    symTable = 'abcdefghijklmnopqrstuvwxyz';
    inStr = {'broood' 'bananaaa' 'hiphophiphop'};
    for k = 1:length(inStr)
        outArr = encodeMTF(inStr{k}, symTable);
        outStr = decodeMTF(outArr, symTable);
        fprintf('%s: [ %s]\n', inStr{k}, sprintf('%d ', outArr))
        fprintf('%scorrectly decoded to %s\n', char('in'.*~strcmp(outStr, inStr{k})), outStr)
    end
end

function arr = encodeMTF(str, symTable)
    n = length(str);
    arr = zeros(1, n);
    for k = 1:n
        arr(k) = find(str(k) == symTable, 1);
        symTable = [symTable(arr(k)) symTable(1:arr(k)-1) symTable(arr(k)+1:end)];
    end
    arr = arr-1; % Change to zero-indexed array
end

function str = decodeMTF(arr, symTable)
    arr = arr+1; % Change to one-indexed array
    n = length(arr);
    str = char(zeros(1, n));
    for k = 1:n
        str(k) = symTable(arr(k));
        symTable = [symTable(arr(k)) symTable(1:arr(k)-1) symTable(arr(k)+1:end)];
    end
end
