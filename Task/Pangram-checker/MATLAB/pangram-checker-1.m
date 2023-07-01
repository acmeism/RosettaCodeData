function trueFalse = isPangram(string)

    %This works by histogramming the ascii character codes for lower case
    %letters contained in the string (which is first converted to all
    %lower case letters). Then it finds the index of the first letter that
    %is not contained in the string (this is faster than using the find
    %without the second parameter). If the find returns an empty array then
    %the original string is a pangram, if not then it isn't.

    trueFalse = isempty(find( histc(lower(string),(97:122))==0,1 ));

end
