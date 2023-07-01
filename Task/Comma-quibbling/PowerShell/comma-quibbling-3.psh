$file = @'

ABC
ABC, DEF
ABC, DEF, G, H
'@ -split [Environment]::NewLine

foreach ($line in $file)
{
    Out-Quibble -Text ($line -split ", ")
}
