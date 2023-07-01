class Banana
{
# Properties
[string]$Color
[boolean]$Peeled

# Default constructor
Banana()
    {
    $This.Color = "Green"
    }

# Constructor
Banana( [boolean]$Peeled )
    {
    $This.Color = "Green"
    $This.Peeled = $Peeled
    }

# Method
Ripen()
    {
    If ( $This.Color -eq "Green" ) { $This.Color = "Yellow" }
    Else { $This.Color = "Brown" }
    }

# Method
[boolean] IsReadyToEat()
    {
    If ( $This.Color -eq "Yellow" -and $This.Peeled ) { return $True }
    Else { return $False }
    }
}
