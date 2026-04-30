$http = New-Object System.Net.HttpListener
$http.Prefixes.Add("http://localhost:8080/")
$http.Start()
[string]$html = "<html><body>Goodbye, World!</body></html>"
try {
    while ($http.IsListening) {
        $context = $http.GetContext()
        if ($context.Request.HttpMethod -eq 'GET' -and $context.Request.RawUrl -eq '/') {
            $buffer = [System.Text.Encoding]::UTF8.GetBytes($html) # convert html to bytes
            $context.Response.ContentLength64 = $buffer.Length
            $context.Response.OutputStream.Write($buffer, 0, $buffer.Length) #stream to broswer
            $context.Response.OutputStream.Close() # close the response
        }
    }
} finally {
    # Executes when ctrl-c
    # Multiple attempts may be needed to get to this block
    $http.Stop()
    $http.Close()
}
