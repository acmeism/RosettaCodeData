function Test-FileLock
{
    Param
    (
        [parameter(Mandatory=$true)]
        [string]
        $Path
    )

    $outFile = New-Object System.IO.FileInfo $Path

    if (-not(Test-Path -Path $Path))
    {
        return $false
    }

    try
    {
        $outStream = $outFile.Open([System.IO.FileMode]::Open, [System.IO.FileAccess]::ReadWrite, [System.IO.FileShare]::None)

        if ($outStream)
        {
            $outStream.Close()
        }

        return $false
    }
    catch
    {
        # File is locked by a process.
        return $true
    }
}

function New-Record
{
    Param
    (
        [string]$Account,
        [string]$Password,
        [int]$UID,
        [int]$GID,
        [string]$FullName,
        [string]$Office,
        [string]$Extension,
        [string]$HomePhone,
        [string]$Email,
        [string]$Directory,
        [string]$Shell
    )

    $GECOS = [PSCustomObject]@{
        FullName  = $FullName
        Office    = $Office
        Extension = $Extension
        HomePhone = $HomePhone
        Email     = $Email
    }

    [PSCustomObject]@{
        Account   = $Account
        Password  = $Password
        UID       = $UID
        GID       = $GID
        GECOS     = $GECOS
        Directory = $Directory
        Shell     = $Shell
    }
}


function Import-File
{
    Param
    (
        [Parameter(Mandatory=$false,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [string]
        $Path = ".\passwd.txt"
    )

    if (-not(Test-Path $Path))
    {
        throw [System.IO.FileNotFoundException]
    }

    $header = "Account","Password","UID","GID","GECOS","Directory","Shell"

    $csv = Import-Csv -Path $Path -Delimiter ":" -Header $header -Encoding ASCII
    $csv | ForEach-Object {
        New-Record -Account   $_.Account `
                   -Password  $_.Password `
                   -UID       $_.UID `
                   -GID       $_.GID `
                   -FullName  $_.GECOS.Split(",")[0] `
                   -Office    $_.GECOS.Split(",")[1] `
                   -Extension $_.GECOS.Split(",")[2] `
                   -HomePhone $_.GECOS.Split(",")[3] `
                   -Email     $_.GECOS.Split(",")[4] `
                   -Directory $_.Directory `
                   -Shell     $_.Shell
    }
}


function Export-File
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true)]
        $InputObject,

        [Parameter(Mandatory=$false,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [string]
        $Path = ".\passwd.txt"
    )

    Begin
    {
        if (-not(Test-Path $Path))
        {
            New-Item -Path . -Name $Path -ItemType File | Out-Null
        }

        [string]$recordString = "{0}:{1}:{2}:{3}:{4}:{5}:{6}"
        [string]$gecosString  = "{0},{1},{2},{3},{4}"
        [string[]]$lines = @()
        [string[]]$file  = Get-Content $Path
    }
    Process
    {
        foreach ($object in $InputObject)
        {
            $lines += $recordString -f $object.Account,
                                       $object.Password,
                                       $object.UID,
                                       $object.GID,
                                       $($gecosString -f $object.GECOS.FullName,
                                                         $object.GECOS.Office,
                                                         $object.GECOS.Extension,
                                                         $object.GECOS.HomePhone,
                                                         $object.GECOS.Email),
                                       $object.Directory,
                                       $object.Shell
        }
    }
    End
    {
        foreach ($line in $lines)
        {
            if (-not ($line -in $file))
            {
                $line | Out-File -FilePath $Path -Encoding ASCII -Append
            }
        }
    }
}
