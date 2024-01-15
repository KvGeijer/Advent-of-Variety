defmodule BasicGrid do
  def read_stdin do
    IO.read(:stdio, :all)
    |> String.split("\n", trim: false)
    |> Enum.map(&String.to_charlist/1)
  end

  def at(grid, row, col) do
    Enum.at(grid, row, [])
    |> Enum.at(col, nil)
  end

  def print(grid) do
    Enum.each(grid, fn row -> IO.puts(row) end)
  end
end

defmodule Solver do

  def vadd({x1, y1}, {x2, y2}) do
    {x1 + x2, y1 + y2}
  end

  def dfs(pos, dir, grid) do 
    {row, col} = pos

    case BasicGrid.at(grid, row, col) do
      nil -> 0
      ?\s -> 0
      ?+ -> 
        {npos, ndir} = [{1, 0}, {-1, 0}, {0, 1}, {0, -1}]
          |> Enum.map(fn d -> {vadd(d, pos), d} end)
          |> Enum.filter(fn {p, _d} -> vadd(p, dir) != pos end)
          |> Enum.filter(fn {{r, c}, _d} -> BasicGrid.at(grid, r, c) not in [?\s, nil] end)
          |> Enum.at(0, nil)
        1 + dfs(npos, ndir, grid)
      char -> 
        if char in ?A..?Z do IO.write([char]) end
        1 + dfs(vadd(pos, dir), dir, grid)
    end
  end

  def solve do
    grid = BasicGrid.read_stdin()
    {_c, start_col} = Enum.at(grid, 0)
      |> Enum.with_index()
      |> Enum.find(fn {c, _i} -> c == ?| end)

    steps = dfs({0, start_col}, {1, 0}, grid)
    IO.puts('')
    IO.puts(steps)
  end
end

Solver.solve()


