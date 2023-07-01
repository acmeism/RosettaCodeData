function Is_Prime(Item : Positive) return Boolean is
   (Item /= 1 and then
    (for all Test in 2..Integer(Sqrt(Float(Item))) => Item mod Test /= 0));
