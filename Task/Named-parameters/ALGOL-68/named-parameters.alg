#!/usr/local/bin/a68g --script #

MODE OPTNAME = STRUCT(STRING name),
     OPTSPECIES = STRUCT(STRING species),
     OPTBREED = STRUCT(STRING breed),
     OWNER=STRUCT(STRING first name, middle name, last name);

# due to the Yoneda ambiguity simple arguments must have an unique operator defined #
OP NAME = (STRING name)OPTNAME: (OPTNAME opt; name OF opt := name; opt),
   SPECIES = (STRING species)OPTSPECIES: (OPTSPECIES opt; species OF opt := species; opt),
   BREED = (STRING breed)OPTBREED: (OPTBREED opt; breed OF opt := breed; opt);

PROC print pet = ([]UNION(OPTNAME,OPTSPECIES,OPTBREED,OWNER) option)VOID: (
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
  printf(($gx$,"Details: a",breed,species,"named",name,"owned by",owner,$l$))
);

print pet((NAME "Mike", SPECIES "Dog", BREED "Irish Setter", OWNER("Harry", "S.", "Truman")));
print pet(())
