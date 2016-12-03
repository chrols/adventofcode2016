defmodule Day2 do
  # 1 2 3
  # 4 5 6
  # 7 8 9

  def move(D, 1), do: 4
  def move(R, 1), do: 2
  def move(D, 2), do: 5
  def move(L, 2), do: 1
  def move(R, 2), do: 3
  def move(D, 3), do: 6
  def move(L, 3), do: 2
  def move(D, 4), do: 7
  def move(R, 4), do: 5
  def move(U, 4), do: 1
  def move(D, 5), do: 8
  def move(L, 5), do: 4
  def move(R, 5), do: 6
  def move(U, 5), do: 2
  def move(D, 6), do: 9
  def move(L, 6), do: 5
  def move(U, 6), do: 3
  def move(R, 7), do: 8
  def move(U, 7), do: 4
  def move(L, 8), do: 7
  def move(R, 8), do: 9
  def move(U, 8), do: 5
  def move(L, 9), do: 8
  def move(U, 9), do: 6
  def move(_, pos) , do: pos

  #     1
  #   2 3 4
  # 5 6 7 8 9
  #   A B C
  #     D

  def move2(D, 1), do: 3
  def move2(R, 5), do: 6
  def move2(L, 9), do: 8
  def move2(U, 13), do: 11
  def move2(R, 2), do: 3
  def move2(D, 2), do: 6
  def move2(L, 4), do: 3
  def move2(D, 4), do: 8
  def move2(R, 10), do: 11
  def move2(U, 10), do: 6
  def move2(L, 12), do: 11
  def move2(U, 12), do: 8
  def move2(U, 3), do: 1
  def move2(D, 3), do: 7
  def move2(R, 3), do: 4
  def move2(L, 3), do: 2
  def move2(U, 6), do: 2
  def move2(D, 6), do: 10
  def move2(R, 6), do: 7
  def move2(L, 6), do: 5
  def move2(U, 7), do: 3
  def move2(D, 7), do: 11
  def move2(R, 7), do: 8
  def move2(L, 7), do: 6
  def move2(U, 8), do: 4
  def move2(D, 8), do: 12
  def move2(R, 8), do: 9
  def move2(L, 8), do: 7
  def move2(U, 11), do: 7
  def move2(D, 11), do: 13
  def move2(R, 11), do: 12
  def move2(L, 11), do: 10
  def move2(_, pos) , do: pos

  def punch([], _), do: []
  def punch([head_sequence|tail], start) do
    res = Enum.reduce(head_sequence, start, &move/2)
    [ res | punch(tail, res) ]
  end

  def punch2([], _), do: []
  def punch2([head_sequence|tail], start) do
    res = Enum.reduce(head_sequence, start, &move2/2)
    [ res | punch2(tail, res) ]
  end

  def convert(76), do: L
  def convert(82), do: R
  def convert(85), do: U
  def convert(68), do: D

  def convert([]), do: []
  def convert([h|t]), do: [ convert(h) | convert(t) ]

  def solve(input) do
    sequence = File.read!(input) |> String.split |> Enum.map(&to_charlist/1) |> Enum.map(&convert/1)
    { punch(sequence,5), punch2(sequence,5) }
  end
end


