# Case insensitive keys, both end up as the same key:
$h=@{}
$h['a'] = 1
$h['A'] = 2
$h

Name                           Value
----                           -----
a                              2

# Case sensitive keys:
$h = New-Object -TypeName System.Collections.Hashtable
$h['a'] = 1
$h['A'] = 2
$h

Name                           Value
----                           -----
A                              2
a                              1
