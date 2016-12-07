defmodule Day7 do

  def abba?(string) when is_binary(string), do: abba?(to_charlist(string))
  def abba?([ a, b, b, a | _ ]) when a != b, do: true
  def abba?([ _, a, b, c | t ]), do: abba?([a, b, c | t])
  def abba?(_), do: false

  def supernets(string), do: String.split(string,["[","]"]) |> Enum.take_every(2)

  def hypernets(string) do
    [ _ | tail ] = String.split(string,["[","]"])
    Enum.take_every(tail, 2)
  end

  def any_abba?(nets), do: Enum.map(nets, &abba?/1) |> Enum.any?

  def tls?(string) when is_binary(string) do
    (supernets(string) |> any_abba?) and not (hypernets(string) |> any_abba?)
  end

  def contains_substring(strings, substring) do
    Enum.any?(strings, &(String.contains?(&1, substring)))
  end

  def check_string(<< a, b, a, t::binary >>, hypernets) when a != b do
    contains_substring(hypernets, <<b, a, b>>) or check_string(<< b, a, t::binary >>, hypernets)
  end
  def check_string(<< _, t::binary >>, hypernets) do
    check_string(t, hypernets)
  end
  def check_string(_, _), do: false

  def count_tls(ips) do
    Enum.filter(ips, &tls?/1) |> length
  end

  def count_ssl(ips) do
    Enum.filter(ips, &ssl?/1) |> length
  end

  def ssl?(string) do
    Enum.any?(supernets(string), &(check_string(&1, hypernets(string))))
  end

  def read_ips(filename), do: File.read!(filename) |> String.split

  def solve(filename) do
    { count_tls(read_ips(filename)),
      count_ssl(read_ips(filename)) }
  end

  def test() do
    true = tls?("abba[mnop]qrst")
    false = tls?("abcd[bddb]xyyx")
    false = tls?("aaaa[qwer]tyui")
    true = tls?("ioxxoj[asdfgh]zxcvbn")
    true = ssl?("aba[bab]xyz")
    false = ssl?("xyx[xyx]xyx")
    true = ssl?("aaa[kek]eke")
    true = ssl?("zazbz[bzb]cdb")
    :ok
  end
end

