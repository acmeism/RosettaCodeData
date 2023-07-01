<#
.Synopsis
    Finds the deepest common directory path of files passed through the pipeline.
.Parameter File
    PowerShell file object.
#>
function Get-CommonPath {
[CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [System.IO.FileInfo] $File
    )
    process {
        # Get the current file's path list
        $PathList =  $File.FullName -split "\$([IO.Path]::DirectorySeparatorChar)"
        # Get the most common path list
        if ($CommonPathList) {
            $CommonPathList = (Compare-Object -ReferenceObject $CommonPathList -DifferenceObject $PathList -IncludeEqual `
                -ExcludeDifferent -SyncWindow 0).InputObject
        } else {
            $CommonPathList = $PathList
        }
    }
    end {
        $CommonPathList -join [IO.Path]::DirectorySeparatorChar
    }
}
