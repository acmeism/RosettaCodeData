<#
.Synopsis
   Creates a new "Deck" which is a hashtable converted to a dictionary
   This is only used for creating the deck, to view/list the deck contents use Get-Deck.
.DESCRIPTION
   Casts the string value that the user inputs to the name of the variable that holds the "deck"
   Creates a global variable, allowing you to use the name you choose in other functions and allows you to create
   multiple decks under different names.
.EXAMPLE
    PS C:\WINDOWS\system32> New-Deck
    cmdlet New-Deck at command pipeline position 1
    Supply values for the following parameters:
    YourDeckName: Deck1

    PS C:\WINDOWS\system32>

.EXAMPLE
   PS C:\WINDOWS\system32> New-Deck -YourDeckName Deck2

    PS C:\WINDOWS\system32>

.EXAMPLE
     PS C:\WINDOWS\system32> New-Deck -YourDeckName Deck2

    PS C:\WINDOWS\system32> New-Deck -YourDeckName Deck3

    PS C:\WINDOWS\system32>
#>
function New-Deck
{
    [CmdletBinding()]
    [OutputType([int])]
    Param
    (
        # Name your Deck, this will be the name of the variable that holds your deck
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$False,
                   Position=0)]$YourDeckName
    )

    Begin
    {
        $Suit = @(' of Hearts', ' of Spades', ' of Diamonds', ' of Clubs')
        $Pip = @('Ace', 'King', 'Queen',  'Jack', '10', '9', '8', '7', '6', '5', '4', '3', '2')

        #Creates the hash table that will hold the suit and pip variables
        $Deck = @{}

        #creates counters for the loop below to make 52 total cards with 13 cards per suit
        [int]$SuitCounter = 0
        [int]$PipCounter = 0
        [int]$CardValue = 0

    }
    Process
    {
        #Creates the initial deck
        do
        {
            #card2add is the rows in the hashtable
            $Card2Add = ($Pip[$PipCounter]+$Suit[$SuitCounter])

            #Addes the row to the hashtable
            $Deck.Add($CardValue, $Card2Add)

            #Used to create the Keys
            $CardValue++

            #Counts the amount of cards per suit
            $PipCounter ++
                if ($PipCounter -eq 13)
                {
                    #once reached the suit is changed
                    $SuitCounter++
                    #and the per-suit counter is reset
                    $PipCounter = 0
                }
                else
                {
                    continue
                }
        }
        #52 cards in a deck
        until ($Deck.count -eq 52)

    }
    End
    {
        #sets the name of a variable that is unknown
        #Then converts the hash table to a dictionary and pipes it to the Get-Random cmdlet with the arguments to randomize the contents
        Set-Variable -Name "$YourDeckName" -Value ($Deck.GetEnumerator() | Get-Random -Count ([int]::MaxValue)) -Scope Global
}
}

<#
.Synopsis
   Lists the cards in your selected deck
.DESCRIPTION
   Contains a Try-Catch-Finally block in case the deck requested has not been created
.EXAMPLE
    PS C:\WINDOWS\system32> Get-Deck -YourDeckName deck1

    8 of Clubs
    5 of Hearts
    --Shortened--
    King of Clubs
    Jack of Diamonds

    PS C:\WINDOWS\system32>


.EXAMPLE
    PS C:\WINDOWS\system32> Get-Deck -YourDeckName deck2

    deck2 does not exist...
    Creating Deck deck2...

    Ace of Spades
    10 of Hearts
    --Shortened--
    5 of Clubs
    4 of Clubs

    PS C:\WINDOWS\system32>

.EXAMPLE
    PS C:\WINDOWS\system32> deck deck2

    Ace of Spades
    10 of Hearts
    --Shortened--
    4 of Spades
    6 of Spades
    Queen of Spades


    PS C:\WINDOWS\system32>
#>
function Get-Deck
{
    [CmdletBinding()]
    [Alias('Deck')]
    [OutputType([int])]
    Param
    (
        #Brings the Vairiable in from Get-Deck
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]$YourDeckName
    )

    Begin
    {

    }
    Process
    {
        # Will return a terminal error if the deck has not been created
        try
        {
            $temp = Get-Variable -name "$YourDeckName" -ValueOnly -ErrorAction stop
        }
        catch
        {
            Write-Host
            Write-Host "$YourDeckName does not exist..."
            Write-Host "Creating Deck $YourDeckName..."
            New-Deck -YourDeckName $YourDeckName
            $temp = Get-Variable -name "$YourDeckName" -ValueOnly
        }

        finally
        {
            $temp | select Value | ft -HideTableHeaders
        }

    }
    End
    {
        Write-Verbose "End of show-deck function"
    }
}

<#
.Synopsis
   Shuffles a deck of your selection with Get-Random
.DESCRIPTION
   This function can be used to Shuffle any deck that has been created.
   This can be used on a deck that has less than 52 cards
   Contains a Try-Catch-Finally block in case the deck requested has not been created
   Does NOT output the value of the deck being shuffled (You wouldn't look at the cards you shuffled, would you?)

.EXAMPLE
    PS C:\WINDOWS\system32> Shuffle-Deck -YourDeckName Deck1
    Your Deck was shuffled

    PS C:\WINDOWS\system32>

.EXAMPLE
    PS C:\WINDOWS\system32> Shuffle NotMadeYet

    NotMadeYet does not exist...
    Creating and shuffling NotMadeYet...
    Your Deck was shuffled

    PS C:\WINDOWS\system32>
#>
function Shuffle-Deck
{
    [CmdletBinding()]
    [Alias('Shuffle')]
    [OutputType([int])]
    Param
    (
        #The Deck you want to shuffle
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]$YourDeckName)

    Begin
    {
        Write-Verbose 'Shuffles your deck with Get-Random'
    }
    Process
    {
        # Will return a missing variable error if the deck has net been created
        try
        {
            #These two commands could be on one line using the pipeline, but look cleaner on two
            $temp1 = Get-Variable -name "$YourDeckName" -ValueOnly -ErrorAction stop
            $temp1 = $temp1 | Get-Random -Count ([int]::MaxValue)
        }
        catch
        {
            Write-Host
            Write-Host "$YourDeckName does not exist..."
            Write-Host "Creating and shuffling $YourDeckName..."
            New-Deck -YourDeckName $YourDeckName
            $temp1 = Get-Variable -name "$YourDeckName" -ValueOnly
            $temp1 = $temp1 | Get-Random -Count ([int]::MaxValue)

        }

        finally
        {
            #Gets the actual value of variable $YourDeckName from the New-Deck function and uses that string value
            #to set the variables name
            Set-Variable -Name "$YourDeckName" -value ($temp1) -Scope Global
        }
    }
    End
    {
        Write-Host "Your Deck was shuffled"
    }
}

<#
.Synopsis
   Creates a new "Hand" which is a hashtable converted to a dictionary
   This is only used for creating the hand, to view/list the deck contents use Get-Hand.
.DESCRIPTION
   Casts the string value that the user inputs to the name of the variable that holds the "hand"
   Creates a global variable, allowing you to use the name you choose in other functions and allows you to create
   multiple hands under different names.
.EXAMPLE
    PS C:\WINDOWS\system32> New-Hand -YourHandName JohnDoe

    PS C:\WINDOWS\system32>
.EXAMPLE
    PS C:\WINDOWS\system32> New-Hand JaneDoe

    PS C:\WINDOWS\system32>
>
#>
function New-Hand
{
    [CmdletBinding()]
    [OutputType([int])]
    Param
    (
        # Name your Deck, this will be the name of the variable that holds your deck
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$False,
                   Position=0)]$YourHandName
    )

    Begin
    {
        $Hand = @{}
    }
    Process
    {
    }

    End
    {
        Set-Variable -Name "$YourHandName" -Value ($Hand.GetEnumerator()) -Scope Global
}
}

<#
.Synopsis
   Lists the cards in the selected Hand
.DESCRIPTION
   Contains a Try-Catch-Finally block in case the hand requested has not been created
.EXAMPLE
    #create a new hand
    PS C:\WINDOWS\system32> New-Hand -YourHandName Hand1

    PS C:\WINDOWS\system32> Get-Hand -YourHandName Hand1
    Hand1's hand contains  cards, they are...

    PS C:\WINDOWS\system32>
    #This hand is empty
.EXAMPLE
    PS C:\WINDOWS\system32> Get-Hand -YourHandName Hand2

    Hand2 does not exist...
    Creating Hand Hand2...
    Hand2's hand contains  cards, they are...

    PS C:\WINDOWS\system32>

.EXAMPLE
    PS C:\WINDOWS\system32> hand hand3
    hand3's hand contains 4 cards, they are...

    5 of Spades
    4 of Spades
    6 of Spades
    Queen of Diamonds
#>
function Get-Hand
{
    [CmdletBinding()]
    [Alias('Hand')]
    [OutputType([int])]
    Param
    (
        #Brings the Vairiable in from Get-Deck
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]$YourHandName
    )
    Begin
    {
    }
    Process
    {
        # Will return a missing variable error if the deck has net been created
        try
        {
            $temp = Get-Variable -name "$YourHandName" -ValueOnly -ErrorAction stop
        }
        catch
        {
            Write-Host
            Write-Host "$YourHandName does not exist..."
            Write-Host "Creating Hand $YourHandName..."
            New-Hand -YourHandName $YourHandName
            $temp = Get-Variable -name "$YourHandName" -ValueOnly
        }

        finally
        {
            $count = $temp.count
            Write-Host "$YourHandName's hand contains $count cards, they are..."
            $temp | select Value | ft -HideTableHeaders
        }

    }
    End
    {
        Write-Verbose "End of show-deck function"
    }
}

<#
.Synopsis
   Draws/returns cards
.DESCRIPTION
   Draws/returns cards from your chosen deck , to your chosen hand
   Can be used without creating a deck or hand first
.EXAMPLE
    PS C:\WINDOWS\system32> DrawFrom-Deck -YourDeckName Deck1 -YourHandName test1 -HowManyCardsToDraw 10



PS C:\WINDOWS\system32>
.EXAMPLE
DrawFrom-Deck -YourDeckName Deck2 -YourHandName test2 -HowManyCardsToDraw 10
Deck2 does not exist...
Creating Deck Deck2...

test2 does not exist...
Creating Hand test2...
test2's hand contains  cards, they are...



.EXAMPLE
    PS C:\WINDOWS\system32> draw -YourDeckName deck1 -YourHandName test1 -HowManyCardsToDraw 5



#>
function Draw-Deck
{
    [CmdletBinding()]
    [Alias('Draw')]
    [OutputType([int])]
    Param
    (
        # The Deck in which you want to draw cards out of
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]$YourDeckName,

        #The hand in which you want to draw cards to
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]$YourHandName,


        #Quanity of cards being drawn
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]$HowManyCardsToDraw

                   )
    Begin
    {
        Write-Verbose "Draws a chosen amount of cards from the chosen deck"

       #try-catch-finally blocks so the user does not have to use New-Deck and New-Hand beforehand.
       try
        {
            $temp = Get-Variable -name "$YourDeckName" -ValueOnly -ErrorAction Stop
        }
        catch
        {
            Get-Deck -YourDeckName $YourDeckName
            $temp = Get-Variable -name "$YourDeckName" -ValueOnly -ErrorAction Stop
        }
        finally
        {
            Write-Host
        }

        try
        {
            $temp2 = Get-Variable -name "$YourHandName" -ValueOnly -ErrorAction Stop
        }
        catch
        {
            Get-Hand -YourHandName $YourHandName
            $temp2 = Get-Variable -name "$YourHandName" -ValueOnly -ErrorAction Stop
        }
        finally
        {
            Write-Host
        }
    }

    Process
    {
        Write-Host "you drew $HowManyCardsToDraw cards, they are..."

        $handValues = Get-Variable -name "$YourDeckName" -ValueOnly
        $handValues = $handValues[0..(($HowManyCardsToDraw -1))] | select value | ft -HideTableHeaders
        $handValues

    }
    End
    {
        #sets the new values for the deck and the hand selected
        Set-Variable -Name "$YourDeckName" -value ($temp[$HowManyCardsToDraw..($temp.count)]) -Scope Global
        Set-Variable -Name "$YourHandName" -value ($temp2 + $handValues) -Scope Global
    }
}
