function Get-HuffmanEncodingTable ( $String )
    {
    #  Create leaf nodes
    $ID = 0
    $Nodes = [char[]]$String |
        Group-Object |
        ForEach { $ID++; $_ } |
        Select  @{ Label = 'Symbol'  ; Expression = { $_.Name  } },
                @{ Label = 'Count'   ; Expression = { $_.Count } },
                @{ Label = 'ID'      ; Expression = { $ID      } },
                @{ Label = 'Parent'  ; Expression = { 0        } },
                @{ Label = 'Code'    ; Expression = { ''       } }

    #  Grow stems under leafs
    ForEach ( $Branch in 2..($Nodes.Count) )
        {
        #  Get the two nodes with the lowest count
        $LowNodes = $Nodes | Where Parent -eq 0 | Sort Count | Select -First 2

        #  Create a new stem node
        $ID++
        $Nodes += '' |
            Select  @{ Label = 'Symbol'  ; Expression = { ''       } },
                    @{ Label = 'Count'   ; Expression = { $LowNodes[0].Count + $LowNodes[1].Count } },
                    @{ Label = 'ID'      ; Expression = { $ID      } },
                    @{ Label = 'Parent'  ; Expression = { 0        } },
                    @{ Label = 'Code'    ; Expression = { ''       } }

        #  Put the two nodes in the new stem node
        $LowNodes[0].Parent = $ID
        $LowNodes[1].Parent = $ID

        #  Assign 0 and 1 to the left and right nodes
        $LowNodes[0].Code = '0'
        $LowNodes[1].Code = '1'
        }

    #  Assign coding to nodes
    ForEach ( $Node in $Nodes[($Nodes.Count-2)..0] )
        {
        $Node.Code = ( $Nodes | Where ID -eq $Node.Parent ).Code + $Node.Code
        }

    $EncodingTable = $Nodes | Where { $_.Symbol } | Select Symbol, Code | Sort Symbol
    return $EncodingTable
    }

#  Get table for given string
$String = "this is an example for huffman encoding"
$HuffmanEncodingTable = Get-HuffmanEncodingTable $String

#  Display table
$HuffmanEncodingTable | Format-Table -AutoSize

#  Encode string
$EncodedString = $String
ForEach ( $Node in $HuffmanEncodingTable )
    {
    $EncodedString = $EncodedString.Replace( $Node.Symbol, $Node.Code )
    }
$EncodedString
