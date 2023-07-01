MODE MYDATA = STRUCT(
    INT name1
);
STRUCT(
    INT name2,
    PROC (REF MYDATA)REF MYDATA new,
    PROC (REF MYDATA)VOID init,
    PROC (REF MYDATA)VOID some method
) class my data;
class my data := (
  # name2 := # 2, # Class attribute #

  # PROC new := # (REF MYDATA new)REF MYDATA:(
        (init OF class my data)(new);
        new
   ),

  # PROC init := # (REF MYDATA self)VOID:(
        """ Constructor  (Technically an initializer rather than a true 'constructor') """;
        name1 OF self := 0 # Instance attribute #
    ),

  # PROC some method := # (REF MYDATA self)VOID:(
        """ Method """;
        name1 OF self := 1;
        name2 OF class my data := 3
    )
);

# class name, invoked as a function is the constructor syntax #
REF MYDATA my data = (new OF class my data)(LOC MYDATA);

MODE GENDEROPT = UNION(STRING, VOID);
MODE AGEOPT = UNION(INT, VOID);

MODE MYOTHERDATA = STRUCT(
    STRING name,
    GENDEROPT gender,
    AGEOPT age
);
STRUCT (
    INT count,
    PROC (REF MYOTHERDATA, STRING, GENDEROPT, AGEOPT)REF MYOTHERDATA new,
    PROC (REF MYOTHERDATA, STRING, GENDEROPT, AGEOPT)VOID init,
    PROC (REF MYOTHERDATA)VOID del
) class my other data;
class my other data := (
  # count := # 0,  # Population of "(init OF class my other data)" objects #
# PROC new := # (REF MYOTHERDATA new, STRING name, GENDEROPT gender, AGEOPT age)REF MYOTHERDATA:(
          (init OF class my other data)(new, name, gender, age);
          new
      ),

  # PROC init := # (REF MYOTHERDATA self, STRING name, GENDEROPT gender, AGEOPT age)VOID:(
        """ One initializer required, others are optional (with different defaults) """;
        count OF class my other data +:= 1;
        name OF self := name;
        gender OF self := gender;
        CASE gender OF self IN
            (VOID):gender OF self := "Male"
        ESAC;
        age OF self := age
    ),

  # PROC del := # (REF MYOTHERDATA self)VOID:(
        count OF class my other data -:= 1
    )
);

PROC attribute error := STRING: error char; # mend the error with the "error char" #

# Allocate the instance from HEAP #
REF MYOTHERDATA person1 =  (new OF class my other data)(HEAP MYOTHERDATA, "John", EMPTY, EMPTY);
print (((name OF person1), ": ",
        (gender OF person1|(STRING gender):gender|attribute error), " "));  # "John Male" #
print (((age OF person1|(INT age):age|attribute error), new line)); # Raises AttributeError exception! #

# Allocate the instance from LOC (stack) #
REF MYOTHERDATA person2 = (new OF class my other data)(LOC MYOTHERDATA, "Jane", "Female", 23);
print (((name OF person2), ": ",
        (gender OF person2|(STRING gender):gender|attribute error), " "));
print (((age OF person2|(INT age):age|attribute error), new line))  # "Jane Female 23" #
