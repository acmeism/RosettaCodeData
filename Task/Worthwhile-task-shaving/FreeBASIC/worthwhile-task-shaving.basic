'Rosetta Code problem: https://rosettacode.org/wiki/Worthwhile_task_shaving
'by Jjuanhdez, 02/2023

Dim As Integer shaved(0 To 8) = {1, 5, 30, 60, 300, 1800, 3600, 21600, 86400}
Dim As String columns(0 To 8) = {" 1 SECOND", " 5 SECONDS", "30 SECONDS", _
" 1 MINUTE", " 5 MINUTES", "30 MINUTES", " 1 HOUR", " 6 HOURS", " 1 DAY"}
Dim As Single diy = 365.25
Dim As Integer minuto = 60
Dim As Integer hora = minuto * 60
Dim As Integer dia = hora * 24
Dim As Integer semana = dia * 7
Dim As Integer mes = dia * diy \ 12
Dim As Integer anno = dia * diy

Dim As Integer freq(0 To 5) = {50 * diy, 5 * diy, diy, diy\7, 12, 1}
Dim As Integer y, x, t, mult = 5

Sub fmtTime(t As Single, interval As String)
    t = Int(t + .5)
    Dim As String pl = Iif(t = 1, "", "S")
    Print Using " ## \       \"; t; interval & pl;
End Sub

Print Spc(34); "HOW OFTEN YOU DO THE TASK"
Print " SHAVED OFF   | 50/DAY        5/DAY       DAILY        WEEKLY       MONTHLY      YEARLY"
Print String (92, "-")
For y = 0 To Ubound(columns)
    Print Using "\        \    |"; columns(y);
    For x = 0 To Ubound(freq)
        t = freq(x) * shaved(y) * mult
        If (t < minuto) Then
            fmtTime (t, "SECOND")
        Elseif (t < hora) Then
            fmtTime (t/minuto, "MINUTE")
        Elseif (t < dia) Then
            fmtTime (t/hora, "HOUR")
        Elseif (t < 14 * dia) Then
            fmtTime (t/dia, "DAY")
        Elseif (t < 9 * semana) Then
            fmtTime (t/semana, "WEEK")
        Elseif (t < anno) Then
            fmtTime (t/mes, "MONTH")
        Else
            Print String (13, " ");
        End If
    Next
    Print
Next
