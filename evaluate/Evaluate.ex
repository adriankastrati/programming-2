defmodule Evaluate do
  def eval({:num, t}, _) do {:num, t} end
  def eval({:var, x}, env) do {:num, Map.get(env, x)} end
  def eval({:add, e1, e2}, env) do add(eval(e1, env), eval(e2, env)) end
  def eval({:mul, e1, e2}, env) do mul(eval(e1, env), eval(e2, env)) end
  def eval({:sub, e1, e2}, env) do sub(eval(e1, env), eval(e2, env)) end

  def add({:num, n1}, {:num, n2}) do {:num, n1+n2} end
  def sub({:num, n1}, {:num, n2}) do {:num, n1-n2} end
  def mul({:num, n1}, {:num, n2}) do {:num, n1*n2} end

  def test() do
    e = {:add, {:add, {:mul, {:num, 2}, {:var, :x}}, {:num, 3}}, {:num, 2}}
    env = Map.new()
    env = Map.put(env, :x, 10)
    eval(e, env)
  end

end
