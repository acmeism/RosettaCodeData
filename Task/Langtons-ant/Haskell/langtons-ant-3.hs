data State = State { antPosition :: Point
                   , antDirection :: Point
                   , getCells :: Set Point }

type Point = (Float, Float)
