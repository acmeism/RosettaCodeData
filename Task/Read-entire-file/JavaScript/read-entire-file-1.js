var fso=new ActiveXObject("Scripting.FileSystemObject");
var f=fso.OpenTextFile("c:\\myfile.txt",1);
var s=f.ReadAll();
f.Close();
try{alert(s)}catch(e){WScript.Echo(s)}
