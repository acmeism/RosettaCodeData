defmodule CykParser do
  _ = @moduledoc """
  CYK parser implementation. Returns true if W is valid under R rules.
  """

  _ = @doc """
  Main CYK parsing function
  """

  @start_symbol "NP"

  def cyk_parse(w, r) do
    n = length(w)
    t = initialize_table(n)
    t1 = fill_table(w, r, n, t)

    MapSet.member?(get_cell(t1, 1, n), @start_symbol)
  end

  # Initialize the parsing table with empty sets
  defp initialize_table(n) do
    for i <- 1..n, j <- 1..n, into: %{} do
      {{i, j}, MapSet.new()}
    end
  end

  # Fill the parsing table using CYK algorithm
  defp fill_table(w, r, n, t) do
    fill_columns(w, r, n, 1, t)
  end

  defp fill_columns(_w, _r, n, j, t) when j > n, do: t

  defp fill_columns(w, r, n, j, t) do
    # Fill terminal productions
    word = Enum.at(w, j - 1)
    t1 = add_terminals(r, word, j, t)

    # Fill non-terminal productions
    t2 = fill_backward(r, j, j, t1)

    fill_columns(w, r, n, j + 1, t2)
  end

  # Add terminal productions to table
  defp add_terminals(r, word, j, t) do
    Enum.reduce(r, t, fn {lhs, rules}, acc ->
      if has_terminal_rule?(rules, word) do
        add_to_cell(acc, j, j, lhs)
      else
        acc
      end
    end)
  end

  # Check if rules contain a terminal production for word
  defp has_terminal_rule?(rules, word) do
    Enum.any?(rules, fn rule ->
      length(rule) == 1 and hd(rule) == word
    end)
  end

  # Fill backward diagonally from position j
  defp fill_backward(_r, i, _j, t) when i < 1, do: t

  defp fill_backward(r, i, j, t) do
    t1 = fill_splits(r, i, j, i, j - 1, t)
    fill_backward(r, i - 1, j, t1)
  end

  # Try all split points k from i to j-1
  defp fill_splits(_r, _i, _j, k, max_k, t) when k > max_k, do: t

  defp fill_splits(r, i, j, k, max_k, t) do
    t1 = check_all_rules(r, i, j, k, t)
    fill_splits(r, i, j, k + 1, max_k, t1)
  end

  # Check all grammar rules for a split point
  defp check_all_rules(r, i, j, k, t) do
    Enum.reduce(r, t, fn {lhs, rules}, acc ->
      check_rules(lhs, rules, i, j, k, acc)
    end)
  end

  # Check individual rules
  defp check_rules(_lhs, [], _i, _j, _k, t), do: t

  defp check_rules(lhs, [rule | rest], i, j, k, t) do
    t1 = if length(rule) == 2 do
      [rhs1, rhs2] = rule
      left_cell = get_cell(t, i, k)
      right_cell = get_cell(t, k + 1, j)

      if MapSet.member?(left_cell, rhs1) and MapSet.member?(right_cell, rhs2) do
        add_to_cell(t, i, j, lhs)
      else
        t
      end
    else
      t
    end

    check_rules(lhs, rest, i, j, k, t1)
  end

  # Helper functions for table manipulation
  defp get_cell(t, i, j) do
    Map.get(t, {i, j}, MapSet.new())
  end

  defp add_to_cell(t, i, j, element) do
    cell = get_cell(t, i, j)
    new_cell = MapSet.put(cell, element)
    Map.put(t, {i, j}, new_cell)
  end

  _ = @doc """
  Test the CYK parser with a sample grammar and input string
  """

  def main do
    r = %{
      "NP" => [["Det", "Nom"]],
      "Nom" => [
        ["AP", "Nom"],
        ["book"],
        ["orange"],
        ["man"]
      ],
      "AP" => [
        ["Adv", "A"],
        ["heavy"],
        ["orange"],
        ["tall"]
      ],
      "Det" => [["a"]],
      "Adv" => [["very"], ["extremely"]],
      "A" => [
        ["heavy"],
        ["orange"],
        ["tall"],
        ["muscular"]
      ]
    }

    w = String.split("a very heavy orange book", " ")
    result = cyk_parse(w, r)
    IO.puts("CYK Parse Result: #{inspect(result)}")
    result
  end
end


CykParser.main()
