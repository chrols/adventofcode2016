defmodule Day5 do
  def encode(string, index), do: encode(string<>to_string(index))
  def encode(string), do: :crypto.hash(:md5 , string)

  def crack_simple(string), do: crack_simple(string, encode(string, 0), 1, [])

  def crack_simple(_, _, _, solution) when length(solution) == 8 do
    solution
    |> Enum.reverse
    |> Enum.map(&(if &1 < 10, do: &1+48, else: &1+55))
    |> to_string
  end
  def crack_simple(string, << 0 :: size(20), n :: size(4) , _ :: binary>>, index, solution) do
    crack_simple(string, encode(string, index), index + 1, [ n | solution ])
  end
  def crack_simple(string, no_solution, index, solution) do
    crack_simple(string, encode(string, index), index + 1, solution )
  end

  def crack_inspired(string), do: crack_inspired(string, encode(string, 0), 1, %{})

  def crack_inspired(_, _, _, solution) when map_size(solution) == 8 do
    Map.values(solution)
    |> Enum.map(&(if &1 < 10, do: &1+48, else: &1+55))
    |> to_string
  end
  def crack_inspired(string, << 0::size(20), pos::size(4), key::size(4), _::size(100)>>, index, solution) when pos < 8 do
    crack_inspired(string, encode(string, index), index + 1, Map.put_new(solution, pos, key))
  end
  def crack_inspired(string, wrong, index, solution) do
    crack_inspired(string, encode(string, index), index + 1, solution )
  end

  def solve(), do: { crack_simple("abbhdwsy"), crack_inspired("abbhdwsy") }

  def test() do
    "18F47A30" = crack_simple("abc")
    "05ACE8E3" = crack_inspired("abc")
    :ok
  end
end


