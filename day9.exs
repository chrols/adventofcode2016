defmodule Day9 do
  def decode_ins(ins), do: String.split(ins, "x") |> Enum.map(&(String.to_integer(&1)))

  def repeat(pattern, 1), do: pattern
  def repeat(pattern, times), do: pattern <> repeat(pattern, times - 1)

  def scan_start(""), do: 0
  def scan_start("(" <> tail), do: scan_stop(tail, "")
  def scan_start(<< h::utf8 >> <> tail), do: 1 + scan_start(tail)

  def scan_stop(""), do: 0
  def scan_stop(")" <> tail, ins) do
    [ num_chars, repeat ] = String.reverse(ins) |> decode_ins
    { _, rest } = String.split_at(tail, num_chars)
    repeat * num_chars + scan_start(rest)
  end
  def scan_stop( << h::utf8 >> <> t, ins), do: scan_stop(t, << h >> <> ins)

  def scan_start_v2("(" <> tail), do: scan_stop_v2(tail, "")
  def scan_start_v2(<< h::utf8 >> <> tail), do: 1 + scan_start_v2(tail)
  def scan_start_v2(_), do: 0

  def scan_stop_v2(""), do: 0
  def scan_stop_v2(")" <> tail, ins) do
    [ num_chars, repeat ] = String.reverse(ins) |> decode_ins
    { pattern, rest } = String.split_at(tail, num_chars)
    repeat * scan_start_v2(pattern) + scan_start_v2(rest)
  end
  def scan_stop_v2( << h::utf8 >> <> t, ins), do: scan_stop_v2(t, << h >> <> ins)

  def unzip_length(string), do: scan_start(string)
  def unzip_length_v2(string), do: scan_start_v2(string)

  def solve(filename) do
    lines = File.read!(filename)|> String.split
    part1 = lines |> Enum.map(&unzip_length/1) |> Enum.sum
    part2 = lines|> Enum.map(&unzip_length_v2/1) |> Enum.sum
    { part1, part2 }
  end

  def test() do
    7  = unzip_length("A(1x5)BC") # "ABBBBBC"
    9 = unzip_length("(3x3)XYZ") # "XYZXYZXYZ"
    11 = unzip_length("A(2x2)BCD(2x2)EFG") # "ABCBCDEFEFG"
    6 = unzip_length("(6x1)(1x3)A") # "(1x3)A"
    18 = unzip_length("X(8x2)(3x3)ABCY") # "X(3x3)ABC(3x3)ABCY"
    3 = unzip_length_v2("ABC")
    9 = unzip_length_v2("(3x3)ABC")
    241920 = unzip_length_v2("(27x12)(20x12)(13x14)(7x10)(1x12)A")
    445 = unzip_length_v2("(25x3)(3x3)ABC(2x3)XY(5x2)PQRSTX(18x9)(3x2)TWO(5x7)SEVEN")
    :ok
  end
end
