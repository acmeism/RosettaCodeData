# Matrix class implemented as array reference
class Matrix {
    [object[]]$data

    # Constructor
    Matrix([object[]]$data) {
        $this.data = $data
    }

    # Create matrix from nested blocks
    static [Matrix] Block([Matrix[][]]$blocks) {
        $result = @()

        # Get dimensions
        $num_rows = 0
        foreach ($hblock in $blocks) {
            $num_rows += $hblock[0].data.Count
        }

        # Process each horizontal block
        $row_offset = 0
        foreach ($hblock in $blocks) {
            $block_height = $hblock[0].data.Count
            # Zip and concatenate rows
            for ($i = 0; $i -lt $block_height; $i++) {
                $new_row = @()
                foreach ($matrix in $hblock) {
                    $new_row += $matrix.data[$i]
                }
                if ($row_offset + $i -ge $result.Count) {
                    $result += , @()
                }
                $result[$row_offset + $i] = $new_row
            }
            $row_offset += $block_height
        }

        return [Matrix]::new($result)
    }

    # Matrix multiplication (naive)
    [Matrix] Dot([Matrix]$b) {
        $rows_a = $this.data.Count
        $cols_a = if ($rows_a -gt 0) { $this.data[0].Count } else { 0 }
        $rows_b = $b.data.Count
        $cols_b = if ($rows_b -gt 0) { $b.data[0].Count } else { 0 }

        if ($cols_a -ne $rows_b) {
            throw "Matrix dimensions don't match for multiplication"
        }

        $result = @()
        for ($i = 0; $i -lt $rows_a; $i++) {
            $row = @()
            for ($j = 0; $j -lt $cols_b; $j++) {
                $sum = 0
                for ($k = 0; $k -lt $cols_a; $k++) {
                    $sum += $this.data[$i][$k] * $b.data[$k][$j]
                }
                $row += $sum
            }
            $result += , $row
        }

        return [Matrix]::new($result)
    }

    # Matrix addition
    [Matrix] Add([Matrix]$b) {
        $rows = $this.data.Count
        $cols = if ($rows -gt 0) { $this.data[0].Count } else { 0 }
        $b_rows = $b.data.Count
        $b_cols = if ($b_rows -gt 0) { $b.data[0].Count } else { 0 }

        if ($rows -ne $b_rows -or $cols -ne $b_cols) {
            throw "Matrix dimensions don't match for addition"
        }

        $result = @()
        for ($i = 0; $i -lt $rows; $i++) {
            $row = @()
            for ($j = 0; $j -lt $cols; $j++) {
                $row += $this.data[$i][$j] + $b.data[$i][$j]
            }
            $result += , $row
        }

        return [Matrix]::new($result)
    }

    # Matrix subtraction
    [Matrix] Subtract([Matrix]$b) {
        $rows = $this.data.Count
        $cols = if ($rows -gt 0) { $this.data[0].Count } else { 0 }
        $b_rows = $b.data.Count
        $b_cols = if ($b_rows -gt 0) { $b.data[0].Count } else { 0 }

        if ($rows -ne $b_rows -or $cols -ne $b_cols) {
            throw "Matrix dimensions don't match for subtraction"
        }

        $result = @()
        for ($i = 0; $i -lt $rows; $i++) {
            $row = @()
            for ($j = 0; $j -lt $cols; $j++) {
                $row += $this.data[$i][$j] - $b.data[$i][$j]
            }
            $result += , $row
        }

        return [Matrix]::new($result)
    }

    # Strassen's algorithm
    [Matrix] Strassen([Matrix]$b) {
        $rows = $this.data.Count
        $cols = if ($rows -gt 0) { $this.data[0].Count } else { 0 }
        $b_rows = $b.data.Count
        $b_cols = if ($b_rows -gt 0) { $b.data[0].Count } else { 0 }

        if ($rows -ne $cols -or $b_rows -ne $b_cols) {
            throw "Matrices must be square"
        }
        if ($rows -ne $b_rows) {
            throw "Matrices must be the same shape"
        }
        if ($rows -le 0 -or ($rows -band ($rows - 1)) -ne 0) {
            throw "Shape must be a power of 2"
        }

        if ($rows -eq 1) {
            return $this.Dot($b)
        }

        $p = [Math]::Floor($rows / 2)

        # Partition matrices
        $a11_data = @()
        $a12_data = @()
        $a21_data = @()
        $a22_data = @()
        for ($i = 0; $i -lt $p; $i++) {
            $a11_data += , @($this.data[$i][0..($p-1)])
            $a12_data += , @($this.data[$i][$p..($rows-1)])
        }
        for ($i = $p; $i -lt $rows; $i++) {
            $a21_data += , @($this.data[$i][0..($p-1)])
            $a22_data += , @($this.data[$i][$p..($rows-1)])
        }

        $b11_data = @()
        $b12_data = @()
        $b21_data = @()
        $b22_data = @()
        for ($i = 0; $i -lt $p; $i++) {
            $b11_data += , @($b.data[$i][0..($p-1)])
            $b12_data += , @($b.data[$i][$p..($b_cols-1)])
        }
        for ($i = $p; $i -lt $b_rows; $i++) {
            $b21_data += , @($b.data[$i][0..($p-1)])
            $b22_data += , @($b.data[$i][$p..($b_rows-1)])
        }

        $a11 = [Matrix]::new($a11_data)
        $a12 = [Matrix]::new($a12_data)
        $a21 = [Matrix]::new($a21_data)
        $a22 = [Matrix]::new($a22_data)
        $b11 = [Matrix]::new($b11_data)
        $b12 = [Matrix]::new($b12_data)
        $b21 = [Matrix]::new($b21_data)
        $b22 = [Matrix]::new($b22_data)

        # Calculate M1..M7
        $m1 = ($a11.Add($a22)).Strassen($b11.Add($b22))
        $m2 = ($a21.Add($a22)).Strassen($b11)
        $m3 = $a11.Strassen($b12.Subtract($b22))
        $m4 = $a22.Strassen($b21.Subtract($b11))
        $m5 = ($a11.Add($a12)).Strassen($b22)
        $m6 = ($a21.Subtract($a11)).Strassen($b11.Add($b12))
        $m7 = ($a12.Subtract($a22)).Strassen($b21.Add($b22))

        # Calculate C11..C22
        $c11 = $m1.Add($m4).Subtract($m5).Add($m7)
        $c12 = $m3.Add($m5)
        $c21 = $m2.Add($m4)
        $c22 = $m1.Subtract($m2).Add($m3).Add($m6)

        return [Matrix]::Block(@(@($c11, $c12), @($c21, $c22)))
    }

    # Round elements
    [Matrix] RoundMatrix([int]$ndigits) {
        $result = @()
        for ($i = 0; $i -lt $this.data.Count; $i++) {
            $row = @()
            for ($j = 0; $j -lt $this.data[$i].Count; $j++) {
                $val = $this.data[$i][$j]
                if ($ndigits -ne $null) {
                    $rounded = [Math]::Round($val, $ndigits)
                    $row += $rounded
                } else {
                    $rounded = [Math]::Round($val)
                    $row += $rounded
                }
            }
            $result += , $row
        }

        return [Matrix]::new($result)
    }

    [Matrix] RoundMatrix() {
        return $this.RoundMatrix($null)
    }

    # Get matrix shape
    [object[]] Shape() {
        if ($this.data.Count -eq 0) {
            return @(0, 0)
        }
        return @($this.data.Count, $this.data[0].Count)
    }

    # String representation
    [string] ToString() {
        $rows = @()
        foreach ($row in $this.data) {
            $rows += "[" + ($row -join ", ") + "]"
        }
        return "[" + ($rows -join ", ") + "]"
    }
}

# Operator overloading for PowerShell (using methods instead)
function Multiply-Matrix([Matrix]$a, [Matrix]$b) {
    return $a.Dot($b)
}

function Add-Matrix([Matrix]$a, [Matrix]$b) {
    return $a.Add($b)
}

function Subtract-Matrix([Matrix]$a, [Matrix]$b) {
    return $a.Subtract($b)
}

# Examples
function Examples() {
    $a = [Matrix]::new(@(@(1, 2), @(3, 4)))
    $b = [Matrix]::new(@(@(5, 6), @(7, 8)))
    $c = [Matrix]::new(@(
        @(1, 1, 1, 1),
        @(2, 4, 8, 16),
        @(3, 9, 27, 81),
        @(4, 16, 64, 256)
    ))
    $d = [Matrix]::new(@(
        @(4, -3, (4/3), (-1/4)),
        @((-13/3), (19/4), (-7/3), (11/24)),
        @((3/2), -2, (7/6), (-1/4)),
        @((-1/6), (1/4), (-1/6), (1/24))
    ))
    $e = [Matrix]::new(@(
        @(1, 2, 3, 4),
        @(5, 6, 7, 8),
        @(9, 10, 11, 12),
        @(13, 14, 15, 16)
    ))
    $f = [Matrix]::new(@(
        @(1, 0, 0, 0),
        @(0, 1, 0, 0),
        @(0, 0, 1, 0),
        @(0, 0, 0, 1)
    ))

    Write-Host "Naive matrix multiplication:"
    Write-Host "  a * b = $($a.Dot($b))"
    Write-Host "  c * d = $($c.Dot($d).RoundMatrix(0))"
    Write-Host "  e * f = $($e.Dot($f))"

    Write-Host "Strassen's matrix multiplication:"
    Write-Host "  a * b = $($a.Strassen($b))"
    Write-Host "  c * d = $($c.Strassen($d).RoundMatrix(0))"
    Write-Host "  e * f = $($e.Strassen($f))"
}

# Run examples if script is executed directly
Examples
