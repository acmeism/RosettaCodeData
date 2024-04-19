exts$[] = [ ".zip" ".rar" ".7z" ".gz" ".archive" ".a##" ".tar.bz2" ]
fnames$[] = [ "MyData.a##" "MyData.tar.gz" "MyData.gzip" "MyData.7z.backup" "MyData..." "MyData" "MyData_v1.0.tar.bz2" "MyData_v1.0.bz2" ]
for fn$ in fnames$[]
   ext$ = ""
   for ext$ in exts$[]
      h = len ext$
      if substr fn$ (len fn$ - h + 1) h = ext$
         print fn$ & " -> " & ext$ & " -> true"
         break 1
      .
   .
   if ext$ = ""
      print fn$ & " -> false"
   .
.
