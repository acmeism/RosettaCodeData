begin
    % calculates the molar mass of the specified molecule %
    real procedure molar_mass ( string(256) value molecule ) ; begin
        string(1) c;
        integer   chPos, chMax;
        logical   hadError;
        real      mass;
        % reports a syntax error in the molecule starting at position chPos %
        procedure syntaxError( string(80) value message ) ; begin
            integer mPos;
            write( "Syntax error in molecule: " );
            mPos := 0;
            while mPos < 80 and message( mPos // 1 ) not = "." do begin
                writeon( message( mPos // 1 ) );
                mPos := mPos + 1
            end while_not_end_of_message ;
            write( "    " );for i := 0 until chMax     do writeon( molecule( i // 1 ) );
            write( "    " );for i := 0 until chPos - 1 do writeon( " " );
            writeon( "^" );
            % ensure parsing stops %
            hadError := true;
            chPos    := chMax * 2
        end syntaxError ;
        % gets the next character from the molecule %
        procedure nextChar ; begin
            chPos := chPos + 1;
            c     := if chPos > chMax then " " else molecule( chPos // 1 )
        end nextChar ;
        % parses a compound: a sequence of element names and bracketed compounds, each with   %
        % an optional trailing repeat count                                                   %
        real procedure parseCompound ; begin
            real mass, itemMass;
            % parses an element symbol feom the molecule and retutns its mass                 %
            real procedure parseAtom ; begin
                string(3)       symbol;
                reference(Atom) element;
                symbol := c;
                nextChar;
                if c >= "a" and c <= "z" then begin
                    symbol( 1 // 1 ) := c;
                    nextChar;
                    if c >= "a" and c <= "z" then begin
                        symbol( 2 // 1 ) := c;
                        nextChar
                    end if_have_lc_letter
                end if_have_lc_letter ;
                % find the element in the table %
                element := atoms( decode( symbol( 0 // 1 ) ) - decode( "A" ) );
                while element not = null and aSymbol(element) not = symbol do element := aNext(element);
                if element not = null then % found the element % aMass(element)
                else begin % unknown element %
                    chPos := chPos - 1;
                    syntaxError( "Unrecognised element." );
                    0
                end
            end parseAtom ;
            mass := 0;
            while not hadError and ( ( c >= "A" and c <= "Z" ) or c = "(" ) do begin
                if c >= "A" and c <= "Z" then itemMass := parseAtom
                else if c = "(" then begin % bracketed group %
                    nextChar;
                    itemMass := parseCompound;
                    if chPos > chMax or molecule( chPos // 1 ) not = ")" then syntaxError( "Expected "")""." );
                    nextChar
                end ;
                if c >= "0" and c <= "9" then begin % have a repeat count %
                    integer count;
                    count := 0;
                    while not hadError and c >= "0" and c <= "9" do begin
                        count := ( count * 10 ) + ( decode( c ) - decode( "0" ) );
                        nextChar
                    end while_not_end_of_number ;
                    itemMass := itemMass * count
                end if_have_a_digit ;
                mass := mass + itemMass
            end while_still_parseing ;
            mass
        end parseCompound ;
        hadError := false;
        % find the end of the molecule %
        chMax := 255;
        while chMax > 0 and molecule( chMax // 1 ) = " " do chMax := chMax - 1;
        % parse the molecule %
        chPos := -1;
        nextChar;
        mass := parseCompound;
        if chPos <= chMax then syntaxError( "Unexpected text after the molecule." );
        mass
    end molar_mass ;
    % record to hold element symbols and masses %
    record Atom( string(3) aSymbol; real aMass; reference(Atom) aNext );
    % hash table of atome, hash is the first character of the symbol - "A" %
    reference(Atom) array atoms ( 0 :: 25 ); for i := 0 until 25 do atoms( i ) := null;
    begin % setup element symbols and masses as specified in the task %
        % adds an element and its mass to the atoms table %
        procedure A ( string(3) value symbol; real value mass ) ; begin
            integer index;
            index := decode( symbol( 0 // 1 ) ) - decode( "A" );
            atoms( index ) := Atom( symbol, mass, atoms( index ) )
        end A ;
        procedure Lanthanides ; begin
            A("La",138.90547);A("Ce",140.116 );A("Pr",140.90766);A("Nd",144.242  );A("Pm",145     );
            A("Sm",150.36   );A("Eu",151.964 );A("Gd",157.25   );A("Tb",158.92535);A("Dy",162.5   );
            A("Ho",164.93033);A("Er",167.259 );A("Tm",168.93422);A("Yb",173.054  );A("Lu",174.9668);
        end Lanthanides ;
        procedure Actinides ; begin
            A("Ac",227      );A("Th",232.0377);A("Pa",231.03588);A("U", 238.02891);A("Np",237     );
            A("Pu",244      );A("Am",243     );A("Cm",247      );A("Bk",247      );A("Cf",251     );
            A("Es",252      );A("Fm",257     ); % Md           % %, No           %  % Lr          %
        end Actinides ;
        real CsMass; CsMass := 132.90545196;
        A("Li", 6.94       );A("Na",22.98976928 );A("K", 39.0983  );A("Rb", 85.4678 );A("Cs",CsMass    );A("Fr",223);
        A("Be", 9.0121831  );A("Mg",24.305      );A("Ca",40.078   );A("Sr", 87.62   );A("Ba",137.327   );A("Ra",226);
                                                  A("Sc",44.955908);A("Y",  88.90584);Lanthanides;       Actinides;
                                                  A("Ti",47.867   );A("Zr", 91.224  );A("Hf",178.49    ); % Rf %
                                                  A("V", 50.9415  );A("Nb", 92.90637);A("Ta",180.94788 ); % Db %
                                                  A("Cr",51.9961  );A("Mo", 95.95   );A("W", 183.84    ); % Sg %
                                                  A("Mn",54.938044); % Tc           % A("Re",186.207   ); % Bh %
                                                  A("Fe",55.845   );A("Ru",101.07   );A("Os",190.23    ); % Hs %
                                                  A("Co",58.933194);A("Rh",102.9055 );A("Ir",192.217   ); % Mt %
                                                  A("Ni",58.6934  );A("Pd",106.42   );A("Pt",195.084   ); % Ds %
                                                  A("Cu",63.546   );A("Ag",107.8682 );A("Au",196.966569); % Rg %
                                                  A("Zn",65.38    );A("Cd",112.414  );A("Hg",200.592   ); % Cn %
        A("B", 10.81       );A("Al",26.9815385  );A("Ga",69.723   );A("In",114.818  );A("Tl",204.38    ); % Nh %
        A("C", 12.011      );A("Si",28.085      );A("Ge",72.63    );A("Sn",118.71   );A("Pb",207.2     ); % Fl %
        A("N", 14.007      );A("P", 30.973761998);A("As",74.921595);A("Sb",121.76   );A("Bi",208.9804  ); % Ms %
        A("O", 15.999      );A("S", 32.06       );A("Se",78.971   );A("Te",127.6    );A("Po",209       ); % Lv %
        A("F", 18.998403163);A("Cl",35.45       );A("Br",79.904   );A("I", 126.90447);A("At",210       ); % Ts %
        A("Ne",20.1797     );A("Ar",39.948      );A("Kr",83.798   );A("Xe",131.293  );A("Rn",222       ); % Og %
        % ---------------- first period elements ---> % A("H",    1.008);A("He",   4.002602);
        % --- hypothetical eigth period elements ---> % A("Uue",315    );A("Ubn",299       );
    end;
    begin % test cases %
        procedure test( real value expectedMass; string(256) value molecule ) ; begin
            real mass, diff;
            mass := molar_mass( molecule );
            write( r_format := "A", r_d := 3, r_w := 9
                 , molecule( 0 // 20 ), ":", mass
                 );
            diff := expectedMass - mass;
            if diff > 1'-12 or diff < -1'-12 then writeon( r_format := "A", r_d := 2, r_w := 9
                                                         , " expected:", expectedMass
                                                         )
        end text ;
        test( 1.008, "H" ); test( 2.016, "H2" );         test(  18.015, "H2O"   );
        test( 142.03553856000002, "Na2SO4"            ); test(  84.162, "C6H12" );
        test( 186.29499999999996, "COOH(C(CH3)2)3CH3" ); test( 350.45,  "UueCl" );
    end
end.
