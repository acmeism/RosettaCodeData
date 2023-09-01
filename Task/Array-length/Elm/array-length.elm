import Array
import Html

main : Html.Html
main =
    ["apple", "orange"]
      |> Array.fromList
      |> Array.length
      |> String.fromInt
      |> Html.text
