var file = document.getElementById("fileInput").files.item(0); //a file input element
if (file) {
	var reader = new FileReader();
	reader.readAsText(file, "UTF-8");
	reader.onload = loadedFile;
	reader.onerror = errorHandler;
}
function loadedFile(event) {
	var fileString = event.target.result;
	alert(fileString.length);
}
function errorHandler(event) {
	alert(event);
}
