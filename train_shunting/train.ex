defmodule Train do
  def take(_, 0) do [] end
  def take([head|tail], n) when n > 0 do [head|take(tail, n-1)] end

  def drop(dropped_train, 0) do dropped_train end
  def drop([_|tail], n) do drop(tail,n-1) end

  def append([head|tail], train2) do [head|append(tail, train2)] end
  def append([], train2) do train2 end

  def member([y|_], y) do true end
  def member([_|tail], y) do member(tail, y) end
  def member([],_) do false end

  def position(train, y) do position(train, y, 0) end
  def position([y|_], y, n) do n end
  def position([_|tail], y, n) do position(tail, y, n+1) end

  def split(train, wagon) do split(train, [], wagon) end
  def split([wagon|tail], train2, wagon) do {train2, tail} end
  def split([head|tail], train2, wagon) do split(tail, append(train2,[head]), wagon) end
  def split([], train2, _) do train2 end

  def main([], n) do {n, [], []} end
  def main([head|tail], n) do
    case main(tail, n) dotrain
      {0, remain, take} -> {0, [head|remain], take}
      {n, remain, take} -> {n-1, remain, [head|take]}
    end
  end

end
