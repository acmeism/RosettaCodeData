defmodule McNaughtonYamadaThompsonAlgorithm do
  # Using a reference-based approach for mutable states
  defmodule State do
    defstruct id: nil, label: ?\0, edge1: nil, edge2: nil

    def new(label \\ ?\0) do
      %State{id: make_ref(), label: label}
    end
  end

  defmodule NFA do
    defstruct initial: nil, accept: nil, states: %{}

    def new(initial, accept, states) do
      %NFA{initial: initial, accept: accept, states: states}
    end
  end

  def main do
    infixes = ["a.b.c*", "a.(b|d).c*", "(a.(b|d))*", "a.(b.b)*.c"]
    strings = ["", "abc", "abbc", "abcc", "abad", "abbbc"]

    for infix <- infixes do
      for string <- strings do
        result = match_regex(string, infix)
        IO.puts("#{if result, do: "True ", else: "False "} #{infix} #{string}")
      end
      IO.puts("")
    end
  end

  # Match the given string against the given infix regex
  defp match_regex(text, infix) do
    postfix = shunt(infix)
    # Uncomment the next line to see the postfix expression
    # IO.puts("Postfix: #{postfix}")

    nfa = compile_regex(postfix)

    current = followes(nfa.initial, nfa.states)

    final_states =
      text
      |> String.to_charlist()
      |> Enum.reduce(current, fn ch, current_states ->
        next_states =
          current_states
          |> Enum.filter(fn state_id ->
            state = nfa.states[state_id]
            state.label == ch
          end)
          |> Enum.flat_map(fn state_id ->
            state = nfa.states[state_id]
            followes(state.edge1, nfa.states)
          end)
          |> MapSet.new()

        next_states
      end)

    MapSet.member?(final_states, nfa.accept)
  end

  # Compile the given postfix regex into an NFA
  defp compile_regex(postfix) do
    {[result], _} =
      postfix
      |> String.to_charlist()
      |> Enum.reduce({[], nil}, fn ch, {stack, _} ->
        case ch do
          ?* ->
            [nfa1 | rest] = stack
            initial = State.new()
            accept = State.new()

            # Update states map with connections
            states = nfa1.states
            states = Map.put(states, initial.id, %{initial | edge1: nfa1.initial, edge2: accept.id})
            states = Map.put(states, accept.id, accept)

            # Update nfa1's accept state to loop back
            accept_state = states[nfa1.accept]
            states = Map.put(states, nfa1.accept,
              %{accept_state | edge1: nfa1.initial, edge2: accept.id})

            new_nfa = NFA.new(initial.id, accept.id, states)
            {[new_nfa | rest], nil}

          ?. ->
            [nfa2, nfa1 | rest] = stack

            # Merge states from both NFAs
            states = Map.merge(nfa1.states, nfa2.states)

            # Connect nfa1's accept to nfa2's initial
            accept_state = states[nfa1.accept]
            states = Map.put(states, nfa1.accept,
              %{accept_state | edge1: nfa2.initial})

            new_nfa = NFA.new(nfa1.initial, nfa2.accept, states)
            {[new_nfa | rest], nil}

          ?| ->
            [nfa2, nfa1 | rest] = stack
            initial = State.new()
            accept = State.new()

            # Merge states from both NFAs
            states = Map.merge(nfa1.states, nfa2.states)
            states = Map.put(states, initial.id,
              %{initial | edge1: nfa1.initial, edge2: nfa2.initial})
            states = Map.put(states, accept.id, accept)

            # Connect both accepts to new accept
            accept1_state = states[nfa1.accept]
            states = Map.put(states, nfa1.accept,
              %{accept1_state | edge1: accept.id})

            accept2_state = states[nfa2.accept]
            states = Map.put(states, nfa2.accept,
              %{accept2_state | edge1: accept.id})

            new_nfa = NFA.new(initial.id, accept.id, states)
            {[new_nfa | rest], nil}

          ?+ ->
            [nfa1 | rest] = stack
            initial = State.new()
            accept = State.new()

            states = nfa1.states
            states = Map.put(states, initial.id, %{initial | edge1: nfa1.initial})
            states = Map.put(states, accept.id, accept)

            # nfa1's accept loops back and continues to new accept
            accept_state = states[nfa1.accept]
            states = Map.put(states, nfa1.accept,
              %{accept_state | edge1: nfa1.initial, edge2: accept.id})

            new_nfa = NFA.new(initial.id, accept.id, states)
            {[new_nfa | rest], nil}

          ?? ->
            [nfa1 | rest] = stack
            initial = State.new()
            accept = State.new()

            states = nfa1.states
            states = Map.put(states, initial.id,
              %{initial | edge1: nfa1.initial, edge2: accept.id})
            states = Map.put(states, accept.id, accept)

            # Connect nfa1's accept to new accept
            accept_state = states[nfa1.accept]
            states = Map.put(states, nfa1.accept,
              %{accept_state | edge1: accept.id})

            new_nfa = NFA.new(initial.id, accept.id, states)
            {[new_nfa | rest], nil}

          _ ->
            # Literal character
            initial = State.new(ch)
            accept = State.new()

            states = %{}
            states = Map.put(states, initial.id, %{initial | edge1: accept.id})
            states = Map.put(states, accept.id, accept)

            new_nfa = NFA.new(initial.id, accept.id, states)
            {[new_nfa | stack], nil}
        end
      end)

    result
  end

  # Compute the epsilon closure of the given state
  defp followes(state_id, states) when is_nil(state_id), do: MapSet.new()
  defp followes(state_id, states) do
    followes_helper([state_id], MapSet.new(), states)
  end

  defp followes_helper([], visited, _states), do: visited
  defp followes_helper([current | rest], visited, states) do
    if MapSet.member?(visited, current) do
      followes_helper(rest, visited, states)
    else
      visited = MapSet.put(visited, current)

      state = states[current]
      if state && state.label == ?\0 do  # Epsilon transition
        new_states = []
        new_states = if state.edge1, do: [state.edge1 | new_states], else: new_states
        new_states = if state.edge2, do: [state.edge2 | new_states], else: new_states
        followes_helper(rest ++ new_states, visited, states)
      else
        followes_helper(rest, visited, states)
      end
    end
  end

  # Convert the given infix regex to postfix regex using the Shunting Yard algorithm
  defp shunt(infix) do
    specials = %{
      ?* => 60,
      ?+ => 55,
      ?? => 50,
      ?. => 40,
      ?| => 20
    }

    {postfix, stack} =
      infix
      |> String.to_charlist()
      |> Enum.reduce({"", []}, fn ch, {postfix, stack} ->
        cond do
          ch == ?( ->
            {postfix, [ch | stack]}

          ch == ?) ->
            {popped, remaining} = pop_until_paren(stack, [])
            {postfix <> List.to_string(popped), remaining}

          Map.has_key?(specials, ch) ->
            {popped, remaining} = pop_by_precedence(stack, ch, specials, [])
            {postfix <> List.to_string(popped), [ch | remaining]}

          true ->
            {postfix <> <<ch>>, stack}
        end
      end)

    postfix <> List.to_string(Enum.reverse(stack))
  end

  defp pop_until_paren([], acc), do: {Enum.reverse(acc), []}
  defp pop_until_paren([?( | rest], acc), do: {Enum.reverse(acc), rest}
  defp pop_until_paren([h | rest], acc), do: pop_until_paren(rest, [h | acc])

  defp pop_by_precedence([], _ch, _specials, acc), do: {Enum.reverse(acc), []}
  defp pop_by_precedence([h | rest] = stack, ch, specials, acc) do
    if Map.has_key?(specials, h) and specials[ch] <= specials[h] do
      pop_by_precedence(rest, ch, specials, [h | acc])
    else
      {Enum.reverse(acc), stack}
    end
  end
end

# Run the main function
McNaughtonYamadaThompsonAlgorithm.main()
