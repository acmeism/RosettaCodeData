$client = [Net.WebClient]::new()
# credentials of current user:
$client.Credentials = [Net.CredentialCache]::DefaultCredentials
# or specify credentials manually:
# $client.Credentials = [System.Net.NetworkCredential]::new("User", "Password")
$data = $client.DownloadString("https://example.com")
Write-Host $data
