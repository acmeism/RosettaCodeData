# syntax: GAWK -f FILE_EXTENSION_IS_IN_EXTENSIONS_LIST.AWK
BEGIN {
    n = split("zip,rar,7z,gz,archive,A##,tar.bz2", arr, ",")
    for (i=1; i<=n; i++) {
      ext_arr[tolower(arr[i])] = ""
    }
    filenames = "MyData.a##,MyData.tar.Gz,MyData.gzip,MyData.7z.backup,MyData...,MyData,MyData_v1.0.tar.bz2,MyData_v1.0.bz2"
    n = split(filenames, fn_arr, ",")

    for (i=1; i<=n; i++) {
      ext_found = ""
      for (ext in ext_arr) {
        if (tolower(fn_arr[i]) ~ (".*\\." ext "$")) {
          ext_found = ext
          break
        }
      }
      ans = (ext_found == "") ? "is not in list" : ("is in list: " ext_found)
      printf("%s extension %s\n", fn_arr[i], ans)
    }
    exit(0)
}
