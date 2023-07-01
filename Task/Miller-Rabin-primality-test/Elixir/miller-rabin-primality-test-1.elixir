defmodule Prime do
  use Application
  alias :math, as: Math
  alias :rand, as: Rand

  def start( _type, _args ) do
    primes = 5..1000
      |> Enum.filter( fn( x ) -> (rem x, 2) == 1 end )
      |> Enum.filter( fn( x ) -> miller_rabin?( x, 10) == True end )
    IO.inspect( primes, label: "Primes: ", limit: :infinity )

    { :ok, self() }
  end

  def modular_exp( x, y, mod ) do
     with [ _ | bits ] = Integer.digits( y, 2 ) do
          Enum.reduce bits, x, fn( bit, acc ) -> acc * acc |> ( &( if bit == 1, do: &1 * x, else: &1 ) ).() |> rem( mod ) end
     end
  end

  def miller_rabin( d, s ) when rem( d, 2 ) == 0, do: { s, d }
  def miller_rabin( d, s ), do: miller_rabin( div( d, 2 ), s + 1 )

  def miller_rabin?( n, g ) do
       { s, d } = miller_rabin( n - 1, 0 )
       miller_rabin( n, g, s, d )
  end

  def miller_rabin( n, 0, _, _ ), do: True
  def miller_rabin( n, g, s, d ) do
    a = 1 + Rand.uniform( n - 3 )
    x = modular_exp( a, d, n )
    if x == 1 or x == n - 1 do
      miller_rabin( n, g - 1, s, d )
    else
      if miller_rabin( n, x, s - 1) == True, do: miller_rabin( n, g - 1, s, d ), else: False
    end
  end

  def miller_rabin( n, x, r ) when r <= 0, do: False
  def miller_rabin( n, x, r ) do
    x = modular_exp( x, 2, n )
    unless x == 1 do
      unless x == n - 1, do: miller_rabin( n, x, r - 1 ), else: True
    else
      False
    end
  end
end
