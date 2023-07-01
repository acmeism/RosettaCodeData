variable haystack = ["Zig","Zag","Wally","Ronald","Bush","Krusty","Charlie","Bush","Bozo","Ronald"];

define find(needle)
{
    variable i = where(haystack == needle);
    if (length(i)) {
       % print(sprintf("%s: first=%d, last=%d", needle, i[0], i[-1]));
       return(i[0], i[-1]);
    }
    else
       throw ApplicationError, "an exception";
}

($1, $2) = find("Ronald");     % returns 3, 9
($1, $2) = find("McDonald");   % throws ApplicationError, labelled "an exception"
