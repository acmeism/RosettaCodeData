function Get-Hash
{
    [CmdletBinding(DefaultParameterSetName="String")]
    [OutputType([string])]
    Param
    (
        [Parameter(Mandatory=$true,
                   ParameterSetName="String",
                   Position=0)]
        [string]
        $String,

        [Parameter(Mandatory=$true,
                   ParameterSetName="FileName",
                   Position=0)]
        [string]
        $FileName,

        [Parameter(Mandatory=$false,
                   Position=1)]
        [ValidateSet("MD5", "RIPEMD160", "SHA1", "SHA256", "SHA384", "SHA512")]
        [string]
        $HashType = "MD5"
    )

    $hashAlgorithm = [System.Security.Cryptography.HashAlgorithm]
    $stringBuilder = New-Object -TypeName System.Text.StringBuilder

    switch ($PSCmdlet.ParameterSetName)
    {
        "String"
        {
	    $hashAlgorithm::Create($HashType).ComputeHash([System.Text.Encoding]::UTF8.GetBytes($String)) | ForEach-Object {
	        $stringBuilder.Append($_.ToString("x2")) | Out-Null
	    }
        }
        "FileName"
        {
            $fileStream = New-Object -TypeName System.IO.FileStream -ArgumentList $FileName, ([System.IO.FileMode]::Open)

	    $hashAlgorithm::Create($HashType).ComputeHash($fileStream) | ForEach-Object {
	        $stringBuilder.Append($_.ToString("x2")) | Out-Null
	    }

	    $fileStream.Close()
	    $fileStream.Dispose()
        }
    }

    $stringBuilder.ToString()
}
