defmodule Carlo do

  def dart(r) do
    x = Enum.random(0..r)
    y = Enum.random(0..r)
    :math.pow(r,2)  >  :math.pow(x,2)  + :math.pow(y,2)
  end

  def roundp(0, _, hits) do hits end
  def roundp(n, radius, hits) do
    if dart(radius) do
      roundp(n-1, radius, hits + 1)
    else
      roundp(n-1, radius, hits)
    end
 end

  def rounds(k, darts, radius)  do
  rounds(k, darts, 0, radius, 0)
  end

  def rounds(0, _, total, _, hits) do 4 * hits / total  end
  def rounds(k, darts, total, radius, hits) do
    hits = roundp(darts, radius, hits)
    total = total + darts
    pi = 4 * hits / total
    :io.format("j = ~w  pi = ~12f,  Δpi = ~14.10f\n",  [darts ,pi, (pi - :math.pi())])
    rounds(k-1, darts+1000, total, radius, hits)
  end

  def lib(n) do
  4 * Enum.reduce(0..n, 0, fn(k,a) -> a + 1/(4*k + 1) - 1/(4*k + 3) end)
  end
end
# c("Carlo.ex")
# Carlo.rounds(1000,100000000,100000000)

# dart  pi          $\delta\pi$
# 2000     3.137333 -0.0042593203
# 4000     3.136000 -0.0055926536
# 1000     3.120000 -0.0215926536
# 8000     3.133600 -0.0079926536
# 16000    3.136000 -0.0055926536
# 32000    3.139111 -0.0024815425
# 64000    3.140724 -0.0008682441
# 128000   3.143529  0.0019367582
# 256000   3.144462  0.0028691859
# 512000   3.141650  0.0000573953
# 1024000  3.142753  0.0011606439
# 2048000  3.141316 -0.0002769027
# 4096000  3.141612  0.0000193596
# 8192000  3.142375  0.0007824914
# 16384000 3.141648  0.0000552238
