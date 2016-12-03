defmodule Day3 do
  def possible(x,y,z) do
    big = max(x,y) |> max(z)
    smallside = x + y + z - big
    smallside > big
  end

  def solve_sequence([]), do: []
  def solve_sequence([x,y,z|t]), do: [ possible(x,y,z) | solve_sequence(t) ]

  def solve_sequence2([0|t]), do: solve_sequence2(t)
  def solve_sequence2([x1,x2,x3,y1,y2,y3,z|t]), do: [ possible(x1,y1,z) | solve_sequence2([x2,x3,0,y2,y3,0|t]) ]
  def solve_sequence2(_), do: []

  def solve(input) do
    ints = File.read!(input) |> String.split |> Enum.map(&String.to_integer/1)
    solution1 = solve_sequence(ints) |> Enum.count(&(&1))
    solution2 = solve_sequence2(ints) |> Enum.count(&(&1))
    { solution1, solution2 }
  end

  def test() do
    ints = [ 101, 301, 501, 102, 302, 502, 103, 303, 503,201, 401, 601,202, 402, 602,203, 403, 603 ]
    6 = solve_sequence2(ints) |> Enum.count(&(&1))
  end
end


