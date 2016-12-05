// Assumes a CSV file exists and has been sprayed to a Thor cluster
MyFileLayout := RECORD
STRING Field1;
STRING Field2;
STRING Field3;
STRING Field4;
STRING Field5;
END;							

MyDataset := DATASET ('~Rosetta::myCSVFile', MyFileLayout,CSV(SEPARATOR(',')));

MyFileLayout Appended(MyFileLayout pInput):= TRANSFORM
  SELF.Field1 := pInput.Field1 +'x';
  SELF.Field2 := pInput.Field2 +'y';
  SELF.Field3 := pInput.Field3 +'z';
  SELF.Field4 := pInput.Field4 +'a';
  SELF.Field5 := pInput.Field5 +'b';
END ;

MyNewDataset := PROJECT(MyDataset,Appended(LEFT));
OUTPUT(myNewDataset,,'~Rosetta::myNewCSVFile',CSV,OVERWRITE);
