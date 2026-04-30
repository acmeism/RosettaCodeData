$response = (New-Object Net.WebClient).DownloadString("http://rosettacode.org/wiki/Category:Programming_Languages")
$languages = [regex]::matches($response,'title="Category:(.*?)">') | foreach {$_.Groups[1].Value}

$response = [Net.WebClient]::new().DownloadString("http://rosettacode.org/w/index.php?title=Special:Categories&limit=5000")
$response = [regex]::Replace($response,'(\d+),(\d+)','$1$2')

$members  = [regex]::matches($response,'<li><a[^>]+>([^<]+)</a>[^(]*[(](\d+) member[s]?[)]</li>') | foreach { [pscustomobject]@{
            Members =  [Int]($_.Groups[2].Value)
            Language = [String]($_.Groups[1].Value)
        }} | where {$languages.Contains($_.Language)} | sort -Descending Members

Get-Date -UFormat "Sample output on %d %B %Y at %R %Z"
$members | Select-Object -First 10 | foreach -Begin {$r, $rank, $count = 0, 0,-1} {
    $r++
    if ($count -ne $_.Members) {$rank = $r}
    $count = $_.Members
    $x = $_.Members.ToString("N0",[System.Globalization.CultureInfo]::CreateSpecificCulture('en-US'))
    $entry = "($x entries)"
    [String]::Format("Rank: {0,2} {1,15} {2}",$rank,$entry,$_.Language)
}
