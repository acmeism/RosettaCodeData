procedure TMain.btnDeleteClick(Sender: TObject);
var
  CurrentDirectory : String;
begin
   CurrentDirectory := GetCurrentDir;

   DeleteFile(CurrentDirectory + '\input.txt');
   RmDir(PChar(CurrentDirectory + '\docs'));

   DeleteFile('c:\input.txt');
   RmDir(PChar('c:\docs'));
end;
