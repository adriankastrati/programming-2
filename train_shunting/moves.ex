defmodule Moves do
  def single({:one, n}, {main_train, one_train, two_train}) when n > 0 do
      {_, remain, taken} = Train.main(main_train, n)
      {remain, Train.append(taken,one_train), two_train}
  end
  def single({:one, n}, {main_train, one_train, two_train}) when n < 0 do
    {Train.append(main_train, Train.take(one_train, n*-1)), Train.drop(one_train, n*-1), two_train}
  end

  def single({:two, 0}, {main_train, one_train, two_train}) do
    {main_train, one_train, two_train}  end
  def single({:one, 0}, {main_train, one_train, two_train}) do
    {main_train, one_train, two_train}    end
  def single({:two, n}, {main_train, one_train, two_train}) when n > 0 do
    {_, remain, taken} = Train.main(main_train, n)
    {remain, one_train, Train.append(taken,two_train)}
  end
  def single({:two, n}, {main_train, one_train, two_train}) when n < 0 do
    {Train.append(main_train, Train.take(two_train, n*-1)), one_train,  Train.drop(two_train, n*-1)}
  end

  def sequence([head|tail], trains) do
    [trains | sequence(tail ,single(head, trains))]
  end
  def sequence([], trains) do
    trains
  end
end
