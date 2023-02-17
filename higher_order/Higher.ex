defmodule Higher do
  def double ([]) do [] end
  def double([h|t]) do [h*2|double(t)] end

  def five ([]) do [] end
  def five([h|t]) do [h+5|double(t)] end

  def animal ([:dog|t]) do [:fido|animal(t)] end
  def animal ([not_dog|t]) do [not_dog|animal(t)] end

  def double_five_animal( list, type) do
     case type  do
      :dog    -> animal(list)
      :five   -> five(list)
      :double -> double(list)
    end
  end
  def apply_to_all([], _) do [] end
  def apply_to_all([head|tail], function) do
      [function.(head) | apply_to_all(tail,function)]
  end

  def test() do
    # f = fn(x) -> x*2 end
    # g = fn(x) -> x+2 end

    # fold_right([1,2,3,4], 0, fn(x, acc) -> {x, acc} end)
    # fold_left([1,2,3,4], 0, fn(x, acc) -> {x, acc} end)
    # odd([1,2,3,4])
    f = fn(x) ->
      if rem(x, 2) == 1 do
        true
      else
        false
      end
    end
    filter([1,2,3,4,5], f)

  end


  def sum([]) do 0 end
  def sum([h|t]) do
      h+sum(t)
  end

  def fold_left([], base_value, _) do base_value end
  def fold_left([h|t], base_value, f ) do
    fold_left(t,f.(h,base_value),f)
  end

  def fold_right([], base_value, _) do base_value end
  def fold_right([h|t], base_value, f ) do
    f.(h, fold_right(t,base_value, f))
  end
  def add(list) do
    ad_op = fn(x,y)-> x+y end
    fold_right(list,0,ad_op)
  end

  def odd(list) do odd(list, []) end
  def odd([], accList) do accList end
  def odd([head|tail], accList ) do
    if rem(head, 2) == 1 do
      odd(tail, [head|accList])
    else
      odd(tail, accList)
    end
  end

  def filter(list, function) do filter(list, [], function) end
  def filter([head|tail], accList, function) do
    case function.(head)  do
      true  -> filter(tail,[head|accList], function)
      false -> filter(tail, accList, function)
    end
  end
  def filter([], accList, _) do accList end

end
