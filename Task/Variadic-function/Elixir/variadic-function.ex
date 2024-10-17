defmodule RC do
  def print_each( arguments ) do
    Enum.each(arguments, fn x -> IO.inspect x end)
  end
end

RC.print_each([1,2,3])
RC.print_each(["Mary", "had", "a", "little", "lamb"])
