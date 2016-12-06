defmodule Day6 do
  def read_rows(filename) do
    File.read!(filename)
    |> String.split
    |> Enum.map(&(to_charlist(&1)))
  end

  def rows_to_column(rows, index) do
    Enum.reduce(rows, [], &([ Enum.at(&1, index) | &2 ]))
  end

  def rows_to_columns(rows) do
    [ first | _ ] = rows
    last_column_id = length(first) - 1
    Enum.map(0..last_column_id, &(rows_to_column(rows, &1)))
  end

  def most_common_element(row) do
    groups = Enum.group_by(row, &(&1))
    occurences =  &(Map.fetch!(groups, &1) |> length)
    [ most_common | _ ] = Enum.sort(Map.keys(groups), &(occurences.(&1) > occurences.(&2)))
    most_common
  end

  def least_common_element(row) do
    groups = Enum.group_by(row, &(&1))
    occurences =  &(Map.fetch!(groups, &1) |> length)
    [ least_common | _ ] = Enum.sort(Map.keys(groups), &(occurences.(&1) < occurences.(&2)))
    least_common
  end

  def most_common_ecc(rows), do: Enum.map(rows_to_columns(rows), &most_common_element/1)
  def least_common_ecc(rows), do: Enum.map(rows_to_columns(rows), &least_common_element/1)

  def solve(input_file) do
    input = read_rows(input_file)
    { most_common_ecc(input), least_common_ecc(input) }
  end

  def test() do
    example = ['eedadn', 'drvtee', 'eandsr', 'raavrd', 'atevrs',
    'tsrnev', 'sdttsa', 'rasrtv', 'nssdts', 'ntnada', 'svetve',
    'tesnvt', 'vntsnd', 'vrdear', 'dvrsen', 'enarar']

    'easter' = most_common_ecc(example)
    'advent' = least_common_ecc(example)
    :ok
  end
end
