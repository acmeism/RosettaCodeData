defmodule StreamMerge do
  def merge2(file1, file2), do: mergeN([file1, file2])

  def mergeN(files) do
    Enum.map(files, fn fname -> File.open!(fname) end)
    |> Enum.map(fn fd -> {fd, IO.read(fd, :line)} end)
    |> merge_loop
  end

  defp merge_loop([]), do: :ok
  defp merge_loop(fdata) do
    {fd, min} = Enum.min_by(fdata, fn {_,head} -> head end)
    IO.write min
    case IO.read(fd, :line) do
      :eof -> File.close(fd)
              List.delete(fdata, {fd, min}) |> merge_loop
      head -> List.keyreplace(fdata, fd, 0, {fd, head}) |> merge_loop
    end
  end
end

filenames = ~w[temp1.dat temp2.dat temp3.dat]
Enum.each(filenames, fn fname ->
  IO.puts "#{fname}: " <> File.read!(fname) |> String.replace("\n", " ")
end)
IO.puts "\n2-stream merge:"
StreamMerge.merge2("temp1.dat", "temp2.dat")
IO.puts "\nN-stream merge:"
StreamMerge.mergeN(filenames)
