# JSON input is being stored in ordered hashtable.
# Ordered hashtable is available in PowerShell v3 and higher.
[ordered]@{ "foo"= 1; "bar"= 10, "apples" } | ConvertTo-Json

# ConvertFrom-Json converts a JSON-formatted string to a custom object.
# If you use the Invoke-RestMethod cmdlet there is not need for the ConvertFrom-Json cmdlet
Invoke-WebRequest -Uri "http://date.jsontest.com" | ConvertFrom-Json
