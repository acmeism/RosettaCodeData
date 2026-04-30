# Create an Array by separating the elements with commas:
$array = "one", 2, "three", 4

# Using explicit syntax:
$array = @("one", 2, "three", 4)

# Send the values back into individual variables:
$var1, $var2, $var3, $var4 = $array

# An array of several integer ([int]) values:
$array = 0, 1, 2, 3, 4, 5, 6, 7

# Using the range operator (..):
$array = 0..7

# Strongly typed:
[int[]] $stronglyTypedArray = 1, 2, 4, 8, 16, 32, 64, 128

# An empty array:
$array = @()

# An array with a single element:
$array = @("one")

# I suppose this would be a jagged array:
$jaggedArray = @((11, 12, 13),
                 (21, 22, 23),
                 (31, 32, 33))

$jaggedArray | Format-Wide {$_} -Column 3 -Force

$jaggedArray[1][1] # returns 22

# A Multi-dimensional array:
$multiArray = New-Object -TypeName "System.Object[,]" -ArgumentList 6,6

for ($i = 0; $i -lt 6; $i++)
{
    for ($j = 0; $j -lt 6; $j++)
    {
        $multiArray[$i,$j] = ($i + 1) * 10 + ($j + 1)
    }
}

$multiArray | Format-Wide {$_} -Column 6 -Force

$multiArray[2,2] # returns 33
