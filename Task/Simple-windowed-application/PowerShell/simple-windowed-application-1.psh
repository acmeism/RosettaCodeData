$Label1  = [System.Windows.Forms.Label]@{
            Text = 'There have been no clicks yet'
            Size = '200, 20' }
$Button1 = [System.Windows.Forms.Button]@{
            Text = 'Click me'
            Location = '0, 20' }

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
