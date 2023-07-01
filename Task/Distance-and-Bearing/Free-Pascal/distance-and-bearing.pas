program Dist_Bearing;
{$IFDEF FPC} {$Mode DELPHI}{$Optimization ON,ALL} {$ENDIF}
{$IFDEF WINDOWS}{$APPTYPE CONSOLE}{$ENDIF}
uses
  SysUtils,Math;
const
  cDegToRad = pi / 180; cRadToDeg = 180 / pi;
  //One nautical mile ( 1" of earth circumfence )
  cOneNmInKm = (12742*pi)/360/60;
  DiaEarth  = 12742/cOneNmInKm;
type
  tLatLon   = record
                lat,lon:double;
                sinLat,cosLat:double;
                sinLon,cosLon:double;
              end;

  tDist_Dir = record
                distance,bearing:double;
              end;

  tDst_Bear = record
                 Koor1,
                 Koor2 : tLatLon;
                 Dist_Dir : tDist_Dir;
              end;

  tmyName    = String;   //string[63-8] experiment
  tmyCountry = String;   //string[31]
  tmyICAO    = String;   //string[7]
  tSolution = record
                Sol_Name : tmyName;
                Sol_Country :tmyCountry;
                Sol_ICAO : tmyICAO;
                Sol_Koor : tLatLon;
                Sol_dist_dir:tDist_Dir;
              end;

  tIdxDist = record
                Distance: double;
                AirportIdx :Int32;
             end;
  tMinSols = record
               sols : array of tIdxDist;
               maxValue: double;
               actIdx,
               maxidx :Int32;
            end;

var
  Airports: array of tSolution;
  MinSols :tMinSols;
  cntInserts : Cardinal;

procedure GetSolData(const OneAirport: String;
                     var TestSol :tSolution);
var
  p1,p2,i1,i2,idx,l : integer;
begin
  p1:=1;
  idx := 0;
  l := length(OneAirport);

  repeat
    p2 := p1;
    i1 := p1;
    IF OneAirport[p1] <>'"' then
    Begin
      repeat
        p2 +=1;
      until (p2>l) OR (OneAirport[p2]=',');
      i2 := p2;
    end
    else
    begin
      repeat
        p2 +=1;
      until (p2>l) OR (OneAirport[p2]='"');
      i2 := p2;
      i1 +=1;
      while (p2<l) do
      begin
        p2 +=1;
        IF (OneAirport[p2]=',')then
          break;
      end;
    end;
    idx += 1;

    with TestSol do
    case idx of
      2: Sol_Name := copy(OneAirport,i1,i2-i1);
      4: Sol_Country := copy(OneAirport,i1,i2-i1);
      6: Sol_ICAO := copy(OneAirport,i1,i2-i1);
      7: Begin
           With Sol_Koor do begin
             lat := StrtoFloat(copy(OneAirport,i1,i2-i1))*cDegToRad;
             sincos(lat,sinLat,cosLat);
           end;
         end;
      8: Begin
           With Sol_Koor do begin
             lon := StrtoFloat(copy(OneAirport,i1,i2-i1))*cDegToRad;
             sincos(lon,sinLon,cosLon);
           end;
         end;
    end;
    p1:= p2+1;
  until (idx>7) OR (p1>l);
end;

function ReadAirports(fileName:String):boolean;
var
  TF_Buffer : array[0..1 shl 14 -1] of byte;
  AirportsFile: TextFile;
  OneAirport : String;
  l,cnt : UInt32;
begin
  Assign(AirportsFile,fileName);
  settextbuf(AirportsFile,TF_Buffer);
  {$I-}
  reset(AirportsFile);
  {$I+}
  IF ioResult <> 0 then
  Begin
    Close(AirportsFile);
    EXIT(false);
  end;
  cnt := 0;
  l := 100;
  setlength(Airports,l);

  while Not(EOF(AirportsFile)) do
  Begin
    Readln(AirportsFile,OneAirport);
    GetSolData(OneAirport,Airports[cnt]);
    inc(cnt);
    if cnt >= l then
    Begin
      l := l*13 div 8;
      setlength(Airports,l);
    end;
  end;
  setlength(Airports,cnt);
  Close(AirportsFile);
  exit(true);
end;

procedure Out_MinSol;
var
  i: integer;
begin
writeln(' ICAO Distance Bearing Country        Airport');
writeln(' ---- -------- ------- -------------- -----------------------------------');
  For i := 0 to minSols.actidx do
    with AirPorts[minSols.sols[i].AirportIdx] do
      writeln(Format(' %4s %8.1f %7.0f %-14s  %-35s',
                     [Sol_ICAO,
                      Sol_dist_dir.distance*DiaEarth,
                      Sol_dist_dir.bearing*cRadToDeg,
                      Sol_Country,Sol_Name]));
  writeln;
  writeln(cntInserts,' inserts to find them');
end;

procedure Init_MinSol(MaxSolCount:Int32);
begin
  setlength(MinSols.sols,MaxSolCount+1);
  MinSols.actIdx := -1;
  MinSols.maxIdx := MaxSolCount-1;
  MinSols.MaxValue := maxdouble;
  cntInserts := 0;
end;

procedure Insert_Sol(var sol:tDst_Bear;nrAirport:Int32);
var
  dist : double;
  idx : Int32;
begin
  with MinSols do
  begin
    idx := actIdx;
    dist := sol.Dist_Dir.distance;

    if Idx >= maxIdx then
      IF MaxValue < dist then
        Exit;

    if idx >= 0 then
    begin
      inc(idx);
      inc(cntInserts);

      while sols[idx-1].Distance >dist do
      begin
        sols[idx]:= sols[idx-1];
        dec(idx);
        If idx<=0 then
          BREAK;
      end;
      with sols[idx] do
      begin
        AirportIdx := nrAirport;
        Distance := dist;
      end;
      //update AirPorts[nrAirport] with right distance/bearing
      AirPorts[nrAirport].Sol_dist_dir := sol.Dist_Dir;
      if actIdx < maxIdx then
         actIdx +=1;
    end
    else
    begin
      with sols[0] do
      begin
        AirportIdx := nrAirport;
        Distance := dist;
      end;
      AirPorts[nrAirport].Sol_dist_dir := sol.Dist_Dir;
      MinSols.actIdx := 0;
    end;
    MaxValue := sols[actIdx].Distance;
  end;
end;

procedure Calc_Dist_bear(var Dst_Bear:tDst_Bear);
var
  dLonSin,dLonCos,x,y : double;
begin
  with Dst_Bear do
  Begin
    If (Koor1.Lat = Koor2.Lat) AND (Koor1.Lon = Koor2.Lon) then
    Begin
      Dist_Dir.distance := 0;
      Dist_Dir.bearing  := 0;
      Exit;
    end;
    sincos(Koor1.lon - Koor2.lon,dLonSin,dLonCos);
    //distance
    Dist_Dir.distance := arcsin(sqrt(sqr(dLonCos * Koor1.Coslat
              - Koor2.Coslat) + sqr(dLonSin* Koor1.Coslat)
              + sqr(Koor1.sinlat - Koor2.sinlat)) / 2);

    x := dLonSin*Koor2.Coslat;
    y := Koor1.Coslat*Koor2.sinlat - Koor1.sinlat*Koor2.Coslat*dLonCos;
    //bearing dLonSin as tmp
    dLonSin := ArcTan2(x,y);
    if dLonSin < 0 then
      dLonSin := -dLonSin
    else
      dLonSin := 2*pi-dLonSin;
    Dist_Dir.bearing  := dLonSin;
  end;
end;

procedure FindNearest(var testKoors : tDst_Bear;cntAirports,cntNearest:Integer);
var
  i : Int32;
begin
  Init_MinSol(cntNearest);
  For i := 0 to cntAirports-1 do
  Begin
    testKoors.Koor2 := AirPorts[i].Sol_Koor;
    Calc_Dist_bear(testKoors);
    Insert_Sol(testKoors,i);
  end;
end;

const
  rounds = 100;
  cntNearest = 20;//128;//8000;
var
  T1,T0 : Int64;
  testKoors : tDst_Bear;
  myKoor : tLatLon;
  i,cntAirports : integer;
begin


  T0 := Gettickcount64;
  IF NOT(ReadAirports('airports.dat')) then
    HALT(129);
  T1 := Gettickcount64;
  Writeln((T1-T0),' ms for reading airports.dat');
  cntAirports := length(AirPorts);

  with myKoor do
  begin
    lat := 51.514669*cDegToRad;
    lon :=  2.198581*cDegToRad;
    sincos(lat,sinLat,cosLat);
    sincos(lon,sinLon,cosLon);
  end;

  randomize;
  T0 := Gettickcount64;
  For i := rounds-2 downto 0 do
  Begin
    testKoors.Koor1 := AirPorts[random(cntAirports)].Sol_Koor;
    FindNearest(testKoors,cntAirports,cntNearest);
  end;
  testKoors.Koor1 := myKoor;
  FindNearest(testKoors,cntAirports,cntNearest);
  T1 := Gettickcount64;
  Writeln((T1-T0),' ms for searching ',rounds,' times of '
                   ,cntNearest,' nearest out of ',cntAirports,' airports');
  writeln(cntInserts,' inserts to find them');
  writeln;

  FindNearest(testKoors,cntAirports,20);
  with myKoor do
    writeln(Format('Nearest to latitude %7.5f,longitude %7.5f degrees',
                   [cRadToDeg*lat,cRadToDeg*lon]));
  writeln;
  Out_MinSol;
end.
