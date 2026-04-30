function Get-RandomInteger
{
    Param
    (
        [Parameter(Mandatory=$false,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [ValidateScript({$_ -ge 4})]
        [int[]]
        $InputObject = 64
    )

    Begin
    {
        $rng = New-Object -TypeName System.Security.Cryptography.RNGCryptoServiceProvider
    }
    Process
    {
        foreach($count in $InputObject)
        {
            $bytes = New-Object -TypeName Byte[] -Argument $count
            $rng.GetBytes($bytes)
            [System.BitConverter]::ToInt32($bytes,0)
        }
    }
    End
    {
        Remove-Variable -Name rng -Scope Local
    }
}
