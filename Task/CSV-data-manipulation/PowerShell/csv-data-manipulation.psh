## Create a CSV file
@"
C1,C2,C3,C4,C5
1,5,9,13,17
2,6,10,14,18
3,7,11,15,19
4,8,12,16,20
"@ -split "`r`n" | Out-File -FilePath .\Temp.csv -Force

## Import each line of the CSV file into an array of PowerShell objects
$records = Import-Csv -Path .\Temp.csv

## Sum the values of the properties of each object
$sums = $records | ForEach-Object {
    [int]$sum = 0
    foreach ($field in $_.PSObject.Properties.Name)
    {
        $sum += $_.$field
    }
    $sum
}

## Add a column (Sum) and its value to each object in the array
$records = for ($i = 0; $i -lt $sums.Count; $i++)
{
    $records[$i] | Select-Object *,@{Name='Sum';Expression={$sums[$i]}}
}

## Export the array of modified objects to the CSV file
$records | Export-Csv -Path .\Temp.csv -Force

## Display the object in tabular form
$records | Format-Table -AutoSize
