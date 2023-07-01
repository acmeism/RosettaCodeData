program RainInFlatland;

{$IFDEF FPC} // Free Pascal
  {$MODE Delphi}
{$ELSE}      // Delphi
  {$APPTYPE CONSOLE}
{$ENDIF}

uses SysUtils;
type THeight = integer;
// Heights could be f.p., but some changes to the code would be needed:
// (1) the inc function isn't available for f.p. values,
// (2) the print-out would need extra formatting.

{------------------------------------------------------------------------------
Find highest tower; if there are 2 or more equal highest, choose any.
Then fill troughs so that on going towards the highest tower, from the
  left-hand or right-hand end, there are no steps down.
Amount of filling required equals amount of water collected.
}
function FillTroughs( const h : array of THeight) : THeight;
var
  m, i, i_max : integer;
  h_max : THeight;
begin
  result := 0;
  m := High( h); // highest index, 0-based; there are m + 1 towers
  if (m <= 1) then exit; // result = 0 if <= 2 towers

  // Find highest tower and its index in the array.
  h_max := h[0];
  i_max := 0;
  for i := 1 to m do begin
    if h[i] > h_max then begin
      h_max := h[i];
      i_max := i;
    end;
  end;
  // Fill troughs from left-hand end to highest tower
  h_max := h[0];
  for i := 1 to i_max - 1 do begin
    if h[i] < h_max then inc( result, h_max - h[i])
                    else h_max := h[i];
  end;
  // Fill troughs from right-hand end to highest tower
  h_max := h[m];
  for i := m - 1 downto i_max + 1 do begin
    if h[i] < h_max then inc( result, h_max - h[i])
                    else h_max := h[i];
  end;
end;

{-------------------------------------------------------------------------
Wrapper for the above: finds amount of water, and prints input and result.
}
procedure CalcAndPrint( h : array of THeight);
var
  water : THeight;
  j : integer;
begin
  water := FillTroughs( h);
  Write( water:5, ' <-- [');
  for j := 0 to High( h) do begin
    Write( h[j]);
    if j < High(h) then Write(', ') else WriteLn(']');
  end;
end;

{---------------------------------------------------------------------------
Main routine.
}
begin
  CalcAndPrint([1,5,3,7,2]);
  CalcAndPrint([5,3,7,2,6,4,5,9,1,2]);
  CalcAndPrint([2,6,3,5,2,8,1,4,2,2,5,3,5,7,4,1]);
  CalcAndPrint([5,5,5,5]);
  CalcAndPrint([5,6,7,8]);
  CalcAndPrint([8,7,7,6]);
  CalcAndPrint([6,7,10,7,6]);
end.
