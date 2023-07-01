FOR i TO 1 000 DO # increase/decrease the TO value for a longer/shorter animation #
    FOR d TO 2 000 000 DO SKIP OD; # adjust to change the spin rate #
    print( ( CASE 1 + i MOD 4 IN "/", "-", "\", "|" ESAC, REPR 8 ) )
OD
