defmodule Csv do
  defstruct header: "", data: "", separator: ","

  def from_file(path) do
    [header | data] = path
    |> File.stream!
    |> Enum.to_list
    |> Enum.map(&String.trim/1)

    %Csv{ header: header, data: data }
  end

  def sums_of_rows(csv) do
    Enum.map(csv.data, fn (row) -> sum_of_row(row, csv.separator) end)
  end

  def sum_of_row(row, separator) do
    row
    |> String.split(separator)
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum
    |> to_string
  end

  def append_column(csv, column_header, column_data) do
    header = append_to_row(csv.header, column_header, csv.separator)

    data = [csv.data, column_data]
    |> List.zip
    |> Enum.map(fn ({ row, value }) ->
      append_to_row(row, value, csv.separator)
    end)

    %Csv{ header: header, data: data }
  end

  def append_to_row(row, value, separator) do
    row <> separator <> value
  end

  def to_file(csv, path) do
    body = Enum.join([csv.header | csv.data], "\n")

    File.write(path, body)
  end
end

csv = Csv.from_file("in.csv")
csv
|> Csv.append_column("SUM", Csv.sums_of_rows(csv))
|> Csv.to_file("out.csv")
