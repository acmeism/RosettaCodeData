uses System.IO;

begin
  FileInfo.Create('input.txt').Length.Println;
  FileInfo.Create('/input.txt').Length.Println;
end.
