function Select-PerniciousNumber
{
    [CmdletBinding()]
    [OutputType([int])]
    Param
    (
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $InputObject
    )

    Begin
    {
        function Test-Prime ([int]$n)
        {
            $n = [Math]::Abs($n)

            if ($n -eq 0 -or $n -eq 1) {return $false}

            for ($m = 2; $m -le [Math]::Sqrt($n); $m++)
            {
                if (($n % $m) -eq 0) {return $false}
            }

            return $true
        }

        [scriptblock]$popCount = {(([Convert]::ToString($this, 2)).ToCharArray() | Where-Object {$_ -eq '1'}).Count}
    }
    Process
    {
        foreach ($object in $InputObject)
        {
            $object | Add-Member -MemberType ScriptProperty -Name PopCount -Value $popCount -Force -PassThru | ForEach-Object {
                if (Test-Prime $_.PopCount)
                {
                    $_
                }
            }
        }
    }
}
