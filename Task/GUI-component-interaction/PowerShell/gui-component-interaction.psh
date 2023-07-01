[xml]$XML = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        Title="Rosetta Code" WindowStartupLocation = "CenterScreen" Height="100" Width="210" ResizeMode="NoResize">

    <Grid Background="#FFC1C3CB">
        <Label Name="Label_Value" Content="Value" HorizontalAlignment="Left" Margin="10,10,0,0" VerticalAlignment="Top" Width="70"/>
        <TextBox Name="TextBox_Value" HorizontalAlignment="Left" Height="23" Margin="90,10,0,0" TextWrapping="Wrap" Text="0" VerticalAlignment="Top" Width="100"/>
        <Button Name="Button_Random" Content="Random" HorizontalAlignment="Left" Margin="10,41,0,0" VerticalAlignment="Top" Width="70" Height="23"/>
        <Button Name="Button_Increment" Content="Increment" HorizontalAlignment="Left" Margin="90,41,0,0" VerticalAlignment="Top" Width="100" Height="23"/>
    </Grid>
</Window>
"@

$XMLReader = New-Object System.Xml.XmlNodeReader $XML
$XMLForm = [Windows.Markup.XamlReader]::Load($XMLReader)
$buttonIncrement = $XMLForm.FindName('Button_Increment')
$buttonRandom = $XMLForm.FindName('Button_Random')
$textBoxValue = $XMLForm.FindName('TextBox_Value')

$buttonRandom.add_click({
    $textBoxValue.Text = Get-Random -Minimum 0 -Maximum 10000
})
$buttonIncrement.add_click({++[Int]$textBoxValue.Text})

$XMLForm.ShowDialog() | Out-Null
