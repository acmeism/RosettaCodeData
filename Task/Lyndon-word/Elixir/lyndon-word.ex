defmodule LyndonWord do
  def main do
    alphabet = ["0", "1"]
    max_length = 5
    generate_words(List.first(alphabet), max_length, alphabet)
  end

  defp generate_words("", _max_length, _alphabet), do: :ok
  defp generate_words(word, max_length, alphabet) do
    IO.puts(word)
    next_word = next_word(max_length, word, alphabet)
    generate_words(next_word, max_length, alphabet)
  end

  defp next_word(max_length, word, alphabet) do
    # Step 1: Repeat and truncate to max_length
    next_word0 = word
                 |> String.duplicate(div(max_length, String.length(word)) + 1)
                 |> String.slice(0, max_length)

    # Step 2: Remove trailing last symbols
    last_symbol = List.last(alphabet)
    next_word1 = remove_trailing_symbols(next_word0, last_symbol)

    # Step 3: Replace last symbol with its successor
    if next_word1 == "" do
      ""
    else
      {prefix, last_char} = String.split_at(next_word1, -1)
      idx = Enum.find_index(alphabet, &(&1 == last_char))
      next_char = Enum.at(alphabet, idx + 1)
      prefix <> next_char
    end
  end

  defp remove_trailing_symbols("", _symbol), do: ""
  defp remove_trailing_symbols(word, symbol) do
    if String.ends_with?(word, symbol) do
      word
      |> String.slice(0..-2)
      |> remove_trailing_symbols(symbol)
    else
      word
    end
  end
end

LyndonWord.main()
