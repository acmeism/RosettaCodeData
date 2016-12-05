[xml]$Xaml = @"
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    x:Name = "Window1"
    Width  = "200"
    Height = "120"
    ShowInTaskbar = "True">
    <StackPanel>
        <Label
            x:Name  = "Label1"
            Height  = "40"
            Width   = "200"
            Content = "There have been no clicks"/>
        <Button
            x:Name  = "Button1"
            Height  = "25"
            Width   = "60"
            Content = "Click me"/>
    </StackPanel>
</Window>
"@

$Window1 = [Windows.Markup.XamlReader]::Load( [System.Xml.XmlNodeReader]$Xaml )

$Label1  = $Window1.FindName( "Label1"  )
$Button1 = $Window1.FindName( "Button1" )

$Button1.Add_Click(
    {
    $Script:Clicks++
    If ( $Clicks -eq 1 ) { $Label1.Content = "There has been 1 click" }
    Else                 { $Label1.Content = "There have been $Clicks clicks" }
    } )

$Clicks = 0

$Result = $Window1.ShowDialog()
