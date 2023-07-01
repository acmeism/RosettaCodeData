$languages  = @{}
$Body = @{
     format = 'json'
     action = 'query'
     generator = 'categorymembers'
     gcmtitle = 'Category:Programming Languages'
     gcmlimit = '200'
     gcmcontinue = ''
     continue = ''
     prop = 'categoryinfo'
 }
$params = @{
     Method = 'Get'
     Uri = 'http://rosettacode.org/mw/api.php'
     Body = $Body
 }
while ($true) {
    $response = Invoke-RestMethod @params
    $response.query.pages.PSObject.Properties | ForEach-Object {
        if (($_.value.PSObject.Properties.Name -Contains 'title') -and ($_.value.PSObject.Properties.Name -Contains 'categoryinfo')) {
            $languages[$_.value.title.replace('Category:', '')] = $_.value.categoryinfo.size
        }
    }
    if  ($response.PSObject.Properties.Name -Contains 'continue') {
        $gcmcontinue = $response.continue.gcmcontinue
        $params.Body.gcmcontinue = $gcmcontinue
    } else {
        break
    }
}
$members = $languages.GetEnumerator()  | sort -Descending value
Get-Date -UFormat "Sample output on %d %B %Y at %R %Z"
$members | Select-Object -First 10 | foreach -Begin {$r, $rank, $count = 0, 0,-1} {
    $r++
    if ($count -ne $_.Members) {$rank = $r}
    $count = $_.Value
    $x = $_.Value.ToString("N0",[System.Globalization.CultureInfo]::CreateSpecificCulture('en-US'))
    $entry = "($x entries)"
    [String]::Format("Rank: {0,2} {1,15} {2}",$rank, $entry, $_.Name)
}
