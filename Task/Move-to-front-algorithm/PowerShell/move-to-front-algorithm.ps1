Function Test-MTF
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true,Position=0)]
        [string]$word,

        [Parameter(Mandatory=$false)]
        [string]$SymbolTable = 'abcdefghijklmnopqrstuvwxyz'
    )
    Begin
    {
        Function Encode
        {
            Param
            (
                [Parameter(Mandatory=$true,Position=0)]
                [string]$word,

                [Parameter(Mandatory=$false)]
                [string]$SymbolTable = 'abcdefghijklmnopqrstuvwxyz'
            )
            foreach ($letter in $word.ToCharArray())
            {
                $index = $SymbolTable.IndexOf($letter)

                $prop = [ordered]@{
                    Input = $letter
                    Output = [int]$index
                    SymbolTable = $SymbolTable
                }
                New-Object PSobject -Property $prop
                $SymbolTable = $SymbolTable.Remove($index,1).Insert(0,$letter)
            }
        }
        Function Decode
        {
            Param
            (
                [Parameter(Mandatory=$true,Position=0)]
                [int[]]$index,

                [Parameter(Mandatory=$false)]
                [string]$SymbolTable = 'abcdefghijklmnopqrstuvwxyz'
            )
            foreach ($i in $index)
            {
                #Write-host $i -ForegroundColor Red
                $letter = $SymbolTable.Chars($i)

                $prop = [ordered]@{
                    Input = $i
                    Output = $letter
                    SymbolTable = $SymbolTable
                }
                New-Object PSObject -Property $prop
                $SymbolTable = $SymbolTable.Remove($i,1).Insert(0,$letter)
            }
        }
    }
    Process
    {
        #Encoding
        Write-Host "Encoding $word" -NoNewline
        $Encoded = (Encode -word $word).output
        Write-Host -NoNewline ": $($Encoded -join ',')"

        #Decoding
        Write-Host "`nDecoding $($Encoded -join ',')" -NoNewline
        $Decoded = (Decode -index $Encoded).output -join ''
        Write-Host -NoNewline ": $Decoded`n"
    }
    End{}
}
