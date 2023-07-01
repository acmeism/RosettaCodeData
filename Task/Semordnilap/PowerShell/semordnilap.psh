function Reverse-String ([string]$String)
{
    [char[]]$output = $String.ToCharArray()
    [Array]::Reverse($output)
    $output -join ""
}

[string]$url = "http://www.puzzlers.org/pub/wordlists/unixdict.txt"
[string]$out = ".\unixdict.txt"

(New-Object System.Net.WebClient).DownloadFile($url, $out)

[string[]]$file = Get-Content -Path $out

[hashtable]$unixDict    = @{}
[hashtable]$semordnilap = @{}

foreach ($line in $file)
{
    if ($line.Length -gt 1)
    {
        $unixDict.Add($line,"")
    }

    [string]$reverseLine = Reverse-String $line

    if ($reverseLine -notmatch $line -and $unixDict.ContainsKey($reverseLine))
    {
        $semordnilap.Add($line,$reverseLine)
    }
}

$semordnilap

"`nSemordnilap count: {0}" -f ($semordnilap.GetEnumerator() | Measure-Object).Count
