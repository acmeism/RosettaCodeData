defmodule KDTree do
  @moduledoc """
  K-D Tree implementation for nearest neighbor search in k-dimensional space.
  """

  # Tree data structure
  # {:node, value, left, right} | :empty
  # KDTree: %{dims: [function], tree: tree}

  defstruct dims: [], tree: :empty

  @doc """
  Create an empty k-d tree with the given dimensional accessors.
  """
  def empty(dims) do
    %KDTree{dims: dims, tree: :empty}
  end

  @doc """
  Create a k-d tree with a single value.
  """
  def singleton(dims, value) do
    empty(dims) |> insert(value)
  end

  @doc """
  Insert a value into a k-d tree.
  """
  def insert(%KDTree{dims: dims, tree: tree} = kdtree, value) do
    cyclic_dims = Stream.cycle(dims)
    new_tree = ins(cyclic_dims, tree, value)
    %{kdtree | tree: new_tree}
  end

  defp ins(_dims, :empty, value) do
    {:node, value, :empty, :empty}
  end

  defp ins(dims, {:node, split, left, right}, value) do
    [d] = Enum.take(dims, 1)
    remaining_dims = Stream.drop(dims, 1)

    if d.(value) < d.(split) do
      {:node, split, ins(remaining_dims, left, value), right}
    else
      {:node, split, left, ins(remaining_dims, right, value)}
    end
  end

  @doc """
  Create a k-d tree from a list using the median-finding algorithm.
  """
  def from_list(dims, values) do
    cyclic_dims = Stream.cycle(dims)
    tree = f_list(cyclic_dims, values)
    %KDTree{dims: dims, tree: tree}
  end

  defp f_list(_dims, []) do
    :empty
  end

  defp f_list(dims, values) do
    [d] = Enum.take(dims, 1)
    remaining_dims = Stream.drop(dims, 1)

    sorted = Enum.sort_by(values, d)
    length = length(sorted)
    mid_index = div(length, 2)

    {lower, higher} = Enum.split(sorted, mid_index)

    case higher do
      [] ->
        :empty
      [median | rest] ->
        {:node, median, f_list(remaining_dims, lower), f_list(remaining_dims, rest)}
    end
  end

  @doc """
  Create a k-d tree from a list by repeatedly inserting values.
  Faster than median-finding but can create unbalanced trees.
  """
  def from_list_linear(dims, values) do
    Enum.reduce(values, empty(dims), &insert(&2, &1))
  end

  @doc """
  Find the nearest value to a given value.
  Returns {nearest_value_or_nil, nodes_visited}.
  """
  def nearest(%KDTree{dims: dims, tree: tree}, value) do
    cyclic_dims = Stream.cycle(dims)
    near(cyclic_dims, tree, value, dims)
  end

  defp near(_dims, :empty, _value, _all_dims) do
    {nil, 1}
  end

  defp near(_dims, {:node, split, :empty, :empty}, _value, _all_dims) do
    {split, 1}
  end

  defp near(dims, {:node, split, left, right}, value, all_dims) do
    [d] = Enum.take(dims, 1)
    remaining_dims = Stream.drop(dims, 1)

    split_dist = sqr_dist(all_dims, value, split)
    hyperplane_dist = square(d.(value) - d.(split))

    {best_left, left_count} = near(remaining_dims, left, value, all_dims)
    {best_right, right_count} = near(remaining_dims, right, value, all_dims)

    {{maybe_this_best, this_count}, {maybe_other_best, other_count}} =
      if d.(value) < d.(split) do
        {{best_left, left_count}, {best_right, right_count}}
      else
        {{best_right, right_count}, {best_left, left_count}}
      end

    case maybe_this_best do
      nil ->
        count = 1 + this_count + other_count
        case maybe_other_best do
          nil ->
            {split, count}
          other_best ->
            if sqr_dist(all_dims, value, other_best) < split_dist do
              {other_best, count}
            else
              {split, count}
            end
        end

      this_best ->
        this_best_dist = sqr_dist(all_dims, value, this_best)
        {best, best_dist} =
          if split_dist < this_best_dist do
            {split, split_dist}
          else
            {this_best, this_best_dist}
          end

        if best_dist < hyperplane_dist do
          {best, 1 + this_count}
        else
          count = 1 + this_count + other_count
          case maybe_other_best do
            nil ->
              {best, count}
            other_best ->
              if best_dist < sqr_dist(all_dims, value, other_best) do
                {best, count}
              else
                {other_best, count}
              end
          end
        end
    end
  end

  @doc """
  Calculate squared Euclidean distance between two points.
  """
  def sqr_dist(dims, a, b) do
    a_values = Enum.map(dims, & &1.(a))
    b_values = Enum.map(dims, & &1.(b))

    Enum.zip(a_values, b_values)
    |> Enum.map(fn {x, y} -> square(x - y) end)
    |> Enum.sum()
  end

  defp square(x), do: x * x

  @doc """
  Dimensional accessors for 2-tuple.
  """
  def tuple_2d do
    [&elem(&1, 0), &elem(&1, 1)]
  end

  @doc """
  Dimensional accessors for 3-tuple.
  """
  def tuple_3d do
    [&elem(&1, 0), &elem(&1, 1), &elem(&1, 2)]
  end

  @doc """
  Naive nearest search for verification.
  """
  def linear_nearest(_dims, _value, []) do
    nil
  end

  def linear_nearest(dims, value, [head | tail]) do
    Enum.min_by([head | tail], &sqr_dist(dims, value, &1))
  end

  @doc """
  Print search results.
  """
  def print_results(point, {nearest, visited}, dims) do
    case nearest do
      nil ->
        IO.puts("Could not find nearest.")
      value ->
        dist = :math.sqrt(sqr_dist(dims, point, value))
        IO.puts("Point:    #{inspect(point)}")
        IO.puts("Nearest:  #{inspect(value)}")
        IO.puts("Distance: #{dist}")
        IO.puts("Visited:  #{visited}")
        IO.puts("")
    end
  end

  @doc """
  Generate random 3D points.
  """
  def random_3d_points(n, {min_x, min_y, min_z}, {max_x, max_y, max_z}) do
    for _ <- 1..n do
      {
        min_x + :rand.uniform() * (max_x - min_x),
        min_y + :rand.uniform() * (max_y - min_y),
        min_z + :rand.uniform() * (max_z - min_z)
      }
    end
  end

  @doc """
  Main demonstration function.
  """
  def main do
    # Wikipedia example
    wiki_values = [{2, 3}, {5, 4}, {9, 6}, {4, 7}, {8, 1}, {7, 2}]
    wiki_tree = from_list(tuple_2d(), wiki_values)
    wiki_search = {9, 2}
    wiki_nearest = nearest(wiki_tree, wiki_search)

    IO.puts("Wikipedia example:")
    print_results(wiki_search, wiki_nearest, tuple_2d())

    # Random 3D example
    :rand.seed(:exsplus, {1, 2, 3})  # Seed for reproducible results
    rand_range = {{0, 0, 0}, {1000, 1000, 1000}}
    rand_values = random_3d_points(1000, elem(rand_range, 0), elem(rand_range, 1))
    rand_search = hd(random_3d_points(1, elem(rand_range, 0), elem(rand_range, 1)))
    rand_tree = from_list(tuple_3d(), rand_values)
    rand_nearest = nearest(rand_tree, rand_search)
    rand_nearest_linear = linear_nearest(tuple_3d(), rand_search, rand_values)

    IO.puts("1000 random 3D points on the range of [0, 1000):")
    print_results(rand_search, rand_nearest, tuple_3d())
    IO.puts("Confirm naive nearest:")
    IO.puts("#{inspect(rand_nearest_linear)}")
  end
end

KDTree.main()
