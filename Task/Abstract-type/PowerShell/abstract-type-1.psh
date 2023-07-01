#Requires -Version 5.0

Class Player
{
  <#
    Properties: Name, Team, Position and Number
  #>
    [string]$Name

    [ValidateSet("Baltimore Ravens","Cincinnati Bengals","Cleveland Browns","Pittsburgh Steelers",
                 "Chicago Bears","Detroit Lions","Green Bay Packers","Minnesota Vikings",
                 "Houston Texans","Indianapolis Colts","Jacksonville Jaguars","Tennessee Titans",
                 "Atlanta Falcons","Carolina Panthers","New Orleans Saints","Tampa Bay Buccaneers",
                 "Buffalo Bills","Miami Dolphins","New England Patriots","New York Jets",
                 "Dallas Cowboys","New York Giants","Philadelphia Eagles","Washington Redskins",
                 "Denver Broncos","Kansas City Chiefs","Oakland Raiders","San Diego Chargers",
                 "Arizona Cardinals","Los Angeles Rams","San Francisco 49ers","Seattle Seahawks")]
    [string]$Team

    [ValidateSet("C","G","T","QB","RB","WR","TE","DT","DE","ILB","OLB","CB","S","K","H","LS","P","KOS","R")]
    [string]$Position

    [ValidateRange(0,99)]
    [int]$Number

  <#
    Constructor: Creates a new Player object, with the specified Name, Team, Position and Number.
  #>
    Player([string]$Name, [string]$Team, [string]$Position, [int]$Number)
    {
        $this.Name     = (Get-Culture).TextInfo.ToTitleCase("$Name")
        $this.Team     = (Get-Culture).TextInfo.ToTitleCase("$Team")
        $this.Position = $Position.ToUpper()
        $this.Number   = $Number
    }

  <#
    Methods: Trade the player to a different team (optional parameters for methods in PowerShell 5 classes are not available.  Boo!!)
             An overloaded method is a method with the same name as another method but in a different context,
             in this case with different parameters.
  #>
    Trade([string]$NewTeam)
    {
        [string[]]$league = "Baltimore Ravens","Cincinnati Bengals","Cleveland Browns","Pittsburgh Steelers",
                            "Chicago Bears","Detroit Lions","Green Bay Packers","Minnesota Vikings",
                            "Houston Texans","Indianapolis Colts","Jacksonville Jaguars","Tennessee Titans",
                            "Atlanta Falcons","Carolina Panthers","New Orleans Saints","Tampa Bay Buccaneers",
                            "Buffalo Bills","Miami Dolphins","New England Patriots","New York Jets",
                            "Dallas Cowboys","New York Giants","Philadelphia Eagles","Washington Redskins",
                            "Denver Broncos","Kansas City Chiefs","Oakland Raiders","San Diego Chargers",
                            "Arizona Cardinals","Los Angeles Rams","San Francisco 49ers","Seattle Seahawks"

        if ($NewTeam -in $league | Where-Object {$_ -notmatch $this.Team})
        {
            $this.Team = (Get-Culture).TextInfo.ToTitleCase("$NewTeam")
        }
        else
        {
            throw "Invalid Team"
        }
    }

    Trade([string]$NewTeam, [int]$NewNumber)
    {
        [string[]]$league = "Baltimore Ravens","Cincinnati Bengals","Cleveland Browns","Pittsburgh Steelers",
                            "Chicago Bears","Detroit Lions","Green Bay Packers","Minnesota Vikings",
                            "Houston Texans","Indianapolis Colts","Jacksonville Jaguars","Tennessee Titans",
                            "Atlanta Falcons","Carolina Panthers","New Orleans Saints","Tampa Bay Buccaneers",
                            "Buffalo Bills","Miami Dolphins","New England Patriots","New York Jets",
                            "Dallas Cowboys","New York Giants","Philadelphia Eagles","Washington Redskins",
                            "Denver Broncos","Kansas City Chiefs","Oakland Raiders","San Diego Chargers",
                            "Arizona Cardinals","Los Angeles Rams","San Francisco 49ers","Seattle Seahawks"

        if ($NewTeam -in $league | Where-Object {$_ -notmatch $this.Team})
        {
            $this.Team = (Get-Culture).TextInfo.ToTitleCase("$NewTeam")
        }
        else
        {
            throw "Invalid Team"
        }

        if ($NewNumber -in 0..99)
        {
            $this.Number = $NewNumber
        }
        else
        {
            throw "Invalid Number"
        }
    }
}
