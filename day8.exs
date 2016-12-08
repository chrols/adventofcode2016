defmodule Day8 do
  def rect(rows, _, 0), do: rows
  def rect([h | t], width, height) do
    [ (for i <- 1..width, do: 35) ++ Enum.drop(h,width) | rect(t, width, height - 1) ]
  end

  def transpose(m) do
    List.zip(m) |> Enum.map(&Tuple.to_list(&1))
  end

  def rotate_column(rows, x, rotation) do
    transpose(rows)
    |> rotate_row(x, rotation)
    |> transpose
  end

  def rotate_row([h | t], 0, rotation) do
    r = Enum.reverse(h)
    b = Enum.take(r, rotation)
    d = Enum.drop(r, rotation)
    nh = Enum.reverse(d ++ b)
    [ nh | t ]
  end
  def rotate_row([h | t], row, rotation) do
    [ h | rotate_row(t, row - 1, rotation) ]
  end

  def new_row(width), do: for i <- 1..width, do: 46 # '.'
  def new_display(width, height), do: for i <- 1..height, do: new_row(width)

  def lit_pixels([]), do: 0
  def lit_pixels([h|t]), do: Enum.count(h, &(&1 == 35)) + lit_pixels(t)

  def solve() do
    :ok
  end
  def decode("rect " <> cord), do: { :rect, String.split(cord,"x") |> Enum.map(&String.to_integer/1) }
  def decode("rotate row y=" <> cord) do
    { :row, String.split(cord,"by")
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.to_integer/1) }
  end
  def decode("rotate column x=" <> cord) do
    { :col, String.split(cord,"by")
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.to_integer/1) }
  end
  def decode(h), do: h


  def transform({ :rect, [w,h] }, rows), do: rect(rows, w, h)
  def transform({ :row, [y,shift] }, rows), do: rotate_row(rows, y, shift)
  def transform({ :col, [x,shift] }, rows), do: rotate_column(rows, x, shift)
  def transform(_, rows), do: rows

  def handle_input(input), do: Enum.reduce(input, new_display(50,6), &transform/2)

  def read_input(filename) do
    File.read!(filename) |> String.split("\n") |> Enum.map(&decode/1)
  end

  def solve(filename) do
    read_input(filename) |> handle_input |> Enum.map(&(IO.puts &1))
    read_input(filename) |> handle_input |> lit_pixels
  end

  def test() do
    6 = new_display(7,3)
    |> rect(3,2)
    |> rotate_column(1,1)
    |> rotate_row(0,4)
    |> rotate_column(1,1)
    |> lit_pixels
    :ok
  end
end

# After you swipe your card, what code is the screen trying to display?
# ZFHFSFOGPO
