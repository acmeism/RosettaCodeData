$Timer = [System.Diagnostics.Stopwatch]::StartNew()

$uri = 'http://wiki.puzzlers.org/pub/wordlists/unixdict.txt'
$words = -split [Net.WebClient]::new().DownloadString($uri)

$anagrams = @{}
$maxAnagramCount = 0

foreach ($w in $words)
{
    # Sort the characters in the word into alphabetical order
    $chars=[char[]]$w
    [array]::sort($chars)
    $orderedChars = [string]::Join('', $chars)


    # If no anagrams list for these chars, make one
    if (-not $anagrams.ContainsKey($orderedChars))
    {
        $anagrams[$orderedChars] = [Collections.Generic.List[String]]::new()
    }


    # Add current word as an anagram of these chars,
    # in a way which keeps the list available
    ($list = $anagrams[$orderedChars]).Add($w)


    # Keep running score of max number of anagrams seen
    if ($list.Count -gt $maxAnagramCount)
    {
        $maxAnagramCount = $list.Count
    }

}

foreach ($entry in $anagrams.GetEnumerator())
{
    if ($entry.Value.Count -eq $maxAnagramCount)
    {
        [string]::join('', $entry.Value)
    }
}
