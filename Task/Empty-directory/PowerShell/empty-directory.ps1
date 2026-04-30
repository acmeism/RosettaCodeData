$path = "C:\Users"
if((Dir $path).Count -eq 0) {
    "$path is empty"
} else {
    "$path is not empty"
}
