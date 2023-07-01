MODE BOUNTY = STRUCT(STRING name, INT value, weight, volume);

[]BOUNTY items = (
               ("panacea", 3000,   3,  25),
               ("ichor",   1800,   2,  15),
               ("gold",    2500,  20,   2)
      );

BOUNTY sack := ("sack",       0, 250, 250);

OP * = ([]INT a,b)INT: ( # dot product operator #
    INT sum := 0;
    FOR i TO UPB a DO sum +:= a[i]*b[i] OD;
    sum
);

OP INIT = (REF[]INT vector)VOID:
    FOR index FROM LWB vector TO UPB vector DO
        vector[index]:=0
    OD;

OP INIT = (REF[,]INT matrix)VOID:
    FOR row index FROM LWB matrix TO UPB matrix DO
        INIT matrix[row index,]
    OD;

PROC total value = ([]INT items count, []BOUNTY items, BOUNTY sack) STRUCT(INT value, weight, volume):(
    ###
    Given the count of each item in the sack return -1 if they can"t be carried or their total value.

    (also return the negative of the weight and the volume so taking the max of a series of return
    values will minimise the weight if values tie, and minimise the volume if values and weights tie).
    ###
    INT weight = items count * weight OF items;
    INT volume = items count * volume OF items;
    IF weight > weight OF sack OR volume > volume OF sack THEN
        (-1, 0, 0)
    ELSE
        ( items count * value OF items, -weight, -volume)
    FI
);

PRIO WRAP = 5; # wrap negative array indices as per python's indexing regime #
OP WRAP = (INT index, upb)INT:
  IF index>=0 THEN index ELSE upb + index + 1 FI;

PROC knapsack dp = ([]BOUNTY items, BOUNTY sack)[]INT:(
    ###
    Solves the Knapsack problem, with two sets of weights,
    using a dynamic programming approach
    ###

    # (weight+1) x (volume+1) table #
    # table[w,v] is the maximum value that can be achieved #
    # with a sack of weight w and volume v. #
    # They all start out as 0 (empty sack) #
    [0:weight OF sack, 0:volume OF sack]INT table; INIT table;

    FOR w TO 1 UPB table DO
        FOR v TO 2 UPB table DO
            ### Consider the optimal solution, and consider the "last item" added
            to the sack. Removing this item must produce an optimal solution
            to the subproblem with the sack"s weight and volume reduced by that
            of the item. So we search through all possible "last items": ###
            FOR item index TO UPB items DO
                BOUNTY item := items[item index];
                # Only consider items that would fit: #
                IF w >= weight OF item AND v >= volume OF item THEN
                    # Optimal solution to subproblem + value of item: #
                    INT candidate := table[w-weight OF item,v-volume OF item] + value OF item;
                    IF candidate > table[w,v] THEN
                        table[w,v] := candidate
                    FI
                FI
            OD
        OD
    OD;

    [UPB items]INT result; INIT result;
    INT w := weight OF sack, v := volume OF sack;
    WHILE table[w,v] /= 0 DO
        # Find the last item that was added: #
        INT needle = table[w,v];
        INT item index;
        FOR i TO UPB items WHILE
            item index := i;
            BOUNTY item = items[item index];
            INT candidate = table[w-weight OF item WRAP UPB table, v-volume OF item WRAP 2 UPB table] + value OF item;
#       WHILE # candidate NE needle DO
          SKIP
        OD;
        # Record it in the result, and remove it: #
        result[item index] +:= 1;
        w -:= weight OF items[item index];
        v -:= volume OF items[item index]
    OD;
    result
);

[]INT max items = knapsack dp(items, sack);
STRUCT (INT value, weight, volume) max :=  total value(max items, items, sack);
max := (value OF max, -weight OF max, -volume OF max);

FORMAT d = $zz-d$;

printf(($"The maximum value achievable (by dynamic programming) is "gl$, value OF max));
printf(($"  The number of ("n(UPB items-1)(g", ")g") items to achieve this is: ("n(UPB items-1)(f(d)",")f(d)") respectively"l$,
    name OF items, max items));
printf(($"  The weight to carry is "f(d)", and the volume used is "f(d)l$,
    weight OF max, volume OF max))
