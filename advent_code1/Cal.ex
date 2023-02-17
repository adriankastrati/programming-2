defmodule Cal do
  def day1() do
    sorted_list = to_list("input.csv")|> Enum.sort(:desc)
    top1 = sorted_list |> List.first()
    top3 = sorted_list |> Enum.take(3) |> Enum.sum()
    {top1, top3}
  end

  def to_list(path) do
    File.stream!(path)
    |> Stream.map(&String.trim/1)
    |> Stream.chunk_while(0,
    fn x, acc ->
      case x do
        "" -> {:cont, acc, 0}
        _ -> {:cont, acc+ String.to_integer(x)}
      end
    end,
    fn _ -> {:cont, []} end)
    |> Enum.to_list()
  end



end
