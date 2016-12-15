defmodule Day15 do
  def time(), do: Stream.iterate(0, &(&1+1))

  def open?(time, start_pos, max_pos), do: rem(time+start_pos, max_pos) == 0

  def disc_stream({ curr_pos, max_pos}, time_stream) do
    Stream.map(time_stream, &(&1+1))
    |> Stream.filter(&(open?(&1, curr_pos, max_pos)))
  end

  def create_stream(discs) do
    Enum.reduce(discs, time, &disc_stream/2)
  end

  def decode_row(string) do
    parts = String.split(string)
    positions = Enum.at(parts, 3)
    |> String.to_integer

    start_pos = List.last(parts)
    |> String.split(".")
    |> hd
    |> String.to_integer
     { start_pos, positions }
  end

  def read_input(filename) do
    File.read!(filename)
    |> String.trim
    |> String.split("\n")
    |> Enum.map(&decode_row/1)
  end

  def solve(filename) do
    discs = read_input(filename)
    disc_stream = create_stream(discs)

    solution1 = disc_stream
    |> Enum.take(1)
    |> hd
    |> Kernel.-(length(discs))

    solution2 = disc_stream({0,11}, disc_stream)
    |> Enum.take(1)
    |> hd
    |> Kernel.-(length(discs)+1)

    { solution1, solution2 }
  end
end
