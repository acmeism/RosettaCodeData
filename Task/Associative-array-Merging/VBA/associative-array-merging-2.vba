Sub Main_With_Dictionary()
Dim Base As Object, Update As Object, Merged As Object, K As Variant
    'INIT VARIABLE
    Set Base = CreateObject("Scripting.Dictionary")
    Set Update = CreateObject("Scripting.Dictionary")
    Set Merged = Base
    'FILL Base & Update
    Base.Add "name", "Rocket Skates"
    Base.Add "price", 12.75
    Base.Add "color", "yellow"
    Update.Add "price", 15.25
    Update.Add "color", "red"
    Update.Add "year", 1974
    'Fill Merge
    For Each K In Update.Keys
        Merged(K) = Update(K)
    Next
    'Print Out
    Debug.Print "Key", "Value"
    For Each K In Merged.Keys
        Debug.Print K, Merged(K)
    Next K
End Sub
