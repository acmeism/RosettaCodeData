defmodule Ast do
  def main do
    expr = IO.gets("Give an expression:\n") |> String.Chars.to_string |> String.trim
    case Code.string_to_quoted(expr) do
      {:ok, ast} ->
        IO.puts("AST is: " <> inspect(ast))
        {result, _} = Code.eval_quoted(ast)
        IO.puts("Result = #{result}")
      {:error, {_meta, message_info, _token}} ->
        IO.puts(message_info)
    end
  end
end
