defmodule LagrangeInterpolation do
  def main do
    points = [{1, 1}, {2, 4}, {3, 1}, {4, 5}]

    points
    |> lagrange_interpolation()
    |> display()
  end

  defp lagrange_interpolation(points) do
    polys = Enum.map(0..(length(points) - 1), fn i ->
      point_i = Enum.at(points, i)

      poly = [1.0]
      poly = Enum.reduce(0..(length(points) - 1), poly, fn j, acc ->
        point_j = Enum.at(points, j)
        if i != j do
          multiply(acc, [-elem(point_j, 0), 1.0])
        else
          acc
        end
      end)

      value = evaluate(poly, elem(point_i, 0))
      scalar_divide(poly, value)
    end)

    sum = [0.0]
    Enum.reduce(0..(length(points) - 1), sum, fn i, acc ->
      point_i = Enum.at(points, i)
      poly = Enum.at(polys, i)
      poly = scalar_multiply(poly, elem(point_i, 1))
      add(acc, poly)
    end)
  end

  # A list is used to represent a Polynomial
  # with its coefficients reversed compared to the standard mathematical notation.
  # For example, the polynomial 3x^2 + 2x + 1 is represented by the list [1, 2, 3].
  defp add(one, two) do
    max_length = max(length(one), length(two))
    one_padded = one ++ List.duplicate(0.0, max_length - length(one))
    two_padded = two ++ List.duplicate(0.0, max_length - length(two))

    Enum.zip(one_padded, two_padded)
    |> Enum.map(fn {a, b} -> a + b end)
  end

  defp multiply(one, two) do
    product = List.duplicate(0.0, length(one) + length(two) - 1)

    Enum.with_index(one)
    |> Enum.reduce(product, fn {val_one, i}, acc ->
      Enum.with_index(two)
      |> Enum.reduce(acc, fn {val_two, j}, inner_acc ->
        List.update_at(inner_acc, i + j, &(&1 + val_one * val_two))
      end)
    end)
  end

  defp scalar_multiply(array, value) do
    Enum.map(array, &(&1 * value))
  end

  defp scalar_divide(array, value) do
    scalar_multiply(array, 1.0 / value)
  end

  defp evaluate(array, value) do
    array
    |> Enum.reverse()
    |> Enum.reduce(0.0, fn coeff, acc -> acc * value + coeff end)
  end

  defp display(array) do
    degree = length(array) - 1

    if degree == 0 do
      IO.puts(:io_lib.format("~.5f", [hd(array)]))
      :ok
    else
      result = degree..0
      |> Enum.reduce("", fn i, acc ->
        coeff = Enum.at(array, i)

        if coeff == 0.0 do
          acc
        else
          sign = cond do
            coeff < 0.0 and i == degree -> "-"
            coeff < 0.0 -> " - "
            i < degree -> " + "
            true -> ""
          end

          coeff_str = if abs(coeff) > 1.0, do: :io_lib.format("~.5f", [abs(coeff)]), else: ""

          term = cond do
            i > 1 -> "x^#{i}"
            i == 1 -> "x"
            abs(coeff) == 1.0 -> "1"
            true -> ""
          end

          acc <> sign <> to_string(coeff_str) <> term
        end
      end)

      IO.puts(result)
    end
  end
end

LagrangeInterpolation.main()
