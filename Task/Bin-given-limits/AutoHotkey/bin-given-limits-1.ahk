Bin_given_limits(limits, data){
    bin := [], counter := 0
    for i, val in data	{
        if (limits[limits.count()] <= val)
            bin["∞", ++counter] := val

        else for j, limit in limits
            if (limits[j-1] <= val && val < limits[j])
                bin[limit, ++counter] := val
    }

    for j, limit in limits	{
        output .=  (prevlimit ? prevlimit : "-∞") ", " limit " : " ((x:=bin[limit].Count())?x:0) "`n"
        prevlimit := limit
    }
    return output .=  (prevlimit ? prevlimit : "-∞") ",  ∞ : " ((x:=bin["∞"].Count())?x:0) "`n"
}
