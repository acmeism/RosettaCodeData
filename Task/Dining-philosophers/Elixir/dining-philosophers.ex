defmodule Philosopher do

  defstruct missing: [], clean: [], promised: []

  def run_demo do
    pid1 = spawn(__MODULE__, :init, ["Russell"])
    pid2 = spawn(__MODULE__, :init, ["Marx"])
    pid3 = spawn(__MODULE__, :init, ["Spinoza"])
    pid4 = spawn(__MODULE__, :init, ["Kant"])
    pid5 = spawn(__MODULE__, :init, ["Aristotle"])

    # a chopstick is simply represented by the pid of the neighbour that shares it.

    send(pid1, {:run, %Philosopher{}})
    send(pid2, {:run, %Philosopher{missing: [pid1]}})
    send(pid3, {:run, %Philosopher{missing: [pid2]}})
    send(pid4, {:run, %Philosopher{missing: [pid3]}})
    send(pid5, {:run, %Philosopher{missing: [pid1, pid4]}})
  end

  def init(philosopher_name) do
    receive do
      {:run, state} ->
        spawn(__MODULE__, :change_state, [self()])
        case flip_coin() do
          :heads -> thinking(philosopher_name, state)
          :tails -> hungry(philosopher_name, state)
        end
    end
  end

  defp thinking(philosopher_name, state) do
    receive do
      {:change_state} ->
        hungry(philosopher_name, state)
      {:chopstick_request, pid} ->
        if clean?(pid, state) do
          thinking(philosopher_name, promise_chopstick(philosopher_name, pid, state))
        else
          give_chopstick(philosopher_name, self(), pid)
          %{missing: missing} = state
          thinking(philosopher_name, %{state | missing: [pid | missing]})
        end
    end
  end

  defp hungry(philosopher_name, state) do
    IO.puts "#{philosopher_name} is hungry."
    %{missing: missing} = state
    for pid <- missing, do: request_chopstick(philosopher_name, self(), pid)
    wait_for_chopsticks(philosopher_name, state)
  end

  defp wait_for_chopsticks(philosopher_name, state) do
    if has_chopsticks?(state) do
      eating(philosopher_name, state)
    end
    receive do
      {:chopstick_request, pid} ->
        if clean?(pid, state) do
          wait_for_chopsticks(philosopher_name, promise_chopstick(philosopher_name, pid, state))
        else
          give_chopstick(philosopher_name, self(), pid)
          request_chopstick(philosopher_name, self(), pid)
          %{missing: missing} = state
          wait_for_chopsticks(philosopher_name, %{state | missing: [pid | missing]})
        end
      {:chopstick_response, pid} ->
        %{missing: missing, clean: clean} = state
        wait_for_chopsticks(philosopher_name, %{state | missing: List.delete(missing, pid), clean: [pid | clean]})
    end
  end

  defp eating(philosopher_name, state) do
    IO.puts "*** #{philosopher_name} is eating."
    receive do
      {:change_state} ->
        %{promised: promised} = state
        for pid <- promised, do: give_chopstick(philosopher_name, self(), pid)
        thinking(philosopher_name, %Philosopher{missing: promised})
    end
  end

  defp clean?(pid, state) do
    %{clean: clean} = state
    Enum.member?(clean, pid)
  end

  defp has_chopsticks?(state) do
    %{missing: missing} = state
    Enum.empty?(missing)
  end

  defp promise_chopstick(philosopher_name, pid, state) do
    IO.puts "#{philosopher_name} promises a chopstick."
    %{promised: promised} = state
    %{state | promised: [pid | promised]}
  end

  defp request_chopstick(philosopher_name, snd_pid, recv_pid) do
    IO.puts "#{philosopher_name} requests a chopstick."
    send(recv_pid, {:chopstick_request, snd_pid})
  end

  defp give_chopstick(philosopher_name, snd_pid, recv_pid) do
    IO.puts "#{philosopher_name} gives a chopstick."
    send(recv_pid, {:chopstick_response, snd_pid})
  end

  defp flip_coin do
    case Enum.random(0..1) do
      0 -> :heads
      1 -> :tails
    end
  end	

  def change_state(pid) do
    Process.sleep(Enum.random(1..10) * 1000)
    send(pid, {:change_state})
    change_state(pid)
  end
