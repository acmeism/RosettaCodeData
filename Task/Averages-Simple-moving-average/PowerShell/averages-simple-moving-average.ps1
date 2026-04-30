#This version allows a user to enter numbers one at a time to figure this into the SMA calculations

$inputs = @() #Create an array to hold all inputs as they are entered.
$period1 = 3 #Define the periods you want to utilize
$period2 = 5

Write-host "Enter numbers to observe their moving averages." -ForegroundColor Green

function getSMA ($inputs, [int]$period) #Function takes a array of entered values and a period (3 and 5 in this case)
{
    if($inputs.Count -lt $period){$period = $inputs.Count} #Makes sure that if there's less numbers than the designated period (3 in this case), the number of availble values is used as the period instead.

    for($count = 0; $count -lt $period; $count++) #Loop sums the latest available values
    {
        $result += $inputs[($inputs.Count) - $count - 1]
    }

    return ($result | ForEach-Object -begin {$sum=0 }-process {$sum+=$_} -end {$sum/$period}) #Gets the average for a given period
}

while($true) #Infinite loop so the user can keep entering numbers
{
    try{$inputs += [decimal] (Read-Host)}catch{Write-Host "Enter only numbers" -ForegroundColor Red} #Enter the numbers. Error checking to help mitigate bad inputs (non-number values)

    "Added " + $inputs[(($inputs.Count) - 1)] + ", sma($period1) = " + (getSMA $inputs $Period1) + ", sma($period2) = " + (getSMA $inputs $period2)
}
