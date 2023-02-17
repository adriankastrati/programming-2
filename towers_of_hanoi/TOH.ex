defmodule TOH do
  def hanoi(n) do
    hanoi(n,:a,:b,:c)
  end
  def hanoi(0, _, _, _) do [] end
  def hanoi(n, from, aux, to) do
    hanoi(n-1,from, to, aux)  ++
    [ {:move, from, to} ] ++
    hanoi(n-1, aux, from, to)
  end
  def test() do
    hanoi(3,:a,:b,:c)
  end

end
