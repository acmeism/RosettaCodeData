import Element exposing (show, toHtml)  -- elm-package install evancz/elm-graphics
import Html.App exposing (beginnerProgram)
import Array exposing (Array, append, initialize)


xs : Array Int
xs =
  initialize 3 identity  -- [0, 1, 2]

ys : Array Int
ys =
  initialize 3 <| (+) 3  -- [3, 4, 5]

main = beginnerProgram { model = ()
                       , view = \_ -> toHtml (show (append xs ys))
                       , update = \_ _ -> ()
                       }

-- Array.fromList [0,1,2,3,4,5]
