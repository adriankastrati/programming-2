defmodule Shunt do
  def find([],[]) do [] end
  def find(xs, [y|ys]) do
    {hs, ts} = Train.split(xs, y)
    ts_wagons = length(ts)
    hs_wagons = length(hs)
    [{:one, ts_wagons+1}, {:two, hs_wagons}, {:one, -(ts_wagons+1)}, {:two, -hs_wagons} | find(Train.append(hs, ts), ys)]
  end

  def few([],[]) do [] end
  def few(xs, [y|ys]) do
    {hs, ts} = Train.split(xs, y)
    ts_wagons = length(ts)
    hs_wagons = length(hs)
    case {hs_wagons, ts_wagons+1} do
      {0,_} -> few(Train.append(hs, ts), ys)
      {_,0} -> few(Train.append(hs, ts), ys)
      _ -> [{:one, ts_wagons+1}, {:two, hs_wagons}, {:one, -(ts_wagons+1)}, {:two, -hs_wagons} | few(Train.append(hs, ts), ys)]
    end
  end

  def rule_1({track, move}, tail_move) do
    case tail_move do
      [] -> track
      {^track, move1} -> {track, move+move1}
    end
  end


  def rules([{track_1, move_1} | track_tail]) do

    rule_applied = case track_tail do
      [] -> {{track_1, move_1},track_tail}
      [{^track_1, move_trail} | track_tail] -> {{track_1, move_trail+move_1}, track_tail}
      _ -> {{track_1, move_1},track_tail}
    end

    {{track, move}, track_tail} = rule_applied

    case move do
      0 -> rules(track_tail)
      _ -> [{track, move}|rules(track_tail)]
    end

  end

  def rules([]) do [] end
  def compress(ms) do
    ns = rules(ms)
    if ns == ms do
    ms
    else
      compress(ns)
    end
  end

end
