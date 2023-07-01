import Data.List
import Data.List.Ordered

main :: IO ()
main = print $ head [(x0,x1,x2,x3,x4) |
                                        -- choose x0, x1, x2, x3
                                        -- so that 250 < x3 < x2 < x1 < x0
                                        x3 <- [1..250-1],
                                        x2 <- [1..x3-1],
                                        x1 <- [1..x2-1],
                                        x0 <- [1..x1-1],

                                        let p5Sum = x0^5 + x1^5 + x2^5 + x3^5,

                                        -- lazy evaluation of powers of 5
                                        let p5List = [i^5|i <- [1..]],

                                        -- is sum a power of 5 ?
                                        member p5Sum p5List,

                                        -- which power of 5 is sum ?
                                        let Just x4 = elemIndex p5Sum p5List ]
