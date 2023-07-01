# Calculate Levenshtein distance between strings - translated from the Action! sample #
BEGIN

  PROC levenshtein distance = (STRING str1, str2)INT:
  BEGIN

    INT m=UPB str1;
    INT n=UPB str2;

    (0:m,0:n)INT matrix;

    FOR i FROM 0 TO m DO FOR j FROM 0 TO n DO matrix(i,j):=0 OD OD;
    FOR i TO m DO matrix(i,1):=i OD;
    FOR j TO n DO matrix(1,j):=j OD;

    FOR j FROM 1 TO n DO
      FOR i FROM 1 TO m DO
        IF str1(i) = str2(j) THEN
          matrix(i,j):=matrix(i-1, j-1) # no operation required #
        ELSE
          INT min := matrix(i-1,j)+1    ; # deletion            #
          INT k    = matrix(i,j-1)+1    ; # insertion           #
          INT l    = matrix(i-1, j-1)+1 ; # substitution        #
          IF k < min THEN min:=k FI;
          IF l < min THEN min:=l FI;
          matrix(i,j):=min
        FI
      OD
    OD;
    matrix(m,n)
  END;

  STRING word 1, word 2;

  word 1 :="kitten"; word 2 := "sitting";
  print((word 1," -> ",word 2,": "));
  print(("Levenshtein Distance: ",whole(levenshtein distance(word 1,word 2),0),newline));

  word 1 := "rosettacode"; word 2 := "raisethysword";
  print((word 1," -> ",word 2,": "));
  print(("Levenshtein Distance: ",whole(levenshtein distance(word 1,word 2),0),newline));

  word 1 := "qwerty"; word 2 := "qweryt";
  print((word 1," -> ",word 2,": "));
  print(("Levenshtein Distance: ",whole(levenshtein distance(word 1,word 2),0),newline));

  word 1 := "Action!"; word 2 := "Algol 68";
  print((word 1," -> ",word 2,": "));
  print(("Levenshtein Distance: ",whole(levenshtein distance(word 1,word 2),0),newline))
END
