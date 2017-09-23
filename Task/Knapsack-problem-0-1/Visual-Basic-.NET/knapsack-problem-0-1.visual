'Knapsack problem/0-1 - 12/02/2017
Public Class KnapsackBin
    Const knam = 0, kwei = 1, kval = 2
    Const maxWeight = 400
    Dim xList(,) As Object = { _
            {"map", 9, 150}, _
            {"compass", 13, 35}, _
            {"water", 153, 200}, _
            {"sandwich", 50, 160}, _
            {"glucose", 15, 60}, _
            {"tin", 68, 45}, _
            {"banana", 27, 60}, _
            {"ChoiceBinle", 39, 40}, _
            {"cheese", 23, 30}, _
            {"beer", 52, 10}, _
            {"suntan cream", 11, 70}, _
            {"camera", 32, 30}, _
            {"T-shirt", 24, 15}, _
            {"trousers", 48, 10}, _
            {"umbrella", 73, 40}, _
            {"waterproof trousers", 42, 70}, _
            {"waterproof overclothes", 43, 75}, _
            {"note-case", 22, 80}, _
            {"sunglasses", 7, 20}, _
            {"towel", 18, 12}, _
            {"socks", 4, 50}, _
            {"book", 30, 10}}
    Dim s, xss As String, xwei, xval, nn As Integer

    Private Sub KnapsackBin_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        Dim i As Integer
        xListView.View = View.Details
        xListView.Columns.Add("item", 120, HorizontalAlignment.Left)
        xListView.Columns.Add("weight", 50, HorizontalAlignment.Right)
        xListView.Columns.Add("value", 50, HorizontalAlignment.Right)
        For i = 0 To UBound(xList, 1)
            xListView.Items.Add(New ListViewItem(New String() {xList(i, 0), _
                                xList(i, 1).ToString, xList(i, 2).ToString}))
        Next i
    End Sub 'KnapsackBin_Load

    Private Sub cmdOK_Click(sender As Object, e As EventArgs) Handles cmdOK.Click
        Dim i, j, nItems As Integer
        For i = xListView.Items.Count - 1 To 0 Step -1
            xListView.Items.RemoveAt(i)
        Next i
        Me.Refresh()
        nItems = UBound(xList, 1) + 1
        s = ""
        For i = 1 To nItems
            s = s & Chr(i - 1)
        Next
        nn = 0
        Call ChoiceBin(1, "")
        For i = 1 To Len(xss)
            j = Asc(Mid(xss, i, 1))
            xListView.Items.Add(New ListViewItem(New String() {xList(j, 0), _
                                xList(j, 1).ToString, xList(j, 2).ToString}))
        Next i
        xListView.Items.Add(New ListViewItem(New String() {"*Total*", xwei, xval}))
    End Sub 'cmdOK_Click

    Private Sub ChoiceBin(n As String, ss As String)
        Dim r As String, i, j, iwei, ival As Integer
        Dim ipct As Integer
        If n = Len(s) + 1 Then
            iwei = 0 : ival = 0
            For i = 1 To Len(ss)
                j = Asc(Mid(ss, i, 1))
                iwei = iwei + xList(j, 1)
                ival = ival + xList(j, 2)
            Next
            If iwei <= maxWeight And ival > xval Then
                xss = ss : xwei = iwei : xval = ival
            End If
        Else
            r = Mid(s, n, 1)
            Call ChoiceBin(n + 1, ss & r)
            Call ChoiceBin(n + 1, ss)
        End If
    End Sub 'ChoiceBin

End Class 'KnapsackBin
