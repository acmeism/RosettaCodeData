var fso = new ActiveXObject("Scripting.FileSystemObject");
var f = fso.GetFile('input.txt');
var mtime = f.DateLastModified;
