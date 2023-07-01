Function Draw-SierpinskiCarpet ( [int]$N )
    {
    #  Define form
    $Form = [System.Windows.Forms.Form]@{ Size = '300, 300' }
    $Form.Controls.Add(( $PictureBox = [System.Windows.Forms.PictureBox]@{ Size = $Form.ClientSize; Anchor = 'Top, Bottom, Left, Right' } ))

    #  Main code to draw Sierpinski carpet
    $Draw = {

        #  Create graphics objects to use
        $PictureBox.Image = ( $Canvas = New-Object System.Drawing.Bitmap ( $PictureBox.Size.Width, $PictureBox.Size.Height ) )
        $Graphics = [System.Drawing.Graphics]::FromImage( $Canvas )

        #  Draw single pixel
        $Graphics.FillRectangle( [System.Drawing.Brushes]::Black, 0, 0, 1, 1 )

        #  If N was not specified, use an N that will fill the form
        If ( -not $N ) { $N = [math]::Ceiling( [math]::Log( [math]::Max( $PictureBox.Size.Height, $PictureBox.Size.Width ) ) / [math]::Log( 3 ) ) }

        #  Define the shape of the fractal
        $P  = @( @( 0, 0 ), @( 0, 1 ), @( 0, 2 ) )
        $P += @( @( 1, 0 ),            @( 1, 2 ) )
        $P += @( @( 2, 0 ), @( 2, 1 ), @( 2, 2 ) )

        #  For each iteration
        ForEach ( $i in 0..$N )
            {
            #  Copy the result of the previous iteration
            $Copy = New-Object System.Drawing.TextureBrush ( $Canvas )

            #  Calulate the size of the copy
            $S = [math]::Pow( 3, $i )

            #  For each position in the next layer of the fractal
            ForEach ( $i in 1..7 )
                {
                #  Adjust the copy for the new location
                $Copy.TranslateTransform( - $P[$i-1][0] * $S + $P[$i][0] * $S, - $P[$i-1][1] * $S + $P[$i][1] * $S )

                #  Paste the copy of the previous iteration into the new location
                $Graphics.FillRectangle( $Copy, $P[$i][0] * $S, $P[$i][1] * $S, $S, $S )
                }
            }
        }

    #  Add the main drawing code to the appropriate events to be drawn when the form is first shown and redrawn when the form size is changed
    $Form.Add_Shown(  $Draw )
    $Form.Add_Resize( $Draw )

    #  Launch the form
    $Null = $Form.ShowDialog()
    }

Draw-SierpinskiCarpet 4
