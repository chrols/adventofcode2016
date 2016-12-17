defmodule Day17 do

  def open?(char) when char > hd('A'), do: true
  def open?(_), do: false

  def bool_to_direction([ true, a, b, c]), do: [ "U" | bool_to_direction([a,b,c]) ]
  def bool_to_direction([ false, a, b, c]), do: bool_to_direction([a,b,c])
  def bool_to_direction([ true, a, b ]), do: [ "D" | bool_to_direction([a,b]) ]
  def bool_to_direction([ false, a, b ]), do: bool_to_direction([a,b])
  def bool_to_direction([ true, a ]), do: [ "L" | bool_to_direction([a]) ]
  def bool_to_direction([ false, a ]), do: bool_to_direction([a])
  def bool_to_direction([ true  ]), do: ["R"]
  def bool_to_direction([ false ]), do: []


  def open_directions(path) do
    :crypto.hash(:md5, path)
    |> Base.encode16
    |> String.slice(0..3)
    |> to_charlist
    |> Enum.map(&open?/1)
    |> bool_to_direction
  end

  def solution?({{3,3},_}), do: true
  def solution?(_), do: false

  def move({{ x, y }, path}, "U"), do: {{ x, y-1 }, path <> "U"}
  def move({{ x, y }, path}, "D"), do: {{ x, y+1 }, path <> "D"}
  def move({{ x, y }, path}, "L"), do: {{ x-1, y }, path <> "L"}
  def move({{ x, y }, path}, "R"), do: {{ x+1, y }, path <> "R"}

  def inside?({{x,_},_}) when x > 3 or x < 0, do: false
  def inside?({{_,y},_}) when y > 3 or y < 0, do: false
  def inside?(_), do: true

  def expand({node, path}) do
    open_directions(path)
    |> Enum.map(&(move({node, path}, &1)))
    |> Enum.filter(&inside?/1)
  end

  def search([]) do
    :impossible
  end
  def search(list) do
    goal = Enum.filter(list, &solution?/1)
    if Enum.empty?(goal) do
      Enum.flat_map(list, &expand/1)
      |> search
    else
      goal
    end
  end

  def search_goals(start) do
    search_goals(start, [])
  end
  def search_goals([], goals) do
    goals
  end
  def search_goals(list, goals) do
    { at_goal, not_at_goal } = Enum.partition(list, &solution?/1)
    Enum.flat_map(not_at_goal, &expand/1)
    |> search_goals(at_goal ++ goals)
  end

  def start(input), do: [{ {0,0}, input }]

  def path_taken({_, raw_path}, input), do: String.replace_prefix(raw_path, input, "")

  def solve(input) do
    search(start(input))
    |> hd
    |> path_taken(input)
  end

  def solve2(input) do
    search_goals(start(input))
    |> Enum.map(&(path_taken(&1, input)))
    |> Enum.map(&String.length/1)
    |> Enum.max
  end
end
