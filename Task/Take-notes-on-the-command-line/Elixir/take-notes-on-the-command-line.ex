defmodule Take_notes do
  @filename "NOTES.TXT"

  def main( [] ), do: display_notes
  def main( arguments ), do: save_notes( arguments )

  def display_notes, do: IO.puts File.read!(@filename)

  def save_notes( arguments ) do
    notes = "#{inspect :calendar.local_time}\n\t" <> Enum.join(arguments, " ")
    File.open!(@filename, [:append], fn(file) -> IO.puts(file, notes) end)
  end
end

Take_notes.main(System.argv)
