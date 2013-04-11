 StringHash[string_String]:=Module[{stream=OpenWrite[],file,hash},
  WriteString[stream,string];
  file=Close[stream];
  hash=FileHash[file,"MD5"];
  DeleteFile[file];
  hash
 ]
