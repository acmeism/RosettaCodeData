type

  tAddressBook = Record
                  FName   : string[20];
                  LName   : string[30];
                  Address : string[30];
                  City    : string[30];
                  State   : string[2];
                  Zip5    : string[5];
                  Zip4    : string[4];
                  Phone   : string[14];
                  Deleted : boolean ;
                end;

var
  f     : file of tAddressBook ;
  v     : tAddressBook ;
  bytes : integer ;
begin
  AssignFile(f,fully qualified file name);
  Reset(f);
  Blockread(f,V,1,Bytes);
  Edit(v);
  Seek(F,FilePos(f)-1);
  BlockWrite(f,v,1,bytes);
  CloseFile(f);
end;
