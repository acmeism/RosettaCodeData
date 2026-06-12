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
function extract_ext(fn,  sep1,sep2,tmp) {
    while (fn ~ (sep1 = ":|\\\\|\\/")) { # ":" or "\" or "/"
      fn = substr(fn,match(fn,sep1)+1)
    }
    while (fn ~ (sep2 = "\\.")) { # "."
      fn = substr(fn,match(fn,sep2)+1)
      tmp = 1
    }
    if (fn ~ /[^a-zA-Z0-9]/ || tmp == 0) {
    return("")
    }
    return(fn)
}
