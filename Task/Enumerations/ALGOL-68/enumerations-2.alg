BEGIN # example 2 #
    MODE ENUM = SHORT SHORT INT; # something with minimal size #
    MODE ASSAM = STRUCT(ENUM assam),
         BREADFRUIT = STRUCT(ENUM breadfruit),
         CAYENNE = STRUCT(ENUM cayenne),
         DEKOPON = STRUCT(ENUM dekopon),
         EGGFRUIT = STRUCT(ENUM eggfruit),
         FEIJOA = STRUCT(ENUM feijoa),
         GOOSEBERRY = STRUCT(ENUM gooseberry),
         HUCKLEBERRY = STRUCT(ENUM huckleberry),
         INKYCAP = STRUCT(ENUM inkycap, STRING warning), # !! #
         JICAMA = STRUCT(ENUM jicama);
    MODE ANFOOD = UNION(ASSAM, EGGFRUIT, INKYCAP);
    MODE AFOOD = UNION(BREADFRUIT, CAYENNE, DEKOPON, FEIJOA, GOOSEBERRY, HUCKLEBERRY, JICAMA);
  # MODE FRUIT = UNION(ASSAM, BREADFRUIT, CAYENNE, DEKOPON, EGGFRUIT, FEIJOA, GOOSEBERRY, HUCKLEBERRY, JICAMA); #
    MODE SAVORY = UNION(BREADFRUIT, CAYENNE, JICAMA, INKYCAP);
    MODE FOOD = UNION(AFOOD, ANFOOD);

    OP REPR = (FOOD in food)STRING:
        CASE in food IN
            (ASSAM a):"Assam",
            (BREADFRUIT b):"Breadfruit",
            (CAYENNE c):"Cayenne",
            (DEKOPON d):"Dekopon",
            (EGGFRUIT e):"Eggfruit",
            (FEIJOA f):"Feijoa",
            (GOOSEBERRY g):"Gooseberry",
            (HUCKLEBERRY h):"Huckleberry ",
            (INKYCAP i):"Inkycap: "+warning OF i,
            (JICAMA j):"Jicama"
        OUT
            "?" # uninitalised #
        ESAC;

    OP COLOR = (FOOD in food)STRING:
        CASE in food IN
            (ASSAM a):"black",
            (BREADFRUIT b):"brown",
            (CAYENNE c):"red",
            (DEKOPON d):"orange",
            (EGGFRUIT e):"yellow",
            (FEIJOA f):"green",
            (GOOSEBERRY g):"blue",
            (HUCKLEBERRY h):"violet",
            (INKYCAP i):"gray",
            (JICAMA j):"white"
        OUT
            "?" # uninitalised #
        ESAC;

    OP ABS = (FOOD in food)INT:
        CASE in food IN
            (ASSAM a): 0,
            (BREADFRUIT b): 1,
            (CAYENNE c): 2,
            (DEKOPON d): 3,
            (EGGFRUIT e): 4,
            (FEIJOA f): 5,
            (GOOSEBERRY g): 6,
            (HUCKLEBERRY h): 7,
            (INKYCAP i): 8,
            (JICAMA j): 9
        ESAC;

    INKYCAP inkycap := (8,"An edible (although poisonous when combined with alcohol) mushroom!");

    FOOD food := inkycap;

    CASE food IN # in a conformity-clause #
        (ANFOOD):print(("It is an ",REPR food, ".", new line)),
        (AFOOD):print(("It is a ",REPR food, ".", new line))
    OUT
        SKIP # uninitialised FOOD #
    ESAC;

    CASE food IN # in a conformity-clause #
        (SAVORY):print((REPR food," is ", COLOR food,"(",whole(ABS food,-1),") and savoury.", new line))
    OUT
        SKIP
    ESAC;

    # output only, food in a conformity-clause format-frame #
    printf(($"Food: "f(food|
        (ASSAM a):$"assam"$,
        (BREADFRUIT b):$"breadfruit"$,
        (CAYENNE c):$"cayenne"$,
        (DEKOPON d):$"dekopon"$,
        (EGGFRUIT e):$"eggfruit"$,
        (FEIJOA f):$"feijoa"$,
        (GOOSEBERRY g):$"gooseberry"$,
        (HUCKLEBERRY h):$"huckleberry"$,
        (INKYCAP i):$"inkycap"$,
        (JICAMA j):$"jicama"$
     |$"?"$)l$))

END
