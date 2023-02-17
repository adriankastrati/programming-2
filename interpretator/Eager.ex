defmodule Eager do
  def eval_expr({:atm, id}, _) do {:ok, id} end

  def eval_expr({:var, id}, envir) do
    case Env.lookup(id, envir) do
      nil -> :error
      {_, structure} -> {:ok, structure}
    end
  end
  def eval_expr({:cons, e1, e2}, envir) do
    case eval_expr(e1, envir) do
      :error -> :error
      {:ok, hs} -> case eval_expr(e2, envir) do
        :error -> :error
        {:ok, ts} -> {:ok, {hs, ts}}
      end
    end
  end

  def eval_expr({:case, expr, cls}, envir) do
    case eval_expr(expr, envir) do
      :error -> :error
      {:ok, structure} -> eval_cls(cls, structure, envir)
    end
  end


  def eval_expr({:lambda, param, freeVar, seq}, envir) do
    case Env.closure(freeVar, envir) do
      :error -> :error
      closure -> {:ok, {:closure, param, seq, closure}}
    end
  end

  def eval_expr({:apply, expr, args}, envir) do
    case eval_expr(expr, envir) do
    :error -> :error
    {:ok, {:closure, par, seq, clos}} ->
      case eval_args(args, envir)  do
        :error -> :error
        {:ok, structures} -> eval_seq(seq, Env.args(par, structures, clos))
      end
      {:ok,_}-> :error
    end
  end

  def eval_expr({:fun, id}, _)  do
    {par, seq} = apply(Prgm, id, [])
    {:ok,  {:closure, par, seq, []}}
  end

  def eval_args([], env) do {:ok, []} end
  def eval_args([expr|tail], env) do
      case eval_expr(expr, env) do
        :error -> :error
        {:ok, structure} -> case eval_args(tail, env) do
          :error -> :error
          {:ok, structures} -> {:ok, [structure] ++ structures}
        end
      end
  end


  def eval_cls([{:clause, pattern, seq} | t], structure, envir) do
    case eval_match(pattern, structure, eval_scope(pattern,envir)) do
      :fail -> eval_cls(t, structure, envir)
      {:ok, envir} -> eval_seq(seq, envir)
    end
  end
  def eval_cls([], _, _) do :error end


  def eval_match({:atm, id}, id, envir) do {:ok, envir} end
  def eval_match({:var, x}, structure, envir) do
    case Env.lookup(x, envir) do
      nil -> {:ok , Env.add(x, structure, envir)}
      {_, ^structure} -> {:ok, envir}
      {_,_} -> :fail
    end
  end

  def eval_match({:cons, hp, tp}, {a, b}, envir) do
    case eval_match(hp, a, envir) do
      :fail -> :fail
      {:ok, envir} -> eval_match(tp, b, envir)
    end
  end

  def eval_match(:ignore, _, envir) do
    {:ok, envir}
  end


  def eval_match(_, _, _) do
    :fail
  end

  def eval_scope(pattern, envir) do Env.remove(extract_vars(pattern), envir) end

  def eval_seq([exp], envir) do eval_expr(exp, envir) end
  def eval_seq([{:match, pattern, expr} | tail], envir) do
    case eval_expr(expr, envir) do
      :error -> :error
      {:ok, structure} ->
        case eval_match(pattern, structure, eval_scope(pattern, envir)) do
          :fail -> :error
          {:ok, envir} -> eval_seq(tail, envir)
        end
    end
  end

  def eval(seq) do eval_seq(seq, Env.new()) end
  def extract_vars(pattern) do extract_vars(pattern, []) end
  def extract_vars({:atm,_}, vars) do vars end
  def extract_vars(:ignore, vars) do vars end
  def extract_vars({:var, x}, vars) do [x|vars] end
  def extract_vars({:cons, h, t}, vars) do extract_vars(t, extract_vars(h, vars)) end

  def test() do
    seq = [
      {:match, {:var, :x}, {:atm, :a}},
      {:match, {:var, :f}, {:lambda, [:y], [:x], [{:cons, {:var, :x}, {:var, :y}}]}},
      {:apply, {:var, :f}, [{:atm, :b}]}
    ]
    Eager.eval_seq(seq, Env.new())
  end

  def test1 do
    seq = [{:match, {:var, :x},
         {:cons, {:atm, :a}, {:cons, {:atm, :b}, {:atm, []}}}},
       {:match, {:var, :y},
          {:cons, {:atm, :c}, {:cons, {:atm, :d}, {:atm, []}}}},
       {:apply, {:fun, :append}, [{:var, :x}, {:var, :y}]}
      ]
    Eager.eval_seq(seq, Env.new())
  end
end
