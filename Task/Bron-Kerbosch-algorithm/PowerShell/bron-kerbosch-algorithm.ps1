# Global variable to store cliques
$global:cliques = @()

# Edge class equivalent
class Edge {
    [string]$Start
    [string]$End

    Edge([string]$start, [string]$end) {
        $this.Start = $start
        $this.End = $end
    }
}

function Print-Vector {
    param([array]$vec)

    $sortedVec = $vec | Sort-Object
    Write-Host -NoNewline "[$($sortedVec -join ', ')]"
}

function Print-2DVector {
    param([array]$vecs)

    Write-Host -NoNewline "["
    for ($i = 0; $i -lt ($vecs.Count - 1); $i++) {
        Print-Vector $vecs[$i]
        Write-Host -NoNewline ", "
    }
    if ($vecs.Count -gt 0) {
        Print-Vector $vecs[-1]
    }
    Write-Host "]"
}

function Invoke-BronKerbosch {
    param(
        [System.Collections.Generic.HashSet[string]]$CurrentClique,
        [System.Collections.Generic.HashSet[string]]$Candidates,
        [System.Collections.Generic.HashSet[string]]$ProcessedVertices,
        [hashtable]$Graph
    )

    if ($Candidates.Count -eq 0 -and $ProcessedVertices.Count -eq 0) {
        if ($CurrentClique.Count -gt 2) {
            $cliqueArray = @()
            foreach ($item in $CurrentClique) {
                $cliqueArray += $item
            }
            $global:cliques += ,$cliqueArray
        }
        return
    }

    # Select a pivot vertex from 'Candidates' union 'ProcessedVertices' with the maximum degree
    $unionSet = [System.Collections.Generic.HashSet[string]]::new()
    $unionSet.UnionWith($Candidates)
    $unionSet.UnionWith($ProcessedVertices)

    $pivot = $null
    $maxDegree = -1
    foreach ($vertex in $unionSet) {
        $degree = $Graph[$vertex].Count
        if ($degree -gt $maxDegree) {
            $maxDegree = $degree
            $pivot = $vertex
        }
    }

    # 'Possibles' are vertices in 'Candidates' that are not neighbors of the 'pivot'
    $possibles = [System.Collections.Generic.HashSet[string]]::new()
    $possibles.UnionWith($Candidates)
    $possibles.ExceptWith($Graph[$pivot])

    # Create a copy of candidates to iterate over (to avoid modification during iteration)
    $candidatesCopy = [System.Collections.Generic.HashSet[string]]::new()
    $candidatesCopy.UnionWith($Candidates)

    foreach ($vertex in $possibles) {
        # Create a new clique including 'vertex'
        $newClique = [System.Collections.Generic.HashSet[string]]::new()
        $newClique.UnionWith($CurrentClique)
        $newClique.Add($vertex) | Out-Null

        # 'NewCandidates' are the members of 'Candidates' that are neighbors of 'vertex'
        $newCandidates = [System.Collections.Generic.HashSet[string]]::new()
        $newCandidates.UnionWith($Candidates)
        $newCandidates.IntersectWith($Graph[$vertex])

        # 'NewProcessedVertices' are members of 'ProcessedVertices' that are neighbors of 'vertex'
        $newProcessedVertices = [System.Collections.Generic.HashSet[string]]::new()
        $newProcessedVertices.UnionWith($ProcessedVertices)
        $newProcessedVertices.IntersectWith($Graph[$vertex])

        # Recursive call with the updated sets
        Invoke-BronKerbosch $newClique $newCandidates $newProcessedVertices $Graph

        # Move 'vertex' from 'Candidates' to 'ProcessedVertices'
        $Candidates.Remove($vertex) | Out-Null
        $ProcessedVertices.Add($vertex) | Out-Null
    }
}

function Main {
    $global:cliques = @()

    # Define edges
    $edges = @(
        [Edge]::new("a", "b"), [Edge]::new("b", "a"), [Edge]::new("a", "c"), [Edge]::new("c", "a"),
        [Edge]::new("b", "c"), [Edge]::new("c", "b"), [Edge]::new("d", "e"), [Edge]::new("e", "d"),
        [Edge]::new("d", "f"), [Edge]::new("f", "d"), [Edge]::new("e", "f"), [Edge]::new("f", "e")
    )

    # Build the graph as an adjacency list using hashtable
    $graph = @{}
    foreach ($edge in $edges) {
        if (-not $graph.ContainsKey($edge.Start)) {
            $graph[$edge.Start] = [System.Collections.Generic.HashSet[string]]::new()
        }
        $graph[$edge.Start].Add($edge.End) | Out-Null
    }

    # Initialize current clique, candidates, and processed vertices
    $currentClique = [System.Collections.Generic.HashSet[string]]::new()
    $candidates = [System.Collections.Generic.HashSet[string]]::new()
    foreach ($key in $graph.Keys) {
        $candidates.Add($key) | Out-Null
    }
    $processedVertices = [System.Collections.Generic.HashSet[string]]::new()

    # Execute the Bron-Kerbosch algorithm to collect the cliques
    Invoke-BronKerbosch $currentClique $candidates $processedVertices $graph

    # Sort the cliques for consistent display
    $global:cliques = $global:cliques | Sort-Object { $_.Count }, { $_ -join ',' }

    # Display the cliques
    Print-2DVector $global:cliques
}

# Run the main function
Main
