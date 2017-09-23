import qualified Data.Set as Set
type Set=Set.Set
unionAll :: (Ord a) => Set (Set a) -> Set a
unionAll = Set.fold Set.union Set.empty

--slift is the analogue of liftA2 for sets.
slift :: (Ord a, Ord b, Ord c) => (a->b->c) -> Set a -> Set b -> Set c
slift f s0 s1 = unionAll (Set.map (\e->Set.map (f e) s1) s0)

--a -> {{},{a}}
makeSet :: (Ord a) => a -> Set (Set a)
makeSet = (Set.insert Set.empty) . Set.singleton.Set.singleton

powerSet :: (Ord a) => Set a -> Set (Set a)
powerSet = (Set.fold (slift Set.union) (Set.singleton Set.empty)) . Set.map makeSet
