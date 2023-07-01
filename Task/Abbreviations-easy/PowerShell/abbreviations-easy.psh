<# Start with a string of the commands #>
$cmdTableStr =
"Add ALTer  BAckup Bottom  CAppend Change SCHANGE  CInsert CLAst COMPress COpy
 COUnt COVerlay CURsor DELete CDelete Down DUPlicate Xedit EXPand EXTract Find
 NFind NFINDUp NFUp CFind FINdup FUp FOrward GET Help HEXType Input POWerinput
 Join SPlit SPLTJOIN  LOAD  Locate CLocate  LOWercase UPPercase  LPrefix MACRO
 MErge MODify MOve MSG Next Overlay PARSE PREServe PURge PUT PUTD  Query  QUIT
 READ  RECover REFRESH RENum REPeat  Replace CReplace  RESet  RESTore  RGTLEFT
 RIght LEft  SAVE  SET SHift SI  SORT  SOS  STAck STATus  TOP TRAnsfer Type Up"
<# String of inputs #>
$userWordStr = "riG   rePEAT copies  put mo   rest    types   fup.    6       poweRin"

$outputStr = $null # Set this string to null only so all variables are intialized

$cmdTabArray = @() # Arrays for the commands and the inputs
$userWordArray = @()

<# Split the strings into arrays using a space as the delimiter.
   This also removes "blank" entries, which fits the requirement
   "A blank input (or a null input) should return a null string." #>
$cmdTabArray = $cmdTableStr.Split(" ", [System.StringSplitOptions]::RemoveEmptyEntries)
$userWordArray = $userWordStr.Split(" ", [System.StringSplitOptions]::RemoveEmptyEntries)

<# Begins a loop to iterate through the inputs #>
foreach($word in $userWordArray)
{
    $match = $false # Variable set to false so that if a match is never found, the "*error*" string can be appended
    foreach($cmd in $cmdTabArray)
    {
        <# This test: 1) ensures inputs match the leading characters of the command
                      2) are abbreviations of the command
                      3) the abbreviations is at least the number of capital characters in the command #>
        if($cmd -like "$word*" -and ($word.Length -ge ($cmd -creplace '[a-z]').Length))
        {
            $outputStr += $cmd.ToUpper() + " " # Adds the command in all caps to the output string
            $match = $true # Sets the variable so that "*error*" is not appended
            break # Break keep the loop from continuing and wasting time once a match was found
        }
    }
    if($match -eq $false){ $outputStr += "*error* " } # Appends error if no match was found
}
# Below lines display the input and output
"User text: " + $userWordStr
"Full text: " + $outputStr
