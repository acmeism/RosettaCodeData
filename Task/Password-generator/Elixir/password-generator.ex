defmodule Password do
  @lower Enum.map(?a..?z, &to_string([&1]))
  @upper Enum.map(?A..?Z, &to_string([&1]))
  @digit Enum.map(?0..?9, &to_string([&1]))
  @other ~S"""
!"#$%&'()*+,-./:;<=>?@[]^_{|}~
""" |> String.codepoints |> List.delete_at(-1)
  @all @lower ++ @upper ++ @digit ++ @other

  def generator do
    {len, num} = get_argv
    Enum.each(1..num, fn _ ->
      pswd = [Enum.random(@lower), Enum.random(@upper), Enum.random(@digit), Enum.random(@other)]
      IO.puts generator(len-4, pswd)
    end)
  end

  def generator(0, pswd), do: Enum.shuffle(pswd) |> Enum.join
  def generator(len, pswd), do: generator(len-1, [Enum.random(@all) | pswd])

  def get_argv do
    {len,num} = case System.argv do
      ["?"]     -> usage
      []        -> {8,1}
      [len]     -> {String.to_integer(len), 1}
      [len,num] -> {String.to_integer(len), String.to_integer(num)}
      _         -> usage
    end
    if len<4 or num<1, do: usage, else: {len,num}
  end

  defp usage do
    IO.puts ["Password generator\n",
             "Usage: [password length(=8)] [number of passwords to generate(=1)]"]
    exit(:normal)
  end
end

Password.generator
