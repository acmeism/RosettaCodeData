IMPORT STD; //Imports the Standard Library

STRING MyBaseString := 'alphaBETA';

UpperCased := STD.str.toUpperCase(MyBaseString);
LowerCased := STD.str.ToLowerCase(MyBaseString);
TitleCased := STD.str.ToTitleCase(MyBaseString);

OUTPUT (UpperCased);
OUTPUT (LowerCased);
OUTPUT (TitleCased);
