% Find Mian-Chowla numbers: an
                     where: ai = 1,
                       and: an = smallest integer such that ai + aj is unique
                                             for all i, j in 1 .. n && i <= j
%
begin
    record HashedSum ( integer hSum; reference(HashedSum) hNext );
    integer  HASH_MOD, MAX_MC;
    HASH_MOD := 10000;
    MAX_MC   :=   100;
    begin
        % hash table of sums of the sequence elements encountered so far %
        reference(HashedSum) array sums ( 0 :: HASH_MOD - 1 );
        % table of the sequence elements encountered so far              %
        integer              array mc   ( 1 :: MAX_MC       );
        integer                    mcCount, i;
        for i := 0 until HASH_MOD - 1 do sums( i ) := null;
        mcCount := 1;
        i       := 0;
        while begin i := i + 1; mcCount <= MAX_MC end do begin
            logical isUnique;
            integer mcPos;
            % assume i will be part of the sequence                      %
            mc( mcCount ) := i;
            % check the sums                                             %
            isUnique      := true;
            mcPos         := 0;
            while begin mcPos := mcPos + 1; mcPos <= mcCount and isUnique end do begin
                integer s;
                reference(HashedSum) hs;
                % attempt to find the sum in the hash table              %
                s  := i + mc( mcPos );
                hs := sums( s rem HASH_MOD );
                while hs not = null and s not = hSum(hs) do hs := hNext(hs);
                isUnique := hs = null
            end while_isUnique;
            if isUnique then begin
                % i is a sequence element - store its sums               %
                for mcPos   := 1 until mcCount do begin
                    integer newSum, sumHash;
                    newSum  := i + mc( mcPos );
                    sumHash := newSum rem HASH_MOD;
                    sums( sumHash ) := HashedSum( newSum, sums( sumHash ) )
                end for_mcPos ;
                mcCount := mcCount + 1
            end if_isUnique
        end while_mcCount_le_MAX_MC;

        % print parts of the sequence                                  %
        write( "Mian Chowla sequence elements 1..30:" );write();
        for i :=  1 until  30 do writeon( i_w := 1, s_w := 0, " ", mc( i ) );
        write( "Mian Chowla sequence elements 91..100:" );write();
        for i := 91 until 100 do writeon( i_w := 1, s_w := 0, " ", mc( i ) )
    end
end.
