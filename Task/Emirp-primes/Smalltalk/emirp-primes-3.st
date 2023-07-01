emirpGen :=
    [:l | |rest el|
        rest := l.
        [ el := rest car. rest := rest cdr. isEmirp value:el ] whileFalse.
        LazyCons car:el cdr:[emirpGen value:rest]
    ].
