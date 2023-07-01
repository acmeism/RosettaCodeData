jacobi(_, N) when N =< 0 -> jacobi_domain_error;
jacobi(_, N) when (N band 1) =:= 0 -> jacobi_domain_error;
jacobi(A, N) when A < 0 ->
    J2 = ja(-A, N),
    case N band 3 of
        1 -> J2;
        3 -> -J2
    end;
jacobi(A, N) -> ja(A, N).

ja(0, _) -> 0;
ja(1, _) -> 1;
ja(A, N) when A >= N -> ja(A rem N, N);
ja(A, N) when (A band 1) =:= 0 -> % A is even
    J2 = ja(A bsr 1, N),
    case N band 7 of
        1 -> J2;
        3 -> -J2;
        5 -> -J2;
        7 -> J2
    end;
ja(A, N) ->    % if we get here, A is odd, so we can flip it.
    J2 = ja(N, A),
    case (A band 3 =:= 3) and (N band 3 =:= 3) of
        true  -> -J2;
        false -> J2
    end.
