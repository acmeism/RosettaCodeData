Function rnd2 As Single
    Return Rnd()-Rnd()
End Function

Type Perceptron
    Declare Constructor(Byval n As Integer)
    Declare Function feedforward(Byval in As Single Ptr) As Integer
    Declare Function activate(Byval sum As Single) As Integer
    Declare Sub      train(Byval in As Single Ptr, Byval uit As Integer)
    As Integer    lastItem
    As Single Ptr weights
    As Single c = 0.01
End Type

Constructor Perceptron(Byval n As Integer)
    lastItem = n-1
    weights = New Single[n]
    For i As Integer = 0 To lastItem
        weights[i] = rnd2()
    Next i
End Constructor

Function Perceptron.feedforward(Byval in As Single Ptr) As Integer
    Dim As Single sum
    For i As Integer = 0 To lastItem
        sum += in[i] * weights[i]
    Next
    Return activate(sum)
End Function

Function Perceptron.activate(Byval sum As Single) As Integer
    Return Iif(sum>0, 1, -1)
End Function

Sub Perceptron.train(Byval in As Single Ptr, Byval uit As Integer)
    Dim As Integer gues = feedforward(in)
    Dim As Single error_ = uit - gues
    For i As Integer = 0  To lastitem
        weights[i] += c * error_ * in[i]
    Next
End Sub

Type Trainer
    Declare Constructor (Byval x As Single, Byval y As Single, Byval a As Integer)
    As Single inputs(2)
    As Integer answer
End Type

Constructor Trainer(Byval x As Single, Byval y As Single, Byval a As Integer)
    inputs(0) = x
    inputs(1) = y
    inputs(2) = 1.0
    answer = a
End Constructor

Function f(Byval x As Single) As Single
    Return 2 * x + 1
End Function

Const As Integer NTRAINERS = 2000
Const As Integer NWIDTH  = 640
Const As Integer NHEIGHT = 360
Dim Shared As Perceptron Ptr ptron
Dim Shared As Trainer    Ptr training(NTRAINERS-1)
Dim Shared As Integer        count

Sub setup()
    count = 0
    Screenres NWIDTH, NHEIGHT
    ptron = New Perceptron(3)
    For i As Integer = 0  To NTRAINERS-1
        Dim As Single x = rnd2() * NWIDTH /2
        Dim As Single y = rnd2() * NHEIGHT/2
        Dim As Integer answer = 1
        If (y < f(x)) Then answer = -1
        training(i) = New Trainer(x , y , answer)
    Next i
End Sub

Sub drawit()
    ptron -> train(@training(count)->inputs(0), training(count)->answer)
    count = (count + 1) Mod NTRAINERS
    For i As Integer = 0 To count
        Dim As Integer gues = ptron->feedforward(@training(i)->inputs(0))
        If (gues  > 0) Then
            Circle(NWIDTH/2+training(i)->inputs(0),NHEIGHT/2+training(i)->inputs(1)),8,8
        Else
            Circle(NWIDTH/2+training(i)->inputs(0),NHEIGHT/2+training(i)->inputs(1)),8,8,,,,f
        End If
    Next i
End Sub

setup()
While Inkey() = ""
    drawit()
    Sleep 100
Wend
