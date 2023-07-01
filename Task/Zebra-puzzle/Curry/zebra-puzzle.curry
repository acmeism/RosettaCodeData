import Constraint (allC, anyC)
import Findall (findall)


data House  =  H Color Man Pet Drink Smoke

data Color  =  Red    | Green | Blue  | Yellow | White
data Man    =  Eng    | Swe   | Dan   | Nor    | Ger
data Pet    =  Dog    | Birds | Cats  | Horse  | Zebra
data Drink  =  Coffee | Tea   | Milk  | Beer   | Water
data Smoke  =  PM     | DH    | Blend | BM     | Prince


houses :: [House] -> Success
houses hs@[H1,_,H3,_,_] =                         --  1
    H  _ _ _ Milk _  =:=  H3                      --  9
  & H  _ Nor _ _ _   =:=  H1                      -- 10
  & allC (`member` hs)
  [ H  Red Eng _ _ _                              --  2
  , H  _ Swe Dog _ _                              --  3
  , H  _ Dan _ Tea _                              --  4
  , H  Green _ _ Coffee _                         --  6
  , H  _ _ Birds _ PM                             --  7
  , H  Yellow _ _ _ DH                            --  8
  , H  _ _ _ Beer BM                              -- 13
  , H  _ Ger _ _ Prince                           -- 14
  ]
  & H  Green _ _ _ _  `leftTo`  H  White _ _ _ _  --  5
  & H  _ _ _ _ Blend  `nextTo`  H  _ _ Cats _ _   -- 11
  & H  _ _ Horse _ _  `nextTo`  H  _ _ _ _ DH     -- 12
  & H  _ Nor _ _ _    `nextTo`  H  Blue _ _ _ _   -- 15
  & H  _ _ _ Water _  `nextTo`  H  _ _ _ _ Blend  -- 16
 where
    x `leftTo` y = _ ++ [x,y] ++ _ =:= hs
    x `nextTo` y = x `leftTo` y
                 ? y `leftTo` x


member :: a -> [a] -> Success
member = anyC . (=:=)


main = findall $ \(hs,who) -> houses hs & H _ who Zebra _ _ `member` hs
