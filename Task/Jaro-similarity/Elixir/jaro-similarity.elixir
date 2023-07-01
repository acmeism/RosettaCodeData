defmodule Jaro do
  def distance(s, t) when is_binary(s) and is_binary(t), do:
    distance(to_charlist(s), to_charlist(t))
  def distance(x, x), do: 1.0
  def distance(s, t) do
    s_len = length(s)
    t_len = length(t)
    {s_matches, t_matches, matches} = matching(s, t, s_len, t_len)
    if matches == 0 do
      0.0
    else
      {k, transpositions} = transposition(s, t, s_matches, t_matches)
      ((matches / s_len) +
       (matches / t_len) +
       ((matches - transpositions/2) / matches)) / 3
    end
  end

  defp matching(s, t, s_len, t_len) do
    match_distance = div(max(s_len, t_len), 2) - 1
    ac0 = {List.duplicate(false, s_len), List.duplicate(false, t_len), 0}
    Enum.reduce(0..s_len-1, ac0, fn i,acc ->
      j_start = max(0, i-match_distance)
      j_end = min(i+match_distance, t_len-1)
      Enum.reduce_while(j_start..j_end, acc, fn j,{sm,tm,m} ->
        if Enum.at(tm, j) or Enum.at(s, i) != Enum.at(t, j) do
          {:cont, {sm, tm, m}}
        else
          {:halt, { List.replace_at(sm, i, true),
                    List.replace_at(tm, j, true),
                    m + 1 }}
        end
      end)
    end)
  end

  defp transposition(s, t, s_matches, t_matches) do
    Enum.reduce(0..length(s)-1, {0,0}, fn i,{k,transpositions} ->
      if Enum.at(s_matches, i) do
        k = k + (Enum.drop(t_matches, k)
                 |> Enum.take_while(fn matche -> not matche end)
                 |> length)
        if Enum.at(s, i) == Enum.at(t, k), do: {k+1, transpositions},
                                         else: {k+1, transpositions+1}
      else
        {k, transpositions}
      end
    end)
  end
end

~w( MARTHA    MARHTA
    DIXON     DICKSONX
    JELLYFISH SMELLYFISH )c
|> Enum.chunk(2)
|> Enum.each(fn [s,t] ->
     :io.format "jaro(~s, ~s) = ~.10f~n", [inspect(s), inspect(t), Jaro.distance(s, t)]
   end)
