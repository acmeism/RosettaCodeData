#!/usr/local/bin/a68g --script #

STRING a="WBXAY",b="WCXBY",c="WDXCY",d="WEXDY",
       e="WFXEY",f="WGXFY",g="WHXGY",h="WIXHY",
       k="K",z="Z",l="";

[]STRING
  w=( # Assuming ASCII ordering #
    "fly","spider","Bird","Cat","Dog","Pig","Goat","Cow","Donkey","Horse",

    "I don't know why she swallowed the fly.",
    "That wriggled and jiggled and tickled inside her.",
    "Quite absurd","Fancy that","What a hog",
    "Her mouth was so big","She just opened her throat",
    "I don't know how","It was rather wonky",
    "She's dead, of course!",

    "I know an old lady who swallowed a ",
    ". To swallow a ",
    "She swallowed the "," to catch the ",".",
    "Perhaps she'll die."),
  v=(
    "UAY",k,z,l,
    "UBY","L",a,k,z,l,
    "UCY","MVCY",b,a,k,z,l,
    "UDY","NVDY",c,b,a,k,z,l,
    "UEY","OVEY",d,c,b,a,k,z,l,
    "UFY","PVFY",e,d,c,b,a,k,z,l,
    "UGY","QVGY",f,e,d,c,b,a,k,z,l,
    "UHY","RVHY",g,f,e,d,c,b,a,k,z,l,
    "UIY","SVIY",h,g,f,e,d,c,b,a,k,z,l,
    "UJY","T");

FOR i TO UPB v DO
  FOR j TO UPB v[i] DO
    print(w[ABS v[i][j] - ABS "A" + 1])
  OD;
  print(new line)
OD
