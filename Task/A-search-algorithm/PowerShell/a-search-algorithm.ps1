function CreateGrid($h, $w, $fill) {
    $grid = 0..($h - 1) | ForEach-Object { , (, $fill * $w) }
    return $grid
}

function EstimateCost($a, $b) {
    $xd = [Math]::Abs($a.Item1 - $b.Item1)
    $yd = [Math]::Abs($a.Item2 - $b.Item2)
    return [Math]::Max($xd, $yd)
}

function AStar($costs, $start, $goal) {
    # ValueTuples can be used to index a Hashtable:
    $start = [ValueTuple]::Create($start[0], $start[1])
    $goal = [ValueTuple]::Create($goal[0], $goal[1])

    $rows = $costs.Length
    $cols = $costs[0].Length

    $cameFrom = CreateGrid $rows $cols $null
    $openSet = @{$start = (EstimateCost $start $goal), 0}
    $closedSet = @{}

    while ($openSet.Count -gt 0) {
        # find the value in openSet with the lowest fScore
        $curFScore = [int]::MaxValue

        foreach ($p in $openSet.Keys) {
            $fScore, $gScore = $openSet[$p]
            if ($fScore -lt $curFScore) {
                $curFScore = $fScore
                $curGScore = $gScore
                $cur = $p
            }
        }

        if ($cur -eq $goal) {
            $totalCost = $curGScore
            break
        }

        $openSet.Remove($cur)
        $closedSet.Add($cur, 0)
        $r, $c = $cur.Item1, $cur.Item2

        # iterate over each cell in the 3x3 neighborhood
        foreach ($i in [Math]::Max($r - 1, 0)..[Math]::Min($r + 1, $rows - 1)) {
            foreach ($j in [Math]::Max($c - 1, 0)..[Math]::Min($c + 1, $cols - 1)) {
                $neighbor = [ValueTuple]::Create($i, $j)
                if ($closedSet.ContainsKey($neighbor)) { continue }

                $newGScore = $curGScore + $costs[$i][$j]
                $newFScore = $newGScore + (EstimateCost $neighbor $goal)

                if (-not $openSet.ContainsKey($neighbor)) {
                    $openSet[$neighbor] = $newFScore, $newGScore
                }
                else {
                    $fs, $gs = $openSet[$neighbor]
                    if ($newGScore -ge $gs) { continue }
                }

                $cameFrom[$i][$j] = $cur
            }
        }
    }

    # Walk back from the goal
    $route = @(, ($goal.Item1, $goal.Item2))
    $cur = $goal

    while ($cur -ne $start) {
        $cur = $cameFrom[$cur.Item1][$cur.Item2]
        $route += , ($cur.Item1, $cur.Item2)
    }

    [array]::Reverse($route)
    return $route, $totalCost
}

$grid = CreateGrid 8 8 1
$grid[2][4] = 100
$grid[2][5] = 100
$grid[2][6] = 100
$grid[3][6] = 100
$grid[4][6] = 100
$grid[5][6] = 100
$grid[5][5] = 100
$grid[5][4] = 100
$grid[5][3] = 100
$grid[5][2] = 100
$grid[4][2] = 100
$grid[3][2] = 100

$route, $cost = AStar $grid (0, 0) (7, 7)
$displayGrid = CreateGrid 8 8 '.'

foreach ($i in 0..7) {
    foreach ($j in 0..7) {
        if ($grid[$i][$j] -gt 1) {
            $displayGrid[$i][$j] = '#'
        }
    }
}

foreach ($step in $route) {
    $displayGrid[$step[0]][$step[1]] = 'x'
}

Write-Output ($displayGrid | ForEach-Object { $_ -join '' })
Write-Output "Cost: $cost"
$routeString = ($route | ForEach-Object { "($($_[0]), $($_[1]))" }) -join ', '
Write-Output "Route: $routeString"
