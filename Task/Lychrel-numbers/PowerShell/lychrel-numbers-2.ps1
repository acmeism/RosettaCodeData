$Upto = 10000
$IterationLimit = 500
$LychrelNumbers = Get-LychrelNumbers -Upto $Upto -IterationLimit $IterationLimit

"Searching N = 1 through $Upto with a maximum of $IterationLimit iterations"
"      Number of seed Lychrel numbers: " + $LychrelNumbers.Seeds.Count
"                Seed Lychrel numbers: " + ( $LychrelNumbers.Seeds -join ", " )
"   Number of related Lychrel numbers: " + $LychrelNumbers.Related.Count
"Number of palindrome Lychrel numbers: " + $LychrelNumbers.Palindromes.Count
"          Palindrome Lychrel numbers: " + ( $LychrelNumbers.Palindromes -join ", " )
