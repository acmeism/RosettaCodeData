#  Populate test files
@'
Files full of
various words.
'@ | Out-File -FilePath C:\Test\File1.txt

@'
Create an index
of words.
'@ | Out-File -FilePath C:\Test\File2.txt

@'
Use the index
to find the files.
'@ | Out-File -FilePath C:\Test\File3.txt
