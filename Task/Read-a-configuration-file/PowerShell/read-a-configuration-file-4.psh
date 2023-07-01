Function Read-ConfigurationFile {
   [CmdletBinding()]
   [OutputType([Collections.Specialized.OrderedDictionary])]
   Param (
   [Parameter(
      Mandatory=$true,
      Position=0
      )
   ]
   [Alias('LiteralPath')]
   [ValidateScript({
      Test-Path -LiteralPath $PSItem -PathType 'Leaf'
      })
   ]
   [String]
   $_LiteralPath
   )

   Begin {
      Function Houdini-Value ([String]$_Text) {
         $__Aux = $_Text.Trim()
         If ($__Aux.Length -eq 0) {
            $__Aux = $true
         } ElseIf ($__Aux.Contains(',')) {
            $__Aux = $__Aux.Split(',') |
               ForEach-Object {
                  If ($PSItem.Trim().Length -ne 0) {
                     $PSItem.Trim()
                  }
               }
         }
         Return $__Aux
      }
   }

   Process {
      $__Configuration = [Ordered]@{}
      # Config equivalent pattern
      # Select-String -Pattern '^\s*[^\s;#=]+.*\s*$' -LiteralPath '.\filename.cfg'
      Switch -Regex -File $_LiteralPath {

         '^\s*[;#=]|^\s*$'  {
            Write-Verbose -Message "v$(' '*20)ignored"
            Write-Verbose -Message $Matches[0]
            Continue
         }

         '^([^=]+)=(.*)$' {
            Write-Verbose -Message '↓← ← ← ← ← ← ← ← ← ← equal pattern'
            Write-Verbose -Message $Matches[0]
            $__Name,$__Value = $Matches[1..2]
            $__Configuration[$__Name.Trim()] = Houdini-Value($__Value)
            Continue
         }

         '^\s*([^\s;#=]+)(.*)(\s*)$' {
            Write-Verbose -Message '↓← ← ← ← ← ← ← ← ← ← space or tab pattern or only name'
            Write-Verbose -Message $Matches[0]
            $__Name,$__Value = $Matches[1..2]
            $__Configuration[$__Name.Trim()] = Houdini-Value($__Value)
            Continue
         }

      }
      Return $__Configuration
   }
}

Function Show-Value ([Collections.Specialized.OrderedDictionary]$_Dictionary, $_Index, $_SubIndex) {
   $__Aux = $_Index + ' = '
   If ($_Dictionary[$_Index] -eq $null) {
      $__Aux += $false
   } ElseIf ($_Dictionary[$_Index].Count -gt 1) {
      If ($_SubIndex -eq $null) {
         $__Aux += $_Dictionary[$_Index] -join ','
      } Else {
         $__Aux = $_Index + '(' + $_SubIndex + ') = '
         If ($_Dictionary[$_Index][$_SubIndex] -eq $null) {
            $__Aux += $false		
         } Else {
            $__Aux += $_Dictionary[$_Index][$_SubIndex]
         }
      }
   } Else {
      $__Aux += $_Dictionary[$_Index]
   }
   Return $__Aux
}
