defmodule Matrix do
  @moduledoc """
  A matrix implementation with basic operations and Strassen multiplication.
  """

  use Bitwise
  defstruct [:data, :rows, :cols]

  @doc """
  Creates a new matrix from the given data.
  """
  def new(data) do
    rows = length(data)
    cols = case rows do
      0 -> 0
      _ -> length(hd(data))
    end
    %Matrix{data: data, rows: rows, cols: cols}
  end

  @doc """
  Gets the number of rows in the matrix.
  """
  def get_rows(%Matrix{rows: rows}), do: rows

  @doc """
  Gets the number of columns in the matrix.
  """
  def get_cols(%Matrix{cols: cols}), do: cols

  # Validation functions
  defp validate_dimensions(m1, m2) do
    unless get_rows(m1) == get_rows(m2) and get_cols(m1) == get_cols(m2) do
      raise ArgumentError, "Matrices must have the same dimensions."
    end
  end

  defp validate_multiplication(m1, m2) do
    unless get_cols(m1) == get_rows(m2) do
      raise ArgumentError, "Cannot multiply these matrices."
    end
  end

  defp validate_square_power_of_two(m) do
    rows = get_rows(m)
    cols = get_cols(m)

    unless rows == cols do
      raise ArgumentError, "Matrix must be square."
    end

    unless rows > 0 and (rows &&& (rows - 1)) == 0 do
      raise ArgumentError, "Size of matrix must be a power of two."
    end
  end

  @doc """
  Adds two matrices element-wise.
  """
  def add(m1, m2) do
    validate_dimensions(m1, m2)
    data1 = m1.data
    data2 = m2.data
    result_data = add_rows(data1, data2)
    new(result_data)
  end

  defp add_rows([], []), do: []
  defp add_rows([row1 | rest1], [row2 | rest2]) do
    [add_elements(row1, row2) | add_rows(rest1, rest2)]
  end

  defp add_elements([], []), do: []
  defp add_elements([e1 | rest1], [e2 | rest2]) do
    [e1 + e2 | add_elements(rest1, rest2)]
  end

  @doc """
  Subtracts the second matrix from the first element-wise.
  """
  def subtract(m1, m2) do
    validate_dimensions(m1, m2)
    data1 = m1.data
    data2 = m2.data
    result_data = subtract_rows(data1, data2)
    new(result_data)
  end

  defp subtract_rows([], []), do: []
  defp subtract_rows([row1 | rest1], [row2 | rest2]) do
    [subtract_elements(row1, row2) | subtract_rows(rest1, rest2)]
  end

  defp subtract_elements([], []), do: []
  defp subtract_elements([e1 | rest1], [e2 | rest2]) do
    [e1 - e2 | subtract_elements(rest1, rest2)]
  end

  @doc """
  Multiplies two matrices using standard algorithm.
  """
  def multiply(m1, m2) do
    validate_multiplication(m1, m2)
    data1 = m1.data
    data2 = m2.data
    cols2 = get_cols(m2)
    result_data = multiply_rows(data1, data2, cols2)
    new(result_data)
  end

  defp multiply_rows([], _data2, _cols2), do: []
  defp multiply_rows([row | rest], data2, cols2) do
    result_row = multiply_row_with_matrix(row, data2, cols2)
    [result_row | multiply_rows(rest, data2, cols2)]
  end

  defp multiply_row_with_matrix(row, data2, cols2) do
    for j <- 1..cols2 do
      dot_product(row, get_column(data2, j))
    end
  end

  defp get_column(data, col_index) do
    for row <- data, do: Enum.at(row, col_index - 1)
  end

  defp dot_product(list1, list2) do
    Enum.zip(list1, list2)
    |> Enum.map(fn {e1, e2} -> e1 * e2 end)
    |> Enum.sum()
  end

  @doc """
  Converts matrix to string representation.
  """
  def to_matrix_string(m) do
    data = m.data
    rows_str = for row <- data, do: format_row(row)
    Enum.join(rows_str, "\n") <> "\n"
  end

  defp format_row(row) do
    elements = for e <- row, do: format_element(e)
    "[" <> Enum.join(elements, ", ") <> "]"
  end

  defp format_element(e) do
    "#{e}"
  end

  @doc """
  Converts matrix to string with specified precision.
  """
  def to_matrix_string_with_precision(m, precision) do
    data = m.data
    pow = :math.pow(10.0, precision)
    rows_str = for row <- data, do: format_row_with_precision(row, pow, precision)
    Enum.join(rows_str, "\n") <> "\n"
  end

  defp format_row_with_precision(row, pow, precision) do
    elements = for e <- row, do: format_element_with_precision(e, pow, precision)
    "[" <> Enum.join(elements, ", ") <> "]"
  end

  defp format_element_with_precision(e, pow, precision) do
    rounded = round(e * pow) / pow
    formatted = :io_lib.format("~.*f", [precision, rounded]) |> List.to_string()

    # Handle negative zero
    zero_check = case precision do
      0 -> "0"
      _ -> "0." <> String.duplicate("0", precision)
    end

    case formatted do
      "-" <> rest when rest == zero_check -> zero_check
      _ -> formatted
    end
  end

  # Strassen multiplication helper functions
  defp to_quarters(m) do
    rows = get_rows(m)
    r = div(rows, 2)
    data = m.data

    # Extract quarters directly
    top_half = Enum.take(data, r)
    bottom_half = Enum.drop(data, r)

    # Q0: top-left, Q1: top-right, Q2: bottom-left, Q3: bottom-right
    q0_data = for row <- top_half, do: Enum.take(row, r)
    q1_data = for row <- top_half, do: Enum.drop(row, r)
    q2_data = for row <- bottom_half, do: Enum.take(row, r)
    q3_data = for row <- bottom_half, do: Enum.drop(row, r)

    [new(q0_data), new(q1_data), new(q2_data), new(q3_data)]
  end

  defp from_quarters([q0, q1, q2, q3]) do
    q0_data = q0.data
    q1_data = q1.data
    q2_data = q2.data
    q3_data = q3.data

    # Combine quarters back into full matrix
    top_half = Enum.zip(q0_data, q1_data) |> Enum.map(fn {row0, row1} -> row0 ++ row1 end)
    bottom_half = Enum.zip(q2_data, q3_data) |> Enum.map(fn {row2, row3} -> row2 ++ row3 end)

    new(top_half ++ bottom_half)
  end

  @doc """
  Multiplies two matrices using Strassen's algorithm.
  Matrices must be square and have size that is a power of two.
  """
  def strassen(m1, m2) do
    validate_square_power_of_two(m1)
    validate_square_power_of_two(m2)

    unless get_rows(m1) == get_rows(m2) and get_cols(m1) == get_cols(m2) do
      raise ArgumentError, "Matrices must be square and of equal size for Strassen multiplication."
    end

    strassen_impl(m1, m2)
  end

  defp strassen_impl(m1, m2) do
    case get_rows(m1) do
      1 -> multiply(m1, m2)
      _ ->
        [a11, a12, a21, a22] = to_quarters(m1)
        [b11, b12, b21, b22] = to_quarters(m2)

        # Calculate the 7 products according to Strassen's algorithm
        p1 = strassen_impl(a11, subtract(b12, b22))
        p2 = strassen_impl(add(a11, a12), b22)
        p3 = strassen_impl(add(a21, a22), b11)
        p4 = strassen_impl(a22, subtract(b21, b11))
        p5 = strassen_impl(add(a11, a22), add(b11, b22))
        p6 = strassen_impl(subtract(a12, a22), add(b21, b22))
        p7 = strassen_impl(subtract(a11, a21), add(b11, b12))

        # Calculate result quarters
        c11 = add(subtract(add(p5, p4), p2), p6)
        c12 = add(p1, p2)
        c21 = add(p3, p4)
        c22 = subtract(subtract(add(p5, p1), p3), p7)

        from_quarters([c11, c12, c21, c22])
    end
  end

  @doc """
  Main function for testing the matrix operations.
  """
  def main(_args \\ []) do
    a_data = [[1.0, 2.0], [3.0, 4.0]]
    a = new(a_data)

    b_data = [[5.0, 6.0], [7.0, 8.0]]
    b = new(b_data)

    c_data = [[1.0, 1.0, 1.0, 1.0], [2.0, 4.0, 8.0, 16.0], [3.0, 9.0, 27.0, 81.0], [4.0, 16.0, 64.0, 256.0]]
    c = new(c_data)

    d_data = [[4.0, -3.0, 4.0/3.0, -1.0/4.0],
              [-13.0/3.0, 19.0/4.0, -7.0/3.0, 11.0/24.0],
              [3.0/2.0, -2.0, 7.0/6.0, -1.0/4.0],
              [-1.0/6.0, 1.0/4.0, -1.0/6.0, 1.0/24.0]]
    d = new(d_data)

    e_data = [[1.0, 2.0, 3.0, 4.0], [5.0, 6.0, 7.0, 8.0], [9.0, 10.0, 11.0, 12.0], [13.0, 14.0, 15.0, 16.0]]
    e = new(e_data)

    f_data = [[1.0, 0.0, 0.0, 0.0], [0.0, 1.0, 0.0, 0.0], [0.0, 0.0, 1.0, 0.0], [0.0, 0.0, 0.0, 1.0]]
    f = new(f_data)

    IO.puts("Using 'normal' matrix multiplication:")
    IO.puts("  a * b = #{to_matrix_string(multiply(a, b))}")
    IO.puts("  c * d = #{to_matrix_string_with_precision(multiply(c, d), 6)}")
    IO.puts("  e * f = #{to_matrix_string(multiply(e, f))}")

    IO.puts("\nUsing 'Strassen' matrix multiplication:")
    IO.puts("  a * b = #{to_matrix_string(strassen(a, b))}")
    IO.puts("  c * d = #{to_matrix_string_with_precision(strassen(c, d), 6)}")
    IO.puts("  e * f = #{to_matrix_string(strassen(e, f))}")
  end
end


Matrix.main()
