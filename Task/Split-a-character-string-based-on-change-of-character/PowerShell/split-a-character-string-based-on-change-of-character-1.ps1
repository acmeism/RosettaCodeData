function Split-String ([string]$String)
{
    [string]$c = $String.Substring(0,1)
    [string]$splitString = $c

    for ($i = 1; $i -lt $String.Length; $i++)
    {
        [string]$d = $String.Substring($i,1)

        if ($d -ne $c)
        {
            $splitString += ", "
            $c = $d
        }

        $splitString += $d
    }

    $splitString
}
