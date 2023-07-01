function frequency ($string) {
    $arr = $string.ToUpper().ToCharArray() |where{$_ -match '[A-KL-Z]'}
    $n = $arr.count
    $arr | group | foreach{
        [pscustomobject]@{letter = "$($_.name)"; frequency  = "$([math]::round($($_.Count/$n),5))"; count = "$($_.count)"}
    } | sort letter
}
$file = "$($MyInvocation.MyCommand.Name )" #Put the name of your file here
frequency $(get-content $file -Raw)
