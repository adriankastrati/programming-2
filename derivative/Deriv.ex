defmodule Deriv do
  @type literal() :: {:num, number()}
  | {:var, atom()}

  @type expr() :: literal()
  | {:add, expr(), expr()}
  | {:mul, expr(), expr()}
  | {:exp, expr(), literal()}
  | {:ln, expr()}
  | {:div, expr(), expr()}
  | {:sin, expr()}
  | {:sqrt, expr()}

  def test1() do
  e =  {:mul,
          {:mul, {:var, :x},{:num, 2}},
          {:div, {:num, 1}, {:num, 2}}
  }
  d = {:sqrt,{:num,9}}
  # d =  deriv(e, :x)

  IO.write("expression: #{pprint(d)}\n")
  IO.write("simplified: #{pprint(simplify(d))}\n")

  # IO.write("derivative: #{pprint(d)}\n")
  # IO.write("simplified: #{pprint(simplify(d))}\n")
  :ok
  end

  def test2() do
    e =  {:add,
            {:sqrt, {:var, :x}},
            {:num, 4}
    }

    d =  deriv(e, :x)

    IO.write("expression: #{pprint(e)}\n")
    IO.write("derivative: #{pprint(d)}\n")
    IO.write("simplified: #{pprint(simplify(d))}\n")
    :ok
  end

  def testLn() do
    e =  {:ln,
      {:exp, {:var, :x}, {:num, 2}}
    }

    d =  deriv(e ,:x)

    IO.write("expression: #{pprint(e)}\n")
    IO.write("derivative: #{pprint(d)}\n")
    IO.write("simplified: #{pprint(simplify(d))}\n")
    :ok
  end

  def testSin() do
    e =  {:sin,
      {:mul, {:var, :x}, {:num, 2}}
    }
    d =  deriv(e, :x)

    IO.write("expression: #{pprint(e)}\n")
    IO.write("derivative: #{pprint(d)}\n")
    IO.write("simplified: #{pprint(simplify(d))}\n")
    :ok
  end

  def deriv({:num, _}, _) do {:num, 0} end
  def deriv({:var, v}, v) do {:num, 1} end
  def deriv({:var, _}, _) do {:num, 0} end
  def deriv({:add, e1, e2}, v) do {:add, deriv(e1, v), deriv(e2, v)} end
  def deriv({:mul, e1, e2}, v) do
  {:add,
    {:mul, deriv(e1, v), e2},
    {:mul, deriv(e2, v), e1}
  }
  end
  def deriv({:exp, e, {:num, n}}, v) do
    {:mul,
      {:mul, {:num ,n}, {:exp, e, {:num, n-1}}},
      deriv(e, v)
    }
  end
  def deriv({:sin, e}, v) do
    {:mul,
      deriv(e,v),
      {:cos, e}
    }
  end
  def deriv({:sqrt, e}, v) do
    deriv({:exp, e, {:num, 0.5}}, v)
  end

  # def deriv({:ln, e}, v) do
  #   {:mul,
  #     {:exp, e, {:num, -1}},
  #     deriv(e, v)
  #   }
  # end


  def deriv({:ln, e}, v) do
     {:mul,
      {:div, {:num, 1}, e},
      deriv(e, v)
    }
  end
  # def deriv({:div, {:num, v}, {}}) do


  def simplify({:add, e1, e2}) do simplify_add(simplify(e1), simplify(e2)) end
  def simplify({:mul, e1, e2}) do simplify_mul(simplify(e1), simplify(e2)) end
  def simplify({:exp, e1, e2}) do simplify_exp(simplify(e1), simplify(e2)) end
  def simplify({:div, e1, e2}) do simplify_div(simplify(e1), simplify(e2)) end
  def simplify({:sqrt, e1}) do simplify_sqrt(simplify(e1)) end
  def simplify({:sin, e1}) do simplify_sin(simplify(e1)) end

  def simplify(e) do e end

  def simplify_sin({coa})

  def simplify_add({:num, 0}, e2) do e2 end
  def simplify_add(e1, {:num, 0}) do e1 end
  def simplify_add({:num, n1}, {:num, n2}) do {:num, n1+n2} end
  def simplify_add(e1, e2) do {:add, e1, e2} end


  def simplify_mul({:num, 0}, _) do {:num,0} end
  def simplify_mul(_, {:num, 0}) do {:num,0} end
  def simplify_mul({:num, n1}, {:num, n2}) do {:num, n1*n2} end
  def simplify_mul(e1,{:num, 1}) do e1 end
  def simplify_mul({:num, 1}, e2) do e2 end
  def simplify_mul(e1, e2) do {:mul, e1, e2} end
  # def simplify_mul({:div, e1, {:num, n1}}, {:num, n1}) do {:mul, e1, {:num,}} end



  def simplify_exp(_, {:num, 0}) do {:num,1} end
  def simplify_exp(e1, {:num, 1}) do e1 end
  def simplify_exp({:num, n1}, {:num, n2}) do {:num, :math.pow(n1,n2)} end
  def simplify_exp(e1, e2) do {:exp, e1, e2} end


  def simplify_div({:num, n1}, {:num, n2}) do {:num, n1/n2} end
  def simplify_div({_, n}, {_, n}) do {:num, 1} end
  def simplify_div(e1,e2) do {:div, e1, e2} end

  def simplify_sqrt({:num, n1}) do {:num, :math.sqrt(n1)} end
  def simplify_sqrt(e) do {:sqrt, e} end


  def pprint({:num,n}) do "#{n}" end
  def pprint({:var,v}) do "#{v}" end
  def pprint({:add,e1, e2}) do "(#{pprint(e1)} + #{pprint(e2)})" end
  def pprint({:mul,e1, e2}) do "#{pprint(e1)} * #{pprint(e2)}" end
  def pprint({:exp ,e1, e2}) do "#{pprint(e1)}^(#{pprint(e2)})" end
  def pprint({:ln, e}) do "ln(#{pprint(e)})" end
  def pprint({:div, e1, e2}) do "(#{pprint(e1)})/(#{pprint(e2)})" end
  def pprint({:cos, e}) do "cos(#{pprint(e)})" end
  def pprint({:sin, e}) do "sin(#{pprint(e)})" end
  def pprint({:sqrt, e}) do "sqrt(#{pprint(e)})" end
end
