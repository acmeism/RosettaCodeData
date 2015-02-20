lcs(Xs0, Ys0) ->
    CacheKey = {lcs_cache, Xs0, Ys0},
    case get(CacheKey)
    of  undefined ->
            Result =
                case {Xs0, Ys0}
                of  {[], _} -> []
                ;   {_, []} -> []
                ;   {[Same | Xs], [Same | Ys]} ->
                        [Same | lcs(Xs, Ys)]
                ;   {[_ | XsRest]=XsAll, [_ | YsRest]=YsAll} ->
                        A = lcs(XsRest, YsAll),
                        B = lcs(XsAll , YsRest),
                        case length(A) > length(B)
                        of  true  -> A
                        ;   false -> B
                        end
                end,
            undefined = put(CacheKey, Result),
            Result
    ;   Result ->
            Result
    end.
