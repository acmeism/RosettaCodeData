defmodule ConvexHullAlgorithm do
  defmodule Point do
    @enforce_keys [:x, :y]
    defstruct [:x, :y]

    def new(x \\ 0, y \\ 0) do
      %Point{x: x, y: y}
    end

    def compare(%Point{x: x1, y: y1}, %Point{x: x2, y: y2}) do
      cond do
        x1 == x2 -> compare_float(y1, y2)
        true -> compare_float(x1, x2)
      end
    end

    def compare_float(a, b) do
      cond do
        a < b -> -1
        a > b -> 1
        true -> 0
      end
    end

    def less_than(%Point{x: x1, y: y1}, %Point{x: x2, y: y2}) do
      cond do
        x1 == x2 -> y1 < y2
        true -> x1 < x2
      end
    end

    def greater_than(%Point{x: x1, y: y1}, %Point{x: x2, y: y2}) do
      cond do
        x1 == x2 -> y1 > y2
        true -> x1 > x2
      end
    end
  end

  def flipped(points) do
    Enum.map(points, fn point ->
      Point.new(-point.x, -point.y)
    end)
  end

  def quick_select(list, index) do
    quick_select(list, index, 0, length(list) - 1)
  end

  def quick_select(list, _index, lo, hi) when lo == hi do
    Enum.at(list, lo)
  end

  def quick_select(list, index, lo, hi) do
    pivot_index = lo + :rand.uniform(hi - lo + 1) - 1
    pivot_value = Enum.at(list, pivot_index)
    list = swap(list, lo, pivot_index)

    {list, cur} = Enum.reduce(lo + 1..hi, {list, lo}, fn run, {acc_list, acc_cur} ->
      if compare_elements(Enum.at(acc_list, run), pivot_value) < 0 do
        {swap(acc_list, acc_cur + 1, run), acc_cur + 1}
      else
        {acc_list, acc_cur}
      end
    end)

    list = swap(list, cur, lo)

    cond do
      index < cur -> quick_select(list, index, lo, cur - 1)
      index > cur -> quick_select(list, index, cur + 1, hi)
      true -> Enum.at(list, cur)
    end
  end

  defp compare_elements(a, b) when is_float(a) and is_float(b), do: Point.compare_float(a, b)
  defp compare_elements(%Point{} = a, %Point{} = b), do: Point.compare(a, b)

  defp swap(list, i, j) do
    temp = Enum.at(list, i)
    list = List.replace_at(list, i, Enum.at(list, j))
    List.replace_at(list, j, temp)
  end

  def bridge(points, vertical_line) do
    points_list = MapSet.to_list(points)

    if MapSet.size(points) == 2 do
      sorted_points = Enum.sort(points_list, &(Point.compare(&1, &2) < 0))
      [Enum.at(sorted_points, 0), Enum.at(sorted_points, 1)]
    else
      candidates = MapSet.new()
      pairs = []

      {pairs, candidates} =
        points_list
        |> Enum.chunk_every(2, 2, :discard)
        |> Enum.reduce({pairs, candidates}, fn [p1, p2], {pairs_acc, candidates_acc} ->
          if Point.less_than(p1, p2) do
            {pairs_acc ++ [[p1, p2]], candidates_acc}
          else
            {pairs_acc ++ [[p2, p1]], candidates_acc}
          end
        end)

      candidates =
        if rem(length(points_list), 2) == 1 do
          MapSet.put(candidates, List.last(points_list))
        else
          candidates
        end

      {slopes, valid_pairs} =
        Enum.reduce(pairs, {[], []}, fn [p1, p2] = pair, {slopes_acc, valid_pairs_acc} ->
          if p1.x == p2.x do
            if p1.y > p2.y do
              {slopes_acc, valid_pairs_acc}
            else
              {slopes_acc, valid_pairs_acc}
            end
          else
            slope = (p1.y - p2.y) / (p1.x - p2.x)
            {slopes_acc ++ [slope], valid_pairs_acc ++ [pair]}
          end
        end)

      if Enum.empty?(slopes) do
        if MapSet.size(candidates) >= 2 do
          candidate_list = MapSet.to_list(candidates) |> Enum.sort(&(Point.compare(&1, &2) < 0))
          [List.first(candidate_list), List.last(candidate_list)]
        else
          [List.first(points_list), Enum.at(points_list, 1)]
        end
      else
        median_index = div(length(slopes), 2) - (if rem(length(slopes), 2) == 0, do: 1, else: 0)
        median_slope = quick_select(slopes, median_index)

        {small, equal, large} =
          Enum.zip(slopes, valid_pairs)
          |> Enum.reduce({[], [], []}, fn {slope, pair}, {small_acc, equal_acc, large_acc} ->
            cond do
              slope < median_slope -> {small_acc ++ [pair], equal_acc, large_acc}
              slope == median_slope -> {small_acc, equal_acc ++ [pair], large_acc}
              true -> {small_acc, equal_acc, large_acc ++ [pair]}
            end
          end)

        max_intercept =
          points_list
          |> Enum.map(fn point -> point.y - median_slope * point.x end)
          |> Enum.max()

        max_set =
          points_list
          |> Enum.filter(fn point -> point.y - median_slope * point.x == max_intercept end)

        left = Enum.min_by(max_set, &(&1.x))
        right = Enum.max_by(max_set, &(&1.x))

        if left.x <= vertical_line && right.x > vertical_line do
          [left, right]
        else
          new_candidates =
            if right.x <= vertical_line do
              candidates =
                large
                |> Enum.reduce(candidates, fn [_, p2], acc -> MapSet.put(acc, p2) end)

              candidates =
                equal
                |> Enum.reduce(candidates, fn [_, p2], acc -> MapSet.put(acc, p2) end)

              small
              |> Enum.reduce(candidates, fn [p1, p2], acc ->
                acc |> MapSet.put(p1) |> MapSet.put(p2)
              end)
            else
              candidates =
                small
                |> Enum.reduce(candidates, fn [p1, _], acc -> MapSet.put(acc, p1) end)

              candidates =
                equal
                |> Enum.reduce(candidates, fn [p1, _], acc -> MapSet.put(acc, p1) end)

              large
              |> Enum.reduce(candidates, fn [p1, p2], acc ->
                acc |> MapSet.put(p1) |> MapSet.put(p2)
              end)
            end

          bridge(new_candidates, vertical_line)
        end
      end
    end
  end

  def connect(lower, upper, points) do
    if lower == upper do
      [lower]
    else
      points_vec = MapSet.to_list(points) |> Enum.sort(&(Point.compare(&1, &2) < 0))
      mid_index = div(length(points_vec) - 1, 2)

      max_left = quick_select(points_vec, mid_index)
      min_right = quick_select(points_vec, mid_index + 1)

      [left, right] = bridge(points, (max_left.x + min_right.x) / 2)

      points_left = MapSet.new([left])
      points_right = MapSet.new([right])

      {points_left, points_right} =
        points
        |> Enum.reduce({points_left, points_right}, fn point, {left_acc, right_acc} ->
          cond do
            point.x < left.x -> {MapSet.put(left_acc, point), right_acc}
            point.x > right.x -> {left_acc, MapSet.put(right_acc, point)}
            true -> {left_acc, right_acc}
          end
        end)

      left_result = connect(lower, left, points_left)
      right_result = connect(right, upper, points_right)

      left_result ++ right_result
    end
  end

  def upper_hull(points) do
    lower = Enum.min_by(points, &(&1.x))

    # Find the lowest point with same x-coordinate as minimum
    lower =
      points
      |> Enum.filter(fn point -> point.x == lower.x && point.y > lower.y end)
      |> Enum.reduce(lower, fn point, acc ->
        if point.y > acc.y, do: point, else: acc
      end)

    upper = Enum.max_by(points, &(&1.x))

    filtered_points =
      points
      |> Enum.filter(fn point ->
        lower.x < point.x && point.x < upper.x || point == lower || point == upper
      end)
      |> MapSet.new()

    connect(lower, upper, filtered_points)
  end

  def convex_hull(points) do
    upper = upper_hull(points)

    flipped_points =
      points
      |> Enum.map(fn p -> Point.new(-p.x, -p.y) end)
      |> MapSet.new()

    flipped_upper = upper_hull(flipped_points)
    lower = flipped(flipped_upper)

    # Remove duplicate points at the start/end
    {upper, lower} =
      if Enum.count(upper) > 0 && Enum.count(lower) > 0 do
        upper_clean =
          if List.last(upper) == List.first(lower) do
            List.delete_at(upper, -1)
          else
            upper
          end

        lower_clean =
          if List.first(upper_clean) == List.last(lower) do
            List.delete_at(lower, -1)
          else
            lower
          end

        {upper_clean, lower_clean}
      else
        {upper, lower}
      end

    upper ++ lower
  end

  def main do
    points = MapSet.new([
      Point.new(0.0, 0.0),   # projection of [0.0, 0.0, 0.0]
      Point.new(1.0, 0.0),   # projection of [1.0, 0.0, 0.0]
      Point.new(0.0, 1.0),   # projection of [0.0, 1.0, 0.0]
      Point.new(0.5, 0.5)    # projection of [0.0, 0.0, 1.0] (projected to 2D)
    ])

    IO.puts("Input points:")
    points
    |> Enum.each(fn p ->
      IO.puts("(#{p.x}, #{p.y})")
    end)

    hull = convex_hull(points)

    IO.puts("\nConvex hull points:")
    hull
    |> Enum.each(fn p ->
      IO.puts("(#{p.x}, #{p.y})")
    end)
  end
end

# To run the algorithm
ConvexHullAlgorithm.main()
