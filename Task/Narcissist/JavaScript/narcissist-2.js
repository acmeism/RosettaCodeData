var oFSO = new ActiveXObject("Scripting.FileSystemObject");
function readfile(fname) {
	var h = oFSO.OpenTextFile(fname, 1, false);
	var result = h.ReadAll();
	h.Close();
	return result;
}

if (0 === WScript.Arguments.UnNamed.Count) {
	WScript.Echo(WScript.ScriptName,"filename");
	WScript.Quit();
}

// first read self
var self = readfile(WScript.ScriptFullName);
// read whatever file is given on commmand line
var whatever = readfile(WScript.Arguments.UnNamed(0));

// compare and contrast
WScript.Echo(self === whatever ? "Accept" : "Reject");
