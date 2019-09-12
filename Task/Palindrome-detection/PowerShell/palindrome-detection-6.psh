Function Test-Palindrome {
[CmdletBinding()]
Param(
    [Parameter(ValueFromPipeline)]
    [string[]]$Text
)

process {
    :stringLoop foreach ($T in $Text)
    {
        # Normalize Unicode combining characters,
        # so character á compares the same as (a+combining accent)
        $T = $T.Normalize([Text.NormalizationForm]::FormC)

        # Remove anything from outside the Unicode category
        # "Letter from any language"
        $T = $T -replace '\P{L}', ''

        # Walk from each end of the string inwards,
        # comparing a char at a time.
        # Avoids string copy / reverse overheads.
        $Left, $Right = 0, [math]::Max(0, ($T.Length - 1))
        while ($Left -lt $Right)
        {
            if ($T[$Left] -ne $T[$Right])
            {
                # return early if string is not a palindrome
                [PSCustomObject]@{
                    Text = $T
                    IsPalindrome = $False
                }
                continue stringLoop
            }
            else
            {
                $Left++
                $Right--
            }
        }

        # made it to here, then string is a palindrome
        [PSCustomObject]@{
            Text = $T
            IsPalindrome = $True
        }

    }
}
}
'ánu-ná', 'nowt' | Test-Palindrome
