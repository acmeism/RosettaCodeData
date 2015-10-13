# Converts Microsoft .NET Framework objects into HTML that can be displayed in a Web browser.
ConvertTo-Html -inputobject (Get-Date)

# Create a PowerShell object using a HashTable
$object = [PSCustomObject]@{
        'A'=(Get-Random -Minimum 0 -Maximum 10);
        'B'=(Get-Random -Minimum 0 -Maximum 10);
        'C'=(Get-Random -Minimum 0 -Maximum 10)}

$object | ConvertTo-Html
