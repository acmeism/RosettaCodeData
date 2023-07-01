Import-Module ActiveDirectory

$searchData = "user name"
$searchBase = "DC=example,DC=com"

#searches by some of the most common unique identifiers
get-aduser -Filter((DistinguishedName -eq $searchdata) -or (UserPrincipalName -eq $searchdata) -or (SamAccountName -eq $searchdata)) -SearchBase $searchBase
