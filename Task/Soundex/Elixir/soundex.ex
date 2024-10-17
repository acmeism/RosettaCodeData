defmodule Soundex do
  def soundex([]), do: []
  def soundex(str) do
    [head|tail] = String.upcase(str) |> to_char_list
    [head | isoundex(tail, [], todigit(head))]
  end

  defp isoundex([], acc, _) do
    case length(acc) do
      n when n == 3 -> Enum.reverse(acc)
      n when n <  3 -> isoundex([], [?0 | acc], :ignore)
      n when n >  3 -> isoundex([], Enum.slice(acc, n-3, n), :ignore)
    end
  end
  defp isoundex([head|tail], acc, lastn) do
    dig = todigit(head)
    if dig != ?0 and dig != lastn do
      isoundex(tail, [dig | acc], dig)
    else
      case head do
        ?H                 -> isoundex(tail, acc, lastn)
        ?W                 -> isoundex(tail, acc, lastn)
        n when n in ?A..?Z -> isoundex(tail, acc, dig)
        _                  -> isoundex(tail, acc, lastn)  # This clause handles non alpha characters
      end
    end
  end

  @digits  '01230120022455012623010202'
  defp todigit(chr) do
    if chr in ?A..?Z, do: Enum.at(@digits, chr - ?A),
                    else: ?0            # Treat non alpha characters as a vowel
  end
end

IO.puts Soundex.soundex("Soundex")
IO.puts Soundex.soundex("Example")
IO.puts Soundex.soundex("Sownteks")
IO.puts Soundex.soundex("Ekzampul")
