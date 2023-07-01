function fileExtensionInExtensionsList(filename) {
	let foundIt = false;
	let filenameLC = filename.toLowerCase();
	let extensions = ["zip", "rar", "7z", "gz", "archive", "A##" ,"tar.bz2"];
	extensions.forEach(extension =>  {
		if (filenameLC.endsWith("." + extension.toLowerCase())) { foundIt = true; }
	} );
	return foundIt;
}

// perform tests below

var fileNamesToTest = [
	"MyData.a##"
	,"MyData.tar.Gz"
	,"MyData.gzip"
	,"MyData.7z.backup"
	,"MyData..."
	,"MyData"
	,"MyData_v1.0.tar.bz2"
	,"MyData_v1.0.bz2"
];

fileNamesToTest.forEach(filename => {
	console.log(filename + " -> " + fileExtensionInExtensionsList(filename));
});
