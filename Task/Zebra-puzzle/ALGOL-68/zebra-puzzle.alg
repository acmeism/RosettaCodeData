BEGIN
    # attempt to solve Einstein's Riddle - the Zebra puzzle                     #
    INT unknown   = 0, same    = -1;
    INT english   = 1, swede   = 2, dane  = 3, norwegian   = 4, german = 5;
    INT dog       = 1, birds   = 2, cats  = 3, horse       = 4, zebra  = 5;
    INT red       = 1, green   = 2, white = 3, yellow      = 4, blue   = 5;
    INT tea       = 1, coffee  = 2, milk  = 3, beer        = 4, water  = 5;
    INT pall mall = 1, dunhill = 2, blend = 3, blue master = 4, prince = 5;
    []STRING nationality = ( "unknown", "english",   "swede",   "dane",   "norwegian",   "german" );
    []STRING animal      = ( "unknown", "dog",       "birds",   "cats",   "horse",       "ZEBRA"  );
    []STRING colour      = ( "unknown", "red",       "green",   "white",  "yellow",      "blue"   );
    []STRING drink       = ( "unknown", "tea",       "coffee",  "milk",   "beer",        "water"  );
    []STRING smoke       = ( "unknown", "pall mall", "dunhill", "blend",  "blue master", "prince" );
    MODE HOUSE = STRUCT( INT nationality, animal, colour, drink, smoke );
    # returns TRUE if a field in a house could be set to value, FALSE otherwise #
    PROC can set = ( INT field, INT value )BOOL: field = unknown OR value = same;
    # returns TRUE if the fields of house h could be set to those of            #
    #              suggestion s, FALSE otherwise                                #
    OP   XOR     = ( HOUSE h, HOUSE s )BOOL:
         (   can set( nationality OF h, nationality OF s ) AND can set( animal OF h, animal OF s )
         AND can set( colour      OF h, colour      OF s ) AND can set( drink  OF h, drink  OF s )
         AND can set( smoke       OF h, smoke       OF s )
         ) # XOR # ;
    # sets a field in a house to value if it is unknown                         #
    PROC set     = ( REF INT field, INT value )VOID: IF field = unknown AND value /= same THEN field := value FI;
    # sets the unknown fields in house h to the non-same fields of suggestion s #
    OP   +:=     = ( REF HOUSE h, HOUSE s )VOID:
         ( set( nationality OF h, nationality OF s ); set( animal OF h, animal OF s )
         ; set( colour      OF h, colour      OF s ); set( drink  OF h, drink  OF s )
         ; set( smoke       OF h, smoke       OF s )
         ) # +:= # ;
    # sets a field in a house to unknown if the value is not same               #
    PROC reset   = ( REF INT field, INT value )VOID: IF value /= same THEN field := unknown FI;
    # sets fields in house h to unknown if the suggestion s is not same         #
    OP   -:=     = ( REF HOUSE h, HOUSE s )VOID:
         ( reset( nationality OF h, nationality OF s ); reset( animal OF h, animal OF s )
         ; reset( colour      OF h, colour      OF s ); reset( drink  OF h, drink  OF s )
         ; reset( smoke       OF h, smoke       OF s )
         ) # -:= # ;
    # attempts a partial solution for the house at pos                          #
    PROC try = ( INT pos, HOUSE suggestion, PROC VOID continue )VOID:
         IF pos >= LWB house AND pos <= UPB house THEN
             IF house[ pos ] XOR suggestion THEN
                house[ pos ] +:= suggestion; continue; house[ pos ] -:= suggestion
             FI
         FI # try # ;
    # attempts a partial solution for the neighbours of a house                 #
    PROC left or right = ( INT pos, BOOL left, BOOL right, HOUSE neighbour suggestion
                         , PROC VOID continue )VOID:
         ( IF left  THEN try( pos - 1, neighbour suggestion, continue ) FI
         ; IF right THEN try( pos + 1, neighbour suggestion, continue ) FI
         ) # left or right # ;
    # attempts a partial solution for all houses and possibly their neighbours  #
    PROC any2 = ( REF INT number, HOUSE suggestion
                , BOOL left, BOOL right, HOUSE neighbour suggestion
                , PROC VOID continue )VOID:
         FOR pos TO UPB house DO
             IF house[ pos ] XOR suggestion THEN
                 number    := pos;
                 house[ number ] +:= suggestion;
                 IF NOT left AND NOT right THEN # neighbours not involved       #
                     continue
                 ELSE                           # try one or both neighbours    #
                     left or right( pos, left, right, neighbour suggestion, continue )
                 FI;
                 house[ number ] -:= suggestion
             FI
         OD # any2 # ;
    # attempts a partial solution for all houses                                #
    PROC any = ( HOUSE suggestion, PROC VOID continue )VOID:
         any2( LOC INT, suggestion, FALSE, FALSE, SKIP, continue );
    # find solution(s)                                                          #
    INT blend pos;
    INT solutions := 0;
    # There are five houses.                                                    #
    [ 1 : 5 ]HOUSE house;
    FOR h TO UPB house DO house[ h ] := ( unknown, unknown, unknown, unknown, unknown ) OD;
    # In the middle house they drink milk.                                      #
    drink       OF house[ 3 ] := milk;
    # The Norwegian lives in the first house.                                   #
    nationality OF house[ 1 ] := norwegian;
    # The Norwegian lives next to the blue house.                               #
    colour      OF house[ 2 ] := blue;
    # They drink coffee in the green house.                                     #
    # The green house is immediately to the left of the white house.            #
    any2( LOC INT,     ( same, same, green, coffee, same )
       ,  FALSE, TRUE, ( same, same, white, same,   same ), VOID:
      # In a house next to the house where they have a horse,                   #
      # they smoke Dunhill.                                                     #
      # In the yellow house they smoke Dunhill.                                 #
      any2( LOC INT,    ( same, horse, same,   same, same    )
          , TRUE, TRUE, ( same, same,  yellow, same, dunhill ), VOID:
        # The English man lives in the red house.                               #
        any( ( english, same, red, same, same ), VOID:
          # The man who smokes Blend lives in the house next to the             #
          # house with cats.                                                    #
          any2( blend pos,  ( same, same, same, same, blend )
              , TRUE, TRUE, ( same, cats, same, same, same  ), VOID:
            # They drink water in a house next to the house where               #
            # they smoke Blend.                                                 #
            left or right( blend pos, TRUE, TRUE, ( same, same, same, water, same ), VOID:
              # The Dane drinks tea.                                            #
              any( ( dane, same, same, tea, same ), VOID:
                # The man who smokes Blue Master drinks beer.                   #
                any( ( same, same, same, beer, blue master ), VOID:
                  # The Swede has a dog.                                        #
                  any( ( swede, dog, same, same, same ), VOID:
                    # The German smokes Prince.                                 #
                    any( ( german, same, same, same, prince ), VOID:
                      # The man who smokes Pall Mall has birds.                 #
                      any( ( same, birds, same, same, pall mall ), VOID:
                        # if we can place the zebra, we have a solution         #
                        any( ( same, zebra, same, same, same ), VOID:
                             ( solutions +:= 1;
                               FOR h TO UPB house DO
                                 print( ( whole( h, 0 )
                                        , " ",  nationality[ 1 + nationality OF house[ h ] ]
                                        , ", ", animal     [ 1 + animal      OF house[ h ] ]
                                        , ", ", colour     [ 1 + colour      OF house[ h ] ]
                                        , ", ", drink      [ 1 + drink       OF house[ h ] ]
                                        , ", ", smoke      [ 1 + smoke       OF house[ h ] ]
                                        , newline
                                        )
                                      )
                               OD;
                               print( ( newline ) )
                             )
                           ) # zebra     #
                         ) # pall mall  #
                       ) # german      #
                     ) # swede        #
                   ) # beer          #
                 ) # dane           #
               ) # blend L/R       #
             ) # blend            #
           ) # red               #
         ) # horse              #
       ) # green               # ;
    print( ( "solutions: ", whole( solutions, 0 ), newline ) )
END
