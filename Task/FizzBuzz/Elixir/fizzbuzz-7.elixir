defmodule BadFizz do
  # Hand-rolls a bunch of AST before injecting the resulting FizzBuzz code.
  defmacrop automate_fizz(fizzers, n) do
    # To begin, we need to process fizzers to produce the various components
    # we're using in the final assembly. As told by Mickens telling as Antonio
    # Banderas, first you must specify a mapping function:
    build_parts = (fn {fz, n} ->
      ast_ref = {fz |> String.downcase |> String.to_atom, [], __MODULE__}
      clist   = List.duplicate("", n - 1) ++ [fz]
      cycle   = quote do: unquote(ast_ref) = unquote(clist) |> Stream.cycle

      {ast_ref, cycle}
    end)

    # ...and then a reducing function:
    collate = (fn
      ({ast_ref, cycle}, {ast_refs, cycles}) ->
        {[ast_ref | ast_refs], [cycle | cycles]}
    end)

    # ...and then, my love, when you are done your computation is ready to run
    # across thousands of fizzbuzz:
    {ast_refs, cycles} = fizzers
    |> Code.eval_quoted([], __ENV__) |> elem(0) # Gotta unwrap this mystery code~
    |> Enum.sort(fn ({_, ap}, {_, bp}) -> ap < bp end) # Sort so that Fizz, 3 < Buzz, 5
    |> Enum.map(build_parts)
    |> Enum.reduce({[], []}, collate)

    # Setup the anonymous functions used by Enum.reduce to build our AST components.
    # This was previously handled by List.foldl, but ejected because reduce/2's
    # default behavior reduces repetition.
    #
    # ...I was tempted to move these into a macro themselves, and thought better of it.
    build_zip    = fn (varname, ast) ->
      quote do: Stream.zip(unquote(varname), unquote(ast))
    end
    build_tuple  = fn (varname, ast) ->
      {:{}, [], [varname, ast]}
    end
    build_concat = fn (varname, ast) ->
        {:<>,
        [context: __MODULE__, import: Kernel], # Hygiene values may change; accurate to Elixir 1.1.1
        [varname, ast]}
    end

    # Toss cycles into a block by hand, then smash ast_refs into
    # a few different computations on the cycle block results.
    cycles = {:__block__, [], cycles}
    tuple  = ast_refs |> Enum.reduce(build_tuple)
    zip    = ast_refs |> Enum.reduce(build_zip)
    concat = ast_refs |> Enum.reduce(build_concat)

    # Finally-- Now that all our components are assembled, we can put
    # together the fizzbuzz stream pipeline. After quote ends, this
    # block is injected into the caller's context.
    quote do
      unquote(cycles)

      unquote(zip)
      |> Stream.with_index
      |> Enum.take(unquote(n))
      |> Enum.each(fn
      {unquote(tuple), i} ->
        ccats = unquote(concat)
        IO.puts if ccats == "", do: i + 1, else: ccats
      end)
    end
  end

  @doc ~S"""
    A fizzing, and possibly buzzing function. Somehow, you feel like you've
    seen this before. An old friend, suddenly appearing in Kafkaesque nightmare...

    ...or worse, during a whiteboard interview.
  """
  def fizz(n \\ 100) when is_number(n) do
    # In reward for all that effort above, we now have the latest in
    # programmer productivity:
    #
    # A DSL for building arbitrary fizzing, buzzing, bazzing, and more!
    [{"Fizz", 3},
     {"Buzz", 5}#,
     #{"Bar", 7},
     #{"Foo", 243}, # -> Always printed last (largest number)
     #{"Qux", 34}
    ]
    |> automate_fizz(n)
  end
end

BadFizz.fizz(100) # => Prints to stdout
