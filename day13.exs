defmodule Day13 do
  def start(), do: [{ { 1,1 }, [] }]

  def goal?({ { 31, 39}, _}), do: true
  def goal?(_), do: false

  def binary_count(0), do: 0
  def binary_count(1), do: 1
  def binary_count(n), do: rem(n,2) + (div(n,2) |> binary_count)

  def wall?({x, y}) do
    rem(binary_count(x*x + 3*x + 2*x*y + y + y*y + 1352), 2) == 1
  end

  def negative?({x,y}), do: (x < 0) or ( y < 0)

  def possibilites({x, y}, visited) do
    [ { x+1, y }, { x-1, y }, { x, y+1 }, { x, y-1 } ]
    |> Enum.filter(&(not Enum.member?(visited, &1)))
    |> Enum.filter(&(not wall?(&1)))
    |> Enum.filter(&(not negative?(&1)))
  end

  def expand({node, visited}) do
    for new_node <- possibilites(node, visited), do: { new_node, [ node | visited ] }
  end

  def search(), do: search(start)

  def search(c) do
    case Enum.any?(c, &goal?/1) do
      true -> 0
      false -> search(Enum.flat_map(c, &expand/1)) + 1
    end
  end

  def walked_path({ node, visited}), do: [ node | visited ]

  def wide_walk(), do: wide_walk(start) |> Enum.uniq |> length

  def wide_walk(c) do
    wide_walk(c, 0)
  end

  def wide_walk(c, 50) do
    Enum.flat_map(c, &walked_path/1)
  end

  def wide_walk(c, n) do
    dead_ends = Enum.filter(c, &(expand(&1) == []))

    case dead_ends do
      [] -> Enum.flat_map(c, &expand/1)
      v ->  v ++ Enum.flat_map(c, &expand/1)
    end
    |> wide_walk(n+1)
  end

  def solve() do
    { search, wide_walk }
  end

end

