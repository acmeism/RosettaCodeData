defmodule Walk_directory do
  def recursive(dir \\ ".") do
    Enum.each(File.ls!(dir), fn file ->
      IO.puts fname = "#{dir}/#{file}"
      if File.dir?(fname), do: recursive(fname)
    end)
  end
end

Walk_directory.recursive
