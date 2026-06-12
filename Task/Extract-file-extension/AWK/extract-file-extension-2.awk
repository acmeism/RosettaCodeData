BEGIN {
    arr[++i] = "picture.jpg"
    arr[++i] = "http://mywebsite.com/picture/image.png"
    arr[++i] = "myuniquefile.longextension"
    arr[++i] = "IAmAFileWithoutExtension"
    arr[++i] = "/path/to.my/file"
    arr[++i] = "file.odd_one"

    for (j=1; j<=i; j++) {
      printf("%-40s '%s'\n",arr[j],extract_ext(arr[j]))
    }
    exit(0)
}
function extract_ext(fn,  pos) {
	pos = match(fn, "\\.[^\\/\\\\:\\.]+$")
	if (pos == 0) {
		return ("")
	} else {
		return (substr(fn,pos+1))
	}
}
