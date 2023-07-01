reversedPoem =
  String.trim """
    ---------- Ice and Fire ------------

    fire, in end will world the say Some
    ice. in say Some
    desire of tasted I've what From
    fire. favor who those with hold I

    ... elided paragraph last ...

    Frost Robert -----------------------
    """

reverseWords string =
  string |> String.words |> List.reverse |> String.join " "

reverseLinesWords string =
  string |> String.lines |> List.map reverseWords |> String.join "\n"

poem =
  reverseLinesWords reversedPoem
