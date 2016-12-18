defmodule Day18 do

  def new_room(row, 1), do: [ row ]
  def new_room(row, floor) do
    [ row | new_row(row) |> new_room(floor - 1) ]
  end

  def new_row(row) do
    next_row("." <> row <> ".")
  end

  def next_row("^^." <> tail), do: "^" <> next_row("^." <> tail)
  def next_row(".^^" <> tail), do: "^" <> next_row("^^" <> tail)
  def next_row("^.." <> tail), do: "^" <> next_row(".." <> tail)
  def next_row("..^" <> tail), do: "^" <> next_row(".^" <> tail)
  def next_row(<< a, b, c>> <> tail), do: "." <> next_row(<<b,c>> <> tail)
  def next_row(<< _, _ >>), do: ""

  def read(filename) do
    File.read!(filename)
    |> String.split
    |>hd
  end

  def count_row("^" <> tail), do: count_row(tail)
  def count_row("." <> tail), do: 1+count_row(tail)
  def count_row(""), do: 0

  def count_room(room) do
    Enum.map(room, &count_row/1)
    |> Enum.sum
  end

  def solve(filename, rows) do
    read(filename)
    |> new_room(rows)
    |> count_room
  end

  def solve(filename) do
    { solve(filename, 40), solve(filename, 400000) }
  end

  def test() do
    "^^^...^..^" = new_row(".^^.^.^^^^")
    "^.^^.^.^^." = new_row("^^^...^..^")
    "..^^...^^^" = new_row("^.^^.^.^^.")
    ".^^^^.^^.^" = new_row("..^^...^^^")
    "^^..^.^^.." = new_row(".^^^^.^^.^")
    "^^^^..^^^." = new_row("^^..^.^^..")
    "^..^^^^.^^" = new_row("^^^^..^^^.")
    ".^^^..^.^^" = new_row("^..^^^^.^^")
    "^^.^^^..^^" = new_row(".^^^..^.^^")
    38 = new_room(".^^.^.^^^^", 10) |> count_room
    :ok
  end
end
