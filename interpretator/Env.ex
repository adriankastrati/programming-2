defmodule Env do

  def new() do [] end

  def add(id, str, []) do [{id, str}] end
  def add(id, str,[{id, _} | m]) do [{id,str}|m] end
  def add(id, str, [t | m]) do [t | add(id, str, m)]end

  def lookup(_,[]) do nil end
  def lookup(id, [{id, str} | _]) do {id, str}  end
  def lookup(id,[_ | m]) do lookup(id,m) end

  def remove(_, []) do [] end
  def remove([remId],[remId| m]) do m end

  def remove(remId,[remId| m]) do m end
  def remove(remId, [id | m]) do [id | remove(remId, m)] end

  def closure(freeVar, env) do closure(freeVar, [], env) end
  def closure([id|vt], acc, env) do
    case acc do
      :error -> :error
      _ -> case lookup(id, env) do
        nil -> closure([id|vt],:error, env)
        var -> closure(vt, [var|acc], env)
      end

    end
  end
  def closure([], list, _) do list end

  def args(pars, args, env) do
    env ++ List.zip([pars, args])
  end

end
