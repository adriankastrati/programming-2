defmodule Huffman do
  def sample do
    'the quick brown fox jumps over the lazy dog
    this is a sample text that we will use when we build
    up a table we will only handle lower case letters and
    no punctuation symbols the frequency will of course not
    represent english but it is probably not that far off'
  end

  def text()  do
    'this is something that we should encode'
  end
  def bencH_encode() do
    sample = read("kallocain.txt")
    {sample, _} = :timer.tc(fn() ->
      tree(sample)
    end)
    tree = tree(sample)
    {encode, _} = :timer.tc(fn() ->
      encode = encode_table(tree)
      encode(sample, encode)
    end)
    seq = encode(sample, encode)
    {decode, _} = :timer.tc(fn() ->
      decode = decode_table(tree)
      decode(seq, decode)
    end)
    {sample, encode,decode}
  end


  def test do
    sample = read("kallocain.txt")
    # sample = text()
    tree = tree(sample)
    encode = encode_table(tree)
    decode = decode_table(tree)
    text = text()
    seq = encode(sample, encode)
    to_string(decode(seq, decode))
  end

  def tree(sample) do
    freq = freq(sample)
    huffman(freq|>Enum.sort(fn({_, x}, {_, y}) -> x < y end))
  end

  def huffman([root]) do root end

  def huffman([{v1, frequency1}, {v2, frequency2} |tail]) do
    node = {{{v1, frequency1}, {v2, frequency2}}, frequency1+frequency2}
    huffman([node|tail]|>Enum.sort(fn({_, x}, {_, y}) -> x < y end))
  end

  def decode_table({{left, right}, _}) do
    List.flatten([decode_table(left, [0]) | decode_table(right,[1])])
  end

  def decode_table({{left, right}, _}, path) do
    [decode_table(left, path++ [0])| decode_table(right,path ++ [1])]
  end

  def decode_table({v1, k1}, path) do
    [{{v1, k1} ,path}]
  end

  def encode_table({{left, right}, _}) do
    List.flatten([encode_table(left, [0]) | encode_table(right, [1])])
  end

  def encode_table({{left, right}, _}, path) do
   [encode_table(left, path++[0]) | encode_table(right, path++[1])]
  end

  def encode_table({v1, _}, path) do
    [{v1 ,path}]
  end


  def decode([], _)  do [] end

  def decode(seq, table) do
    {char, rest} = decode_char(seq, 1, table)
    [char | decode(rest, table)]
  end

  def decode_char(seq, n, table) do
    {code, rest} = Enum.split(seq, n)
    case List.keyfind(table, code, 1) do
      {{char, _}, _} -> {char, rest}
      nil -> decode_char(seq, n+1, table)
    end
  end

  def encode(text, table) do
    encode(text, table, [])
  end
  def encode([], _, encoding) do
    List.flatten(encoding)
  end

  def encode([head | tail], table, encoding) do
    {_, code} = Enum.find(table, fn {char, _} ->
      head == char
    end)

    encode(tail, table, [encoding|[code]])

  end

  def freq(sample) do
    freq(sample, %{})
  end

  def freq([], freq) do
    Map.to_list(freq)
  end

  def freq([char | rest], freq) do
    case Map.get(freq, char) do
      nil -> freq(rest, Map.put(freq, char, 1))
      frequency -> freq(rest, Map.put(freq ,char, frequency+1))
    end
  end

  def read(file) do
    {:ok, file} = File.open(file, [:read, :utf8])
    binary = IO.read(file, :all)
    File.close(file)
    case :unicode.characters_to_list(binary, :utf8) do
      {:incomplete, list, _} -> list
      list -> list
    end
  end

end
