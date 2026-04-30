Function Calculate-SHA1( $String ){
    $Enc = [system.Text.Encoding]::UTF8
    $Data = $enc.GetBytes($String)

    # Create a New SHA1 Crypto Provider
    $Sha = New-Object System.Security.Cryptography.SHA1CryptoServiceProvider

    # Now hash and display results
    $Result = $sha.ComputeHash($Data)
    [System.Convert]::ToBase64String($Result)
}
