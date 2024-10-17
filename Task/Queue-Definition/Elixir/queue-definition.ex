defmodule Queue do
  def new, do: {Queue, [], []}

  def push({Queue, input, output}, x), do: {Queue, [x|input], output}

  def pop({Queue, [], []}), do: (raise RuntimeError, message: "empty Queue")
  def pop({Queue, input, []}), do: pop({Queue, [], Enum.reverse(input)})
  def pop({Queue, input, [h|t]}), do: {h, {Queue, input, t}}

  def empty?({Queue, [], []}), do: true
  def empty?({Queue, _, _}), do: false
end
