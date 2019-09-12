Imports System.Math

Module Module1

  Const deg2rad As Double = PI / 180

  Structure AP_Loc
    Public IATA_Code As String, Lat As Double, Lon As Double

    Public Sub New(ByVal iata_code As String, ByVal lat As Double, ByVal lon As Double)
      Me.IATA_Code = iata_code : Me.Lat = lat * deg2rad : Me.Lon = lon * deg2rad
    End Sub

    Public Overrides Function ToString() As String
      Return String.Format("{0}: ({1}, {2})", IATA_Code, Lat / deg2rad, Lon / deg2rad)
    End Function
  End Structure

  Function Sin2(ByVal x As Double) As Double
    Return Pow(Sin(x / 2), 2)
  End Function

  Function calculate(ByVal one As AP_Loc, ByVal two As AP_Loc) As Double
    Dim R As Double = 6371, ' In kilometers, (as recommended by the International Union of Geodesy and Geophysics)
        a As Double = Sin2(two.Lat - one.Lat) + Sin2(two.Lon - one.Lon) * Cos(one.Lat) * Cos(two.Lat)
    Return R * 2 * Asin(Sqrt(a))
  End Function

  Sub ShowOne(pntA As AP_Loc, pntB as AP_Loc)
    Dim adst As Double = calculate(pntA, pntB), sfx As String = "km"
    If adst < 1000 Then adst *= 1000 : sfx = "m"
    Console.WriteLine("The approximate distance between airports {0} and {1} is {2:n2} {3}.", pntA, pntB, adst, sfx)
    Console.WriteLine("The uncertainty is under 0.5%, or {0:n1} {1}." & vbLf, adst / 200, sfx)
  End Sub

' Airport coordinate data excerpted from the data base at http://www.partow.net/miscellaneous/airportdatabase/

' The four additional airports are the furthest and closest pairs, according to the "Fun Facts..." section.

' KBNA, BNA, NASHVILLE INTERNATIONAL, NASHVILLE, USA, 036, 007, 028, N, 086, 040, 041, W, 00183, 36.124, -86.678
' KLAX, LAX, LOS ANGELES INTERNATIONAL, LOS ANGELES, USA, 033, 056, 033, N, 118, 024, 029, W, 00039, 33.942, -118.408
' SKNV, NVA, BENITO SALAS, NEIVA, COLOMBIA, 002, 057, 000, N, 075, 017, 038, W, 00439, 2.950, -75.294
' WIPP, PLM, SULTAN MAHMUD BADARUDDIN II, PALEMBANG, INDONESIA, 002, 053, 052, S, 104, 042, 004, E, 00012, -2.898, 104.701
' LOWL, LNZ, HORSCHING INTERNATIONAL AIRPORT (AUS - AFB), LINZ, AUSTRIA, 048, 014, 000, N, 014, 011, 000, E, 00096, 48.233, 14.183
' LOXL, N/A, LINZ, LINZ, AUSTRIA, 048, 013, 059, N, 014, 011, 015, E, 00299, 48.233, 14.188

  Sub Main()
    ShowOne(New AP_Loc("BNA", 36.124, -86.678),  New AP_Loc("LAX", 33.942, -118.408))
    ShowOne(New AP_Loc("NVA",  2.95,  -75.294),  New AP_Loc("PLM", -2.898,  104.701))
    ShowOne(New AP_Loc("LNZ", 48.233,  14.183),  New AP_Loc("N/A", 48.233,   14.188))
  End Sub
End Module
