Add-Type -AssemblyName System.Windows.Forms

$Label1 = New-Object System.Windows.Forms.Label
$Label1.Text = 'There have been no clicks yet'
$Label1.Size = '200, 20'

$Button1 = New-Object System.Windows.Forms.Button
$Button1.Text = 'Click me'
$Button1.Location = '0, 20'

$Button1.Add_Click(
    {
    $Script:Clicks++
    If ( $Clicks -eq 1 ) { $Label1.Text = "There has been 1 click" }
    Else                 { $Label1.Text = "There have been $Clicks clicks" }
    } )

$Form1 = New-Object System.Windows.Forms.Form
$Form1.Controls.AddRange( @( $Label1, $Button1 ) )

$Clicks = 0

$Result = $Form1.ShowDialog()
