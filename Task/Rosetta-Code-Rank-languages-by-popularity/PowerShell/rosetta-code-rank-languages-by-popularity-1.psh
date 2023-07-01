$get1 = (New-Object Net.WebClient).DownloadString("http://www.rosettacode.org/w/api.php?action=query&list=categorymembers&cmtitle=Category:Programming_Languages&cmlimit=700&format=json")
$get2 = (New-Object Net.WebClient).DownloadString("http://www.rosettacode.org/w/index.php?title=Special:Categories&limit=5000")
$match1 = [regex]::matches($get1, "`"title`":`"Category:(.+?)`"")
$match2 = [regex]::matches($get2, "title=`"Category:([^`"]+?)`">[^<]+?</a>[^\(]*\((\d+) members\)")
$r = 1
$langs = $match1 | foreach { $_.Groups[1].Value.Replace("\","") }
$res = $match2 | sort -Descending {[Int]$($_.Groups[2].Value)} | foreach {
    if ($langs.Contains($_.Groups[1].Value))
    {
        [pscustomobject]@{
            Rank = "$r"
            Members =  "$($_.Groups[2].Value)"
            Language = "$($_.Groups[1].Value)"
        }
        $r++
    }
}
1..30 | foreach{
    [pscustomobject]@{
        "Rank 1..30" = "$($_)"
        "Members 1..30" =  "$($res[$_-1].Members)"
        "Language 1..30" = "$($res[$_-1].Language)"
        "Rank 31..60" = "$($_+30)"
        "Members 31..60" =  "$($res[$_+30].Members)"
        "Language 31..60" = "$($res[$_+30].Language)"
    }
}| Format-Table -AutoSize
