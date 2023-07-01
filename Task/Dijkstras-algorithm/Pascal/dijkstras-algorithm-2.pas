program Dijkstra_console;
// Demo of Dijkstra's algorithm.
// Free Pascal (Lazarus), console application.

uses SysUtils;
type
  TNodeSet = (setA, setB, setC);
  TNode = record
    NodeSet : TNodeSet;
    PrevIndex : integer;  // previous node in path leading to this node
    PathLength : integer; // total length of path to this node
  end;

const
// Rosetta code task
  NR_NODES = 6;
  START_INDEX = 0;
  NODE_NAMES: array [0..NR_NODES - 1] of string = ('a','b','c','d','e','f');
  // LENGTHS[j,k] = length of branch j -> k, or -1 if no such branch exists.
  LENGTHS : array [0..NR_NODES - 1] of array [0..NR_NODES - 1] of integer
  = ((-1, 7, 9,-1,-1,14),
     (-1,-1,10,15,-1,-1),
     (-1,-1,-1,11,-1, 2),
     (-1,-1,-1,-1, 6,-1),
     (-1,-1,-1,-1,-1, 9),
     (-1,-1,-1,-1,-1,-1));

var
  nodes : array [0..NR_NODES - 1] of TNode;
  j, j_min, k : integer;
  lastToSetA, nrInSetA: integer;
  branchLength, trialLength, minLength : integer;
  lineOut : string;
begin
  // Initialize nodes: all in set C
  for j := 0 to NR_NODES - 1 do begin
    nodes[j].NodeSet := setC;
    // No need to initialize PrevIndex and PathLength, as they are
    //   not used until a value has been assigned by the algorithm.
  end;

  // Begin by transferring the start node to set A
  nodes[START_INDEX].NodeSet := setA;
  nodes[START_INDEX].PathLength := 0;
  nrInSetA := 1;
  lastToSetA := START_INDEX;

  // Transfer nodes to set A one at a time, until all have been transferred
  while (nrInSetA < NR_NODES) do begin

    // Step 1: Work through branches leading from the node that was most recently
    //         transferred to set A, and deal with end nodes in set B or set C.
    for j := 0 to NR_NODES - 1 do begin
      branchLength := LENGTHS[ lastToSetA, j];
      if (branchLength >= 0) then begin
        // If the end node is in set B, and the path to the end node via lastToSetA
        //   is shorter than the existing path, then update the path.
        if (nodes[j].NodeSet = setB) then begin
          trialLength := nodes[lastToSetA].PathLength + branchLength;
          if (trialLength < nodes[j].PathLength) then begin
            nodes[j].PrevIndex := lastToSetA;
            nodes[j].PathLength := trialLength;
          end;
        end
        // If the end node is in set C, transfer it to set B.
        else if (nodes[j].NodeSet = setC) then begin
          nodes[j].NodeSet := setB;
          nodes[j].PrevIndex := lastToSetA;
          nodes[j].PathLength := nodes[lastToSetA].PathLength + branchLength;
        end;
      end;
    end;

    // Step 2: Find the node in set B with the smallest path length,
    //         and transfer that node to set A.
    //         (Note that set B cannot be empty at this point.)
    minLength := -1; // just to stop compiler warning "might not have been initialized"
    j_min := -1; // index of node with smallest path length; will become >= 0
    for j := 0 to NR_NODES - 1 do begin
      if (nodes[j].NodeSet = setB) then begin
        if (j_min < 0) or (nodes[j].PathLength < minLength) then begin
          j_min := j;
          minLength := nodes[j].PathLength;
        end;
      end;
    end;
    nodes[j_min].NodeSet := setA;
    inc( nrInSetA);
    lastToSetA := j_min;
  end;

  // Write result to console
  WriteLn( SysUtils.Format( 'Shortest paths from node %s:', [NODE_NAMES[START_INDEX]]));
  for j := 0 to NR_NODES - 1 do begin
    if (j <> START_INDEX) then begin
      k := j;
      lineOut := NODE_NAMES[k];
      repeat
        k := nodes[k].PrevIndex;
        lineOut := NODE_NAMES[k] + ' -> ' + lineOut;
      until (k = START_INDEX);
      lineOut := SysUtils.Format( '%3s: length %3d,  ',
                 [NODE_NAMES[j], nodes[j].PathLength]) + lineOut;
      WriteLn( lineOut);
    end;
  end;
end.
