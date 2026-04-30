# An empty Hash Table:
$hash = @{}

# A Hash table populated with some values:
$nfcCentralDivision = @{
    Packers = "Green Bay"
    Bears   = "Chicago"
    Lions   = "Detroit"
}

# Add items to a Hash Table:
$nfcCentralDivision.Add("Vikings","Minnesota")
$nfcCentralDivision.Add("Buccaneers","Tampa Bay")

# Remove an item from a Hash Table:
$nfcCentralDivision.Remove("Buccaneers")

# Searching for items
$nfcCentralDivision.ContainsKey("Packers")
$nfcCentralDivision.ContainsValue("Green Bay")

# A bad value...
$hash1 = @{
    One = 1
    Two = 3
}

# Edit an item in a Hash Table:
$hash1.Set_Item("Two",2)

# Combine Hash Tables:

$hash2 = @{
    Three = 3
    Four  = 4
}

$hash1 + $hash2

# Using the ([ordered]) accelerator the items in the Hash Table retain the order in which they were input:
$nfcCentralDivision = [ordered]@{
    Bears   = "Chicago"
    Lions   = "Detroit"
    Packers = "Green Bay"
    Vikings = "Minnesota"
}
