defmodule Day4 do
  def solve(input) do
    real_rooms = File.read!(input)
    |> String.split
    |> Enum.map(&split_row/1)
    |> Enum.filter(&real?/1)

    sector_sum = real_rooms
    |> Enum.map(&(elem(&1,1)))
    |> Enum.sum

    Enum.each(real_rooms, &(decode(elem(&1,2),elem(&1,1))))
  end

  def convert([ checksum, sectorid | t ]) do
    { checksum, String.to_integer(sectorid), Enum.join(t) }
  end

  def split_row(row) do
    row
    |> String.split(["-","[","]"])
    |> Enum.reverse
    |> Enum.drop(1)
    |> convert
  end

  def compare_length(map, e1, e2) do
    m1 = length(Map.fetch!(map, e1))
    m2 = length(Map.fetch!(map, e2))
    if m1 == m2, do: e1 < e2, else: m1 > m2
  end

  def calculate_checksum(string) do
    c = String.to_charlist(string)
    m = Enum.group_by(c, &(&1))
    Enum.sort(c, &(compare_length(m,&1,&2)))
    |> Enum.dedup
    |> Enum.take(5)
    |> to_string
  end

  def real?({ checksum, _, string}) do
    checksum == calculate_checksum(string)
  end

  def decode(string, shift) do
        IO.puts Enum.map(to_charlist(string), &(rem(&1-97+shift,26)+97))
        IO.puts shift
  end

  def test() do
    true = split_row("aaaaa-bbb-z-y-x-123[abxyz]") |> real?
    true = split_row("a-b-c-d-e-f-g-h-987[abcde]") |> real?
    true = split_row("not-a-real-room-404[oarel]") |> real?
    false = split_row("totally-real-room-200[decoy]") |> real?
    'veryencryptedname' = decode("qzmtzixmtkozyivhz",343)
    :ok
  end
end
