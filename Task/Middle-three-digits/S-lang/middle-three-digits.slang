define m3(i)
{
    variable s = string(i), sabs = s, l;

    if (sabs[0] == '-')
        sabs = sabs[[1:]];
    l = strlen(sabs);

    if (l < 3)
        print(sprintf("%s doesn't have enough digits", s));
    else if (l & 1) {
        variable st = (l-3) >> 1;
        print(sprintf("%13s: %s", s, sabs[[st:st+2]]));
    }
    else
        print(sprintf("%s has an even number of digits", s));
}

define middle_3(lst)
{
    foreach (lst)
        m3( () );
}

middle_3( { 123, 12345, 1234567, 987654321, 10001, -10001, -123, -100, 100, -12345,
#ifexists Int64_Type
         6644221335577ll, -11122588999ll,
#endif
         1, 2, -1, -10, 2002, -2002, 0 } );
