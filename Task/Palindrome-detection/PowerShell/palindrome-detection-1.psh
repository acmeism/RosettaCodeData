Function Test-Palindrome( [String] $Text ){
    $CharArray = $Text.ToCharArray()
    [Array]::Reverse($CharArray)
    $Text -eq [string]::join('', $CharArray)
}
