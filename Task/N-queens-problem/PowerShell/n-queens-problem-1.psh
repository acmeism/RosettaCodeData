function PlaceQueen ( [ref]$Board, $Row, $N )
    {
    #  For the current row, start with the first column
    $Board.Value[$Row] = 0

    #  While haven't exhausted all columns in the current row...
    While ( $Board.Value[$Row] -lt $N )
        {
        #  If not the first row, check for conflicts
        $Conflict = $Row -and
                    (   (0..($Row-1)).Where{ $Board.Value[$_] -eq $Board.Value[$Row] }.Count -or
                        (0..($Row-1)).Where{ $Board.Value[$_] -eq $Board.Value[$Row] - $Row + $_ }.Count -or
                        (0..($Row-1)).Where{ $Board.Value[$_] -eq $Board.Value[$Row] + $Row - $_ }.Count )

        #  If no conflicts and the current column is a valid column...
        If ( -not $Conflict -and $Board.Value[$Row] -lt $N )
            {

            #  If this is the last row
            #    Board completed successfully
            If ( $Row -eq ( $N - 1 ) )
                {
                return $True
                }

            #  Recurse
            #  If all nested recursions were successful
            #    Board completed successfully
            If ( PlaceQueen $Board ( $Row + 1 ) $N )
                {
                return $True
                }
            }

        #  Try the next column
        $Board.Value[$Row]++
        }

    #  Everything was tried, nothing worked
    Return $False
    }

function Get-NQueensBoard ( $N )
    {
    #  Start with a default board (array of column positions for each row)
    $Board = @( 0 ) * $N

    #  Place queens on board
    #  If successful...
    If ( PlaceQueen -Board ([ref]$Board) -Row 0 -N $N )
        {
        #  Convert board to strings for display
        $Board | ForEach { ( @( "" ) + @(" ") * $_ + "Q" + @(" ") * ( $N - $_ ) ) -join "|" }
        }
    Else
        {
        "There is no solution for N = $N"
        }
    }
