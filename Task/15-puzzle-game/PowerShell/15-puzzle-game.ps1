#15 Puzzle Game
$Script:Neighbours = @{
    "1" = @("2","5")
    "2" = @("1","3","6")
    "3" = @("2","4","7")
    "4" = @("3","8")
    "5" = @("1","6","9")
    "6" = @("2","5","7","10")
    "7" = @("3","6","8","11")
    "8" = @("4","7","12")
    "9" = @("5","10","13")
    "10" = @("6","9","11","14")
    "11" = @("7","10","12","15")
    "12" = @("8","11","0")
    "13" = @("9","14")
    "14" = @("10","13","15")
    "15" = @("11","14","0")
    "0" = @("12","15")
}
$script:blank = ''
#region XAML window definition
$xaml = @'
<Window
   xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
   xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
   xmlns:d="http://schemas.microsoft.com/expression/blend/2008" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" mc:Ignorable="d"
   MinWidth="200"
   Width ="333.333"
   Title="15 Game"
   Topmost="True" Height="398.001" VerticalAlignment="Center" HorizontalAlignment="Center">
    <Grid HorizontalAlignment="Center" Height="285" Margin="0" VerticalAlignment="Center" Width="300">
        <Grid.ColumnDefinitions>
            <ColumnDefinition/>
            <ColumnDefinition/>
            <ColumnDefinition/>
            <ColumnDefinition/>
        </Grid.ColumnDefinitions>
        <Grid.RowDefinitions>
            <RowDefinition/>
            <RowDefinition/>
            <RowDefinition/>
            <RowDefinition/>
        </Grid.RowDefinitions>
        <Button x:Name="B_1" Content="01" HorizontalAlignment="Left" VerticalAlignment="Top" Width="75" Height="72" FontSize="24"/>
        <Button x:Name="B_2" Content="02" HorizontalAlignment="Left" VerticalAlignment="Top" Width="75" Height="72" FontSize="24" Grid.Column="1"/>
        <Button x:Name="B_3" Content="03" HorizontalAlignment="Left" VerticalAlignment="Top" Width="75" Height="72" FontSize="24" Grid.Column="2"/>
        <Button x:Name="B_4" Content="04" HorizontalAlignment="Left" VerticalAlignment="Top" Width="75" Height="72" FontSize="24" Grid.Column="3"/>
        <Button x:Name="B_5" Content="05" HorizontalAlignment="Left" VerticalAlignment="Top" Width="75" Height="72" FontSize="24" Grid.Row="1"/>
        <Button x:Name="B_6" Content="06" HorizontalAlignment="Left" VerticalAlignment="Top" Width="75" Height="72" FontSize="24" Grid.Column="1" Grid.Row="1"/>
        <Button x:Name="B_7" Content="07" HorizontalAlignment="Left" VerticalAlignment="Top" Width="75" Height="72" FontSize="24" Grid.Column="2" Grid.Row="1"/>
        <Button x:Name="B_8" Content="08" HorizontalAlignment="Left" VerticalAlignment="Top" Width="75" Height="72" FontSize="24" Grid.Column="3" Grid.Row="1"/>
        <Button x:Name="B_9" Content="09" HorizontalAlignment="Left" VerticalAlignment="Top" Width="75" Height="72" FontSize="24" Margin="0,71,0,0" Grid.Row="1" Grid.RowSpan="2"/>
        <Button x:Name="B_10" Content="10" HorizontalAlignment="Left" VerticalAlignment="Top" Width="75" Height="72" FontSize="24" Grid.Column="1" Grid.Row="1" Margin="0,71,0,0" Grid.RowSpan="2"/>
        <Button x:Name="B_11" Content="11" HorizontalAlignment="Left" VerticalAlignment="Top" Width="75" Height="72" FontSize="24" Grid.Column="2" Grid.Row="1" Margin="0,71,0,0" Grid.RowSpan="2"/>
        <Button x:Name="B_12" Content="12" HorizontalAlignment="Left" VerticalAlignment="Top" Width="75" Height="72" FontSize="24" Grid.Column="3" Grid.Row="1" Margin="0,71,0,0" Grid.RowSpan="2"/>
        <Button x:Name="B_13" Content="13" HorizontalAlignment="Left" VerticalAlignment="Top" Width="75" Height="72" FontSize="24" Margin="0,71,0,0" Grid.Row="2" Grid.RowSpan="2"/>
        <Button x:Name="B_14" Content="14" HorizontalAlignment="Left" VerticalAlignment="Top" Width="75" Height="72" FontSize="24" Grid.Column="1" Grid.Row="2" Margin="0,71,0,0" Grid.RowSpan="2"/>
        <Button x:Name="B_15" Content="15" HorizontalAlignment="Center" VerticalAlignment="Center" Width="75" Height="72" FontSize="24" Grid.Column="2" Grid.Row="2" Margin="0,71,0,0" Grid.RowSpan="2"/>
        <Button x:Name="B_0" Content="00" HorizontalAlignment="Left" VerticalAlignment="Top" Width="75" Height="72" FontSize="24" Grid.Column="3" Grid.Row="2" Margin="0,71,0,0" Grid.RowSpan="2"/>
        <Button x:Name="B_Jumble" Grid.ColumnSpan="2" Content="Jumble Tiles" Grid.Column="1" HorizontalAlignment="Left" Height="23" Margin="0,81,0,-33" Grid.Row="3" VerticalAlignment="Top" Width="150"/>
    </Grid>
</Window>
'@
#endregion

#region Code Behind
function Convert-XAMLtoWindow
{
    param
    (
        [Parameter(Mandatory=$true)]
        [string]
        $XAML
    )

    Add-Type -AssemblyName PresentationFramework

    $reader = [XML.XMLReader]::Create([IO.StringReader]$XAML)
    $result = [Windows.Markup.XAMLReader]::Load($reader)
    $reader.Close()
    $reader = [XML.XMLReader]::Create([IO.StringReader]$XAML)
    while ($reader.Read())
    {
        $name=$reader.GetAttribute('Name')
        if (!$name) { $name=$reader.GetAttribute('x:Name') }
        if($name)
        {$result | Add-Member NoteProperty -Name $name -Value $result.FindName($name) -Force}
    }
    $reader.Close()
    $result
}
function Show-WPFWindow
{
    param
    (
        [Parameter(Mandatory=$true)]
        [Windows.Window]
        $Window
    )

    $result = $null
    $null = $window.Dispatcher.InvokeAsync{
        $result = $window.ShowDialog()
        Set-Variable -Name result -Value $result -Scope 1
    }.Wait()
    $result
}
#endregion Code Behind

#region Convert XAML to Window
$window = Convert-XAMLtoWindow -XAML $xaml

#endregion

#region Define Event Handlers
function Test-Victory{
    #Evaluate if all the labels are in the correct position
    $victory = $true
    foreach($num in 1..15){
        if([int]$window."b_$num".Content -ne $num){$victory = $false;break}
    }
    return($victory)
}
function Test-Move($Number){
    #Number is a string of the pressed button number.
    if($Script:Neighbours[$Number] -contains $script:blank){
        return($true)
    } else {
        return($false)
    }
}
Function Move-Tile($Number,$Bypass){
    if((!(Test-Victory)) -or $Bypass){
        if(Test-Move $Number){
            #Set the new window label
            $window."B_$script:blank".content = $window."B_$Number".content
            $window."B_$script:blank".background = $window."B_$Number".background
            $window."B_$Number".background = "#FFDDDDDD"
            #Set the new blank window label
            $window."B_$Number".content = ''
            #Enable the old blank tile
            $window."B_$script:blank".isenabled = $true
            #disable the new blank tile
            $window."B_$Number".isenabled = $false
            #set the new blank
            $script:blank = $Number
        }
    }
}
function Move-TileRandom{
    $lastmove = "1"
    for($i=0;$i -lt 500;$i++){
        $move = $Script:Neighbours[$script:blank] | Where-Object {$_ -ne $lastmove} | Get-Random
        $lastmove = $move
        Move-Tile $move $true
    }
}
function Set-TileColour($Tile){
    #I was curious about setting tiles to a checkerboard pattern at this stage. It's probably far better to just define it in the xaml
    #Ignore the blank tile
    if($Tile -ne 0){
        #check if the row of the tile is odd or even
        if((([math]::floor(($Tile - 1)/4)) % 2 -eq 0)){
            #check if the tile is odd or even
            if($Tile % 2 -eq 0){
                $window."B_$Tile".Background = "#FFFF7878"
            } else {
                $window."B_$Tile".Background = "#FF9696FF"
            }
        }else{
            if($Tile % 2 -eq 0){
                $window."B_$Tile".Background = "#FF9696FF"
            } else {
                $window."B_$Tile".Background = "#FFFF7878"
            }
        }
    } else {
        $window.B_0.Background = "#FFDDDDDD"
    }
}
$window.B_1.add_Click{
    $n = "1"
    move-tile $n
}
$window.B_2.add_Click{
    $n = "2"
    move-tile $n
}
$window.B_3.add_Click{
    $n = "3"
    move-tile $n
}
$window.B_4.add_Click{
    $n = "4"
    move-tile $n
}
$window.B_5.add_Click{
    $n = "5"
    move-tile $n
}
$window.B_6.add_Click{
    $n = "6"
    move-tile $n
}
$window.B_7.add_Click{
    $n = "7"
    move-tile $n
}
$window.B_8.add_Click{
    $n = "8"
    move-tile $n
}
$window.B_9.add_Click{
    $n = "9"
    move-tile $n
}
$window.B_10.add_Click{
    $n = "10"
    move-tile $n
}
$window.B_11.add_Click{
    $n = "11"
    move-tile $n
}
$window.B_12.add_Click{
    $n = "12"
    move-tile $n
}
$window.B_13.add_Click{
    $n = "13"
    move-tile $n
}
$window.B_14.add_Click{
    $n = "14"
    move-tile $n
}
$window.B_15.add_Click{
    $n = "15"
    move-tile $n
}
$window.B_0.add_Click{
    $n = "0"
    move-tile $n
}

$window.B_Jumble.add_Click{
    Move-TileRandom
}
#endregion Event Handlers
(([math]::floor(("9" - 1)/4)) % 2 -eq 0)
#region Manipulate Window Content
#initial processing of tiles
$array = 0..15 | ForEach-Object {"{0:00}" -f $_}
0..15 | ForEach-Object {if($array[$_] -ne '00'){$window."B_$_".content = $array[$_]} else {$window."B_$_".content = '';$script:blank = "$_";$window."B_$_".isenabled = $false};Set-TileColour $_}
#Shove them around a bit
Move-TileRandom
#endregion
# Show Window
$result = Show-WPFWindow -Window $window
