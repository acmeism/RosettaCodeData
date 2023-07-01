function Invoke-Subleq ([int[]]$Program)
{
    [int]$ip, [string]$output = $null

    try
    {
        while ($ip -ge 0)
        {
            if ($Program[$ip] -eq -1)
            {
                $Program[$Program[$ip + 1]] = [int](Read-Host -Prompt SUBLEQ)[0]
            }
            elseif ($Program[$ip + 1] -eq -1)
            {
                $output += "$([char]$Program[$Program[$ip]])"
            }
            else
            {
                $Program[$Program[$ip + 1]] -= $Program[$Program[$ip]]

                if ($Program[$Program[$ip + 1]] -le 0)
                {
                    $ip = $Program[$ip + 2]
                    continue
                }
            }

            $ip += 3
        }

        return $output
    }
    catch [IndexOutOfRangeException],[Exception]
    {
        Write-Host "$($Error[0].Exception.Message)" -ForegroundColor Red
    }
}
