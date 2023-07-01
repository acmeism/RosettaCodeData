program Nonoblock;
uses SysUtils;

// Working through solutions to the problem:
// Fill an array z[] with non-negative integers
//  whose sum is the passed-in integer s.
function GetFirstSolution( var z : array of integer;
                               s : integer) : boolean;
var
  j : integer;
begin
  result := (s >= 0) and (High(z) >= 0);  // failed if s < 0 or array is empty
  if result then begin // else initialize to solution 0, ..., 0, s
    j := High(z);  z[j] := s;
    while (j > 0) do begin
      dec(j);      z[j] := 0;
    end;
  end;
end;

// Next solution: return true for success, false if no more solutions.
// Solutions are generated in lexicographic order.
function GetNextSolution( var z : array of integer) : boolean;
var
  h, j : integer;
begin
  h := High(z);
  j := h; // find highest index j such that z[j] > 0.
  while (j > 0) and (z[j] = 0) do dec(j);
  result := (j > 0);   // if index is 0, or there is no such index, failed
  if result then begin // else update caller's array to give next solution
    inc(z[j - 1]);
    z[h] := z[j] - 1;
    if (j < h) then z[j] := 0;
  end;
end;

// Procedure to print solutions to nonoblock task on RosettaCode
procedure PrintSolutions( nrCells : integer;
                          blockSizes : array of integer);
const // cosmetic
  MARGIN = 4;
  GAP_CHAR = '.';
  BLOCK_CHAR = '#';
var
  sb : SysUtils.TStringBuilder;
  nrBlocks, blockSum, gapSum : integer;
  gapSizes : array of integer;
  i, nrSolutions : integer;
begin
  nrBlocks := Length( blockSizes);

  // Print a title, showing the number of cells and the block sizes
  sb := SysUtils.TStringBuilder.Create();
  sb.AppendFormat('%d cells; blocks [', [nrCells]);
  for i := 0 to nrBlocks - 1 do begin
    if (i > 0) then sb.Append(',');
    sb.Append( blockSizes[i]);
  end;
  sb.Append(']');
  WriteLn( sb.ToString());

  blockSum := 0; // total of block sizes
  for i := 0 to nrBlocks - 1 do inc( blockSum, blockSizes[i]);

  gapSum := nrCells - blockSum;
  // Except in the trivial case of no blocks,
  // we reduce the size of each inner gap by 1.
  if nrBlocks > 0 then dec( gapSum, nrBlocks - 1);

  // Work through all solutions and print them nicely.
  nrSolutions := 0;
  SetLength( gapSizes, nrBlocks + 1); // include the gap at each end
  if GetFirstSolution( gapSizes, gapSum) then begin
    repeat
      inc( nrSolutions);
      sb.Clear();
      sb.Append( ' ', MARGIN);
      for i := 0 to nrBlocks - 1 do begin
        sb.Append( GAP_CHAR, gapSizes[i]);
        // We reduced the inner gaps by 1; now we restore the deleted char.
        if (i > 0) then sb.Append( GAP_CHAR);
        sb.Append( BLOCK_CHAR, blockSizes[i]);
      end;
      sb.Append( GAP_CHAR, gapSizes[nrBlocks]);
      WriteLn( sb.ToString());
    until not GetNextSolution( gapSizes);
  end;
  sb.Free();
  WriteLn( SysUtils.Format( 'Number of solutions = %d', [nrSolutions]));
  WriteLn('');
end;

// Main program
begin
  PrintSolutions( 5, [2,1]);
  PrintSolutions( 5, []);
  PrintSolutions( 10, [8]);
  PrintSolutions( 15, [2,3,2,3]);
  PrintSolutions( 5, [2,3]);
end.
