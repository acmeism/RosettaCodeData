$form = New-Object Windows.Forms.Form
$form.Text = "A Window"
$form.Size = New-Object Drawing.Size(150,150)
$form.ShowDialog() | Out-Null
