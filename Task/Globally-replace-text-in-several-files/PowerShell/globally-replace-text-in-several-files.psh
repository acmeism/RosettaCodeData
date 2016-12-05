$listfiles = @('file1.txt','file2.txt')
$old = 'Goodbye London!'
$new = 'Hello New York!'
foreach($file in $listfiles) {
    (Get-Content $file).Replace($old,$new) | Set-Content $file
}
