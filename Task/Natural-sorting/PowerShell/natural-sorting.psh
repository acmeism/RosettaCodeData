# six sorting
$Discard = '^a ', '^an ', '^the '
$List =
   'ignore leading spaces: 2-2<==',
   ' ignore leading spaces: 2-1 <==',
   '  ignore leading spaces: 2+0  <==',
   '   ignore leading spaces: 2+1   <==',
   'ignore m.a.s spaces: 2-2<==',
   'ignore m.a.s  spaces: 2-1<==',
   'ignore m.a.s   spaces: 2+0<==',
   'ignore m.a.s    spaces: 2+1<==',
   'Equiv. spaces: 3-3<==',
   "Equiv.`rspaces: 3-2<==",
   "Equiv.`fspaces: 3-1<==",
   "Equiv.`vspaces: 3+0<==",
   "Equiv.`nspaces: 3+1<==",
   "Equiv.`tspaces: 3+2<==",
   'cASE INDEPENDENT: 3-2<==',
   'caSE INDEPENDENT: 3-1<==',
   'casE INDEPENDENT: 3+0<==',
   'case INDEPENDENT: 3+1<==',
   'Lâmpada accented characters<==',
   'Lúdico accented characters<==',
   '     Lula    Free   !!! accented characters<==',
   'Amanda accented characters<==',
   'Ágata accented characters<==',
   'Ångström accented characters<==',
   'Ângela accented characters<==',
   'À toa accented characters<==',
   'ânsia accented characters<==',
   'álibi accented characters<==',
   'foo100bar99baz0.txt<==',
   'foo100bar10baz0.txt<==',
   'foo1000bar99baz10.txt<==',
   'foo1000bar99baz9.txt<==',
   'The Wind in the Willows<==',
   'The 40th step more<==',
   'The 39 steps<==',
   'Wanda<=='

'List index sorting'
$List
' '
'Lexicographically sorting'
$List | Sort-Object
' '
'Natural sorting'
$List | Sort-Object -Property {
   [Regex]::Replace(
      (
         (
            & {
               If ($_.Trim() -match ($Discard -join '|')) {
                  $_ -replace '^\s*[^\s]+\s*'
               } Else {
                  $_.Trim()
               }
            }
         ) -replace '\s+'
      ), '\d+', { $args[0].Value.PadLeft(20) }
   )
}
