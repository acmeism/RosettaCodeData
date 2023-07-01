defmodule RC do
  def is_numeric(str) do
    case Float.parse(str) do
      {_num, ""} -> true
      _          -> false
    end
  end
end

["123", "-12.3", "123.", ".05", "-12e5", "+123", " 123", "abc", "123a", "12.3e", "1 2"] |> Enum.filter(&RC.is_numeric/1)
