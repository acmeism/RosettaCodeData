Function Test-Pangram ( [string]$Text, [string]$Alphabet = 'abcdefghijklmnopqrstuvwxyz' )
{
    $alSet   = [Collections.Generic.HashSet[char]]::new($Alphabet.ToLower())
    $textSet = [Collections.Generic.HashSet[char]]::new($Text.ToLower())

    $alSet.ExceptWith($textSet)    # remove text chars from the alphabet

    return $alSet.Count -eq 0    # any alphabet letters still remaining?
}
