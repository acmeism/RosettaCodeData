'Implementation of "set" using the built in Collection datatype.
'A collection can hold any object as item. The examples here are only strings.
'A collection stores item, key pairs. With the key you can retrieve the item.
'The keys are hidden and cannot be changed. No duplicate keys are allowed.
'For the "set" implementation item is the same as the key. And keys must
'be a string.
Private Function createSet(t As Variant) As Collection
    Dim x As New Collection
    For Each elem In t
        x.Add elem, elem
    Next elem
    Set createSet = x
End Function
Private Function isElement(s As Variant, x As Collection) As Boolean
    Dim errno As Integer, t As Variant
    On Error GoTo err
    t = x(s)
    isElement = True
    Exit Function
err:
    isElement = False
End Function
Private Function setUnion(A As Collection, B As Collection) As Collection
    Dim x As New Collection
    For Each elem In A
        x.Add elem, elem
    Next elem
    For Each elem In B
        On Error Resume Next 'Trying to add a duplicate throws an error
        x.Add elem, elem
    Next elem
    Set setUnion = x
End Function
Private Function intersection(A As Collection, B As Collection) As Collection
    Dim x As New Collection
    For Each elem In A
        If isElement(elem, B) Then x.Add elem, elem
    Next elem
    For Each elem In B
        If isElement(elem, A) Then
            On Error Resume Next
            x.Add elem, elem
        End If
    Next elem
    Set intersection = x
End Function
Private Function difference(A As Collection, B As Collection) As Collection
    Dim x As New Collection
    For Each elem In A
        If Not isElement(elem, B) Then x.Add elem, elem
    Next elem
    Set difference = x
End Function
Private Function subset(A As Collection, B As Collection) As Boolean
    Dim flag As Boolean
    flag = True
    For Each elem In A
        If Not isElement(elem, B) Then
            flag = False
            Exit For
        End If
    Next elem
    subset = flag
End Function
Private Function equality(A As Collection, B As Collection) As Boolean
    Dim flag As Boolean
    flag = True
    If A.Count = B.Count Then
        For Each elem In A
            If Not isElement(elem, B) Then
                flag = False
                Exit For
            End If
        Next elem
    Else
        flag = False
    End If
    equality = flag
End Function
Private Function properSubset(A As Collection, B As Collection) As Boolean
    Dim flag As Boolean
    flag = True
    If A.Count < B.Count Then
        For Each elem In A
            If Not isElement(elem, B) Then
                flag = False
                Exit For
            End If
        Next elem
    Else
        flag = False
    End If
    properSubset = flag
End Function
Public Sub main()
    'Set creation
    Dim s As Variant
    Dim A As Collection, B As Collection, C As Collection
    s = [{"Apple","Banana","Pear","Pineapple"}]
    Set A = createSet(s) 'Fills the collection A with the elements of s
    'Test m ? S -- "m is an element in set S"
    Debug.Print isElement("Apple", A) 'returns True
    Debug.Print isElement("Fruit", A) 'returns False
    'A ? B -- union; a set of all elements either in set A or in set B.
    s = [{"Fruit","Banana","Pear","Orange"}]
    Set B = createSet(s)
    Set C = setUnion(A, B)
    'A n B -- intersection; a set of all elements in both set A and set B.
    Set C = intersection(A, B)
    'A \ B -- difference; a set of all elements in set A, except those in set B.
    Set C = difference(A, B)
    'A ? B -- subset; true if every element in set A is also in set B.
    Debug.Print subset(A, B)
    'A = B -- equality; true if every element of set A is in set B and vice versa.
    Debug.Print equality(A, B)
    'Proper subset
    Debug.Print properSubset(A, B)
    'Modify -remove an element by key
    A.Remove "Apple"
    'Modify -remove the first element in the collection/set
    A.Remove 1
    'Add "10" to A
    A.Add "10", "10"
End Sub
