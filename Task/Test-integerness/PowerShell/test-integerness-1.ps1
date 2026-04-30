function Test-Integer ($Number)
{
    try
    {
        $Number = [System.Numerics.Complex]$Number

        if (($Number.Real -eq [int]$Number.Real) -and ($Number.Imaginary -eq 0))
        {
            return $true
        }
        else
        {
            return $false
        }
    }
    catch
    {
        Write-Host "Parameter was not a number."
    }
}
