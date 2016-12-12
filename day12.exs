defmodule Day12 do

  def operand("a"), do: :a
  def operand("b"), do: :b
  def operand("c"), do: :c
  def operand("d"), do: :d
  def operand(i), do: String.to_integer(i)

  def decode(string) when is_binary(string), do: String.split(string)

  def new_register(), do: %{a: 0, b: 0, c: 0, d: 0, pc: 0}

  def fetch(registers, ins) do
    current_pc = Map.fetch!(registers, :pc)
    current_ins = Enum.at(ins, current_pc)
    case execute(current_ins, registers) do
      :halt -> registers
      v -> fetch(v, ins)
    end
  end

  def inc_pc(registers) do
    %{ pc: current_pc } = registers
    %{ registers | pc: current_pc + 1}
  end

  def inc_pc(registers, offset) do
    %{ pc: current_pc } = registers
    %{ registers | pc: current_pc + offset}
  end

  def execute(["jnz", op1, offset], registers) do
    source = operand(op1)
    value = if is_atom(source) do
      Map.fetch!(registers, source)
    else
      source
    end

    case value do
      0 ->
        inc_pc(registers)
      _ ->
        inc_pc(registers, operand(offset))
    end
  end

  def execute(["cpy", op1, op2], registers) do
    source = operand(op1)
    target = operand(op2)
    updated_reg = if is_atom(source) do
       Map.put(registers, target, Map.fetch!(registers, source))
    else
      Map.put(registers, target, source)
    end
    inc_pc(updated_reg)
  end

  def execute(["inc", op], registers) do
    target = operand(op)
    value = Map.fetch!(registers, target)
    Map.put(registers, target, value + 1)
    |> inc_pc
  end

  def execute(["dec", op], registers) do
    target = operand(op)
    value = Map.fetch!(registers, target)
    Map.put(registers, target, value - 1)
    |> inc_pc
  end

  def execute(_, _), do: :halt

  def run(input) do
    %{ a: value } = fetch(new_register(), input)
    value
  end

  def run_ignition(input) do
    %{ a: value } = fetch(%{ new_register() | c: 1 }, input)
    value
  end

  def read_input(filename) do
    File.read!(filename)
    |> String.split("\n")
    |> Enum.map(&decode/1)
  end

  def solve(filename) do
    input = read_input(filename)
    { run(input), run_ignition(input) }

  end
end
