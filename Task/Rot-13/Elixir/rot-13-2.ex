defmodule Rot13 do
  @moduledoc """
  ROT13 encoding program. Takes user input and outputs encoded text.
  """

  @spec sign(integer | float) :: -1 | 1
  def sign(int) do
    if int >= 0 do 1
    else          -1
    end
  end

  @spec rotate(charlist) :: charlist
  def rotate(string_chars) do
    string_chars
      |> Enum.map(
        fn char ->
          char_up = << char :: utf8 >>
            |> String.upcase()
            |> String.to_charlist()
            |> Enum.at(0)
          if ?A <= char_up and char_up <= ?Z do
            <<
              char + (-13 * trunc(sign(char_up - 77.5))) :: utf8
            >>
          else
            << char :: utf8 >>
          end
        end)
  end

  @spec start(any, any) :: {:ok, pid}
  def start(_type, _args) do
    IO.puts("Enter string to encode:")
    IO.puts(
      [
        "Encoded string:\n",
        IO.read(:line)
          |> String.trim()
          |> String.to_charlist()
          |> rotate()
      ]
    )
    Task.start(fn -> :timer.sleep(1000) end)
  end
end
