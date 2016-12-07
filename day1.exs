defmodule Day1 do
  def turn(:R, :north), do: :east
  def turn(:R, :south), do: :west
  def turn(:R, :west), do: :north
  def turn(:R, :east), do: :south
  def turn(:L, :north), do: :west
  def turn(:L, :south), do: :east
  def turn(:L, :west), do: :south
  def turn(:L, :east), do: :north

  def tuple(<< turn, distance::binary>>), do: { String.to_atom(<<turn>>), String.to_integer(distance) }

  def move(:north, distance, [pos_x, pos_y]), do: [ pos_x + distance, pos_y ]
  def move(:south, distance, [pos_x, pos_y]), do: [ pos_x - distance, pos_y ]
  def move(:east, distance, [pos_x, pos_y]), do: [ pos_x, pos_y + distance ]
  def move(:west, distance, [pos_x, pos_y]), do: [ pos_x, pos_y - distance ]

  def follow_instructions(instructions), do: follow_instructions(instructions, :north, [0,0])

  def follow_instructions([ instruction | tail ], direction, position) do
    { turn_direction, distance } = instruction
    new_direction = turn(turn_direction, direction)
    new_position = move(new_direction, distance, position)
    follow_instructions(tail, new_direction, new_position)
  end

  def follow_instructions(_, _, position), do: position

  def tracking_follow(instructions), do: tracking_follow(instructions, 0, :north, [0,0], [])

  def tracking_follow([ { turn_direction, distance } | tail ], 0, direction, position, visited) do
    tracking_follow(tail, distance, turn(turn_direction, direction), position, visited)
  end

  def tracking_follow(instructions, remaining_distance, direction, position, visited) do
    if Enum.member?(visited, position) do
      position
    else
      new_position = move(direction, 1, position)
      tracking_follow(instructions, (remaining_distance - 1),  direction, new_position, [ position | visited ])
    end
  end

  def tracking_follow(_, _, position, _), do: :no_solution

  def manhattan_distance([x,y]), do: abs(x) + abs(y)

  def destination_distance(instructions), do: follow_instructions(instructions) |> manhattan_distance
  def twice_distance(instructions), do: tracking_follow(instructions) |> manhattan_distance

  def read_instructions(filename) do
    File.read!(filename)
    |> String.trim
    |> String.split(", ")
    |> Enum.map(&tuple/1)
  end

  def solve(filename) do
    instructions = read_instructions(filename)
    { destination_distance(instructions), twice_distance(instructions) }
  end

  def test() do
    5 = follow_instructions([R: 2, L: 3]) |> manhattan_distance
    2 = follow_instructions([R: 2, R: 2, R: 2]) |> manhattan_distance
    12 = follow_instructions([R: 5, L: 5, R: 5, R: 3]) |> manhattan_distance
    4 = tracking_follow([R: 8, R: 4, R: 4, R: 8]) |> manhattan_distance
    :ok
  end
end
