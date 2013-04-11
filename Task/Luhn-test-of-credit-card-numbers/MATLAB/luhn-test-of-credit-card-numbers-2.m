function passes = luhnTest(creditCardNum)

    %flip the order of the digits
    creditCardNum = fliplr( num2str(creditCardNum) )';

    %create the checksum and check its last digit for zero
    passes =  ~logical(min(str2num(num2str(sum( str2num( creditCardNum(1:2:length(creditCardNum)) ) )+sum( cellfun(@sum, cellfun(@str2num , cellfun(@transpose, cellstr(num2str(2*str2num(creditCardNum(2:2:length(creditCardNum))))) ,'UniformOutput',false) ,'UniformOutput',false)))).')));

end
