defmodule EnvList do

  def new() do [] end

  #returns a map wity key and value added, if key exists change value
  def add([], key, value) do [{key, value}] end
  def add([{key, _} | m], key, value) do [{key,value}|m] end
  def add([t | m], key, value) do [t | add(m, key, value)]end

  def lookup([], _) do nil end
  def lookup([{key, value} | _], key) do {key, value}  end
  def lookup([_ | m], key) do lookup(m, key) end

  def remove([],_) do nil end
  def remove([{key, _} | m], key) do m end
  def remove([t | m], key) do [t | remove(m, key)] end

end
