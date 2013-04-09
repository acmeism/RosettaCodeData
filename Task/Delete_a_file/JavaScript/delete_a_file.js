var fso = new ActiveXObject("Scripting.FileSystemObject");

fso.DeleteFile('input.txt');
fso.DeleteFile('c:/input.txt');

fso.DeleteFolder('docs');
fso.DeleteFolder('c:/docs');
