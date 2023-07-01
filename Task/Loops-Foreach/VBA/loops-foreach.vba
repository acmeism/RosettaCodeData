Public Sub LoopsForeach()
    Dim FruitArray() As Variant
    Dim Fruit As Variant
    FruitArray = [{"Apple","Banana","Strawberry"}]
    Dim FruitBasket As Collection
    Set FruitBasket = New Collection
    For Each Fruit In FruitArray
        FruitBasket.Add Fruit
    Next Fruit
    For Each Fruit In FruitBasket
        Debug.Print Fruit
    Next Fruit
End Sub
