BEGIN
  MODE OPTNAME = STRUCT(STRING name),
       OPTSPECIES = STRUCT(STRING species),
       OPTBREED = STRUCT(STRING breed),
       OWNER=STRUCT(STRING first name, middle name, last name);

  # Version 2 of Algol 68G would not allow empty options to be specified as () so     #
  # VOID would need to be included in the MODEs for options and Empty option lists    #
  # would need to be written as (EMPTY)                                               #
  MODE OPTIONS = FLEX[1:0]UNION(OPTNAME,OPTSPECIES,OPTBREED,OWNER); # add ,VOID for Algol 68G version 2 #

  # due to the Yoneda ambiguity simple arguments must have an unique operator defined #
  # E.g. a string cannot be coerced to a structure with a single string field         #
  OP NAME = (STRING name)OPTNAME: (OPTNAME opt; name OF opt := name; opt),
     SPECIES = (STRING species)OPTSPECIES: (OPTSPECIES opt; species OF opt := species; opt),
     BREED = (STRING breed)OPTBREED: (OPTBREED opt; breed OF opt := breed; opt);

  PROC print pet = (OPTIONS option)VOID: (
    STRING name:="Rex", species:="Dinosaur", breed:="Tyrannosaurus"; # Defaults #
    OWNER owner := ("George","W.","Bush");
    FOR i TO UPB option DO
      CASE option[i] IN
        (OPTNAME option): name := name OF option,
        (OPTSPECIES option): species := species OF option,
        (OPTBREED option): breed := breed OF option,
        (OWNER option): owner := option
      ESAC
    OD;
    print(("Details: "
          ,IF CHAR c = breed[LWB breed]; char in string( c, NIL, "AaEeIiOoUu" ) THEN "an " ELSE "a " FI
          ,breed, " ", species, " named ",name," owned by ",owner, newline))
  );

  print pet((NAME "Mike", SPECIES "Dog", BREED "Irish Setter", OWNER("Harry", "S.", "Truman")));
  print pet(())     # use print pet((EMPTY)) for Algol 68G version 2 #
END
