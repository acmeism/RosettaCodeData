$webClient = [Net.WebClient]::new()
$webClient.Headers.Add("User-Agent: Other") # so the server would not return error 403
$bytes = $webClient.DownloadData('http://rosettacode.org/favicon.ico')

$output = [Convert]::ToBase64String($bytes)

$output
