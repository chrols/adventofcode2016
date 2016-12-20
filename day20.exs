defmodule Day20 do
  def string2tuple(string) do
    [ v1, v2 ] =
      String.split(string, "-")
      |> Enum.map(&(String.to_integer(&1)))
    { v1, v2 }
  end

  def smaller?({ s1, _}, {s2, _}), do: s1 < s2

  def read(filename) do
    File.read!(filename)
    |> String.split("\n")
    |> Enum.filter(&(&1 != ""))
    |> Enum.map(&string2tuple/1)
    |> Enum.map(&order/1)
    |> Enum.sort(&smaller?/2)
  end


  def search(list), do: search(0, list)
  def search(low, [ { start, _ } | _ ]) when start > low+1 do
    low + 1
  end
  def search(low, [ { _, stop } | tail ]) when low > stop do
    search(low, tail)
  end
  def search(_, [ { _, stop } | tail ]) do
    search(stop, tail)
  end

  def first_unblocked(filename) do
    read(filename)
    |> search
  end

  def merge_overlapping([ { s1, e1 }, {s2, e2}  | tail]) when s2 <= (e1+1)  do
      merge_overlapping([{ s1, max(e1,e2) }|tail])
  end
  def merge_overlapping([ v1  | tail]), do: [ v1 | merge_overlapping(tail) ]
  def merge_overlapping([]), do: []

  def count_range({start, stop}) when start < stop, do: stop-start+1

  def sum_it(list) do
    Enum.map(list, &count_range/1)
    |> Enum.sum
  end

  def count_unblocked(filename) do
    sum_blocked = read(filename)
    |> merge_overlapping
    |> sum_it
    4294967296 - sum_blocked
  end

  def order({ v1, v2 }) when v2 < v1, do: { v2, v1 }
  def order({ v1, v2 }) when v2 >= v1, do: { v1, v2 }

  def solve(filename) do
    { first_unblocked(filename), count_unblocked(filename) }
  end

end
