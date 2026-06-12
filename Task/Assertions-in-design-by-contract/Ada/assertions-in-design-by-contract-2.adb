   procedure Enqueue (Item : in out Queue; Value : Element_Type) with
      Post => Item.Size = Item'Old.Size + 1;
   procedure Dequeue (Item : in out Queue; Value : out Element_Type) with
      Pre  => not Item.Is_Empty,
      Post => Item.Size = Item'Old.Size - 1;
