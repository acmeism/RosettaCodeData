Type Patient
    ID As String
    LastName As String
End Type

Type Visit
    PatientID As String
    Fecha As String
    Score As Single
    HasScore As Integer
End Type

Dim As Patient patients(5)
Dim As Visit visits(8)

patients(1).ID = "1001": patients(1).LastName = "Hopper"
patients(2).ID = "4004": patients(2).LastName = "Wirth"
patients(3).ID = "3003": patients(3).LastName = "Kemeny"
patients(4).ID = "2002": patients(4).LastName = "Gosling"
patients(5).ID = "5005": patients(5).LastName = "Kurtz"

visits(1).PatientID = "2002": visits(1).Fecha = "2020-09-10": visits(1).Score = 6.8: visits(1).HasScore = -1
visits(2).PatientID = "1001": visits(2).Fecha = "2020-09-17": visits(2).Score = 5.5: visits(2).HasScore = -1
visits(3).PatientID = "4004": visits(3).Fecha = "2020-09-24": visits(3).Score = 8.4: visits(3).HasScore = -1
visits(4).PatientID = "2002": visits(4).Fecha = "2020-10-08": visits(4).HasScore = 0
visits(5).PatientID = "1001": visits(5).Fecha = ""          : visits(5).Score = 6.6: visits(5).HasScore = -1
visits(6).PatientID = "3003": visits(6).Fecha = "2020-11-12": visits(6).HasScore = 0
visits(7).PatientID = "4004": visits(7).Fecha = "2020-11-05": visits(7).Score = 7.0: visits(7).HasScore = -1
visits(8).PatientID = "1001": visits(8).Fecha = "2020-11-19": visits(8).Score = 5.3: visits(8).HasScore = -1

Print "| PATIENT_ID | LASTNAME | LAST_VISIT | SCORE_SUM | SCORE_AVG |"
For i As Integer = 1 To 5
    Dim As String lastVisit = ""
    Dim As Single sum = 0
    Dim As Integer numScores = 0
    For j As Integer = 1 To 8
        If patients(i).ID = visits(j).PatientID Then
            If visits(j).HasScore Then
                sum += visits(j).Score
                numScores += 1
            End If
            If visits(j).Fecha > lastVisit Then
                lastVisit = visits(j).Fecha
            End If
        End If
    Next j
    Print "|       "; patients(i).ID; " | ";
    Print Using "\      \ | \        \ | "; patients(i).LastName; lastVisit;
    If numScores > 0 Then
        Print Using "#######.# | #######.#"; sum; (sum / Csng(numScores));
    Else
        Print "          |          ";
    End If
    Print " |"
Next i

Sleep
