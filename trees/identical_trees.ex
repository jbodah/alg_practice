tree1 = {
  1, {2, {4, nil, nil}, nil}, {3, nil, nil}
}

tree2 = {
  1, {2, nil, nil}, {3, nil, {4, nil, nil}}
}

defmodule Tree do
  def identical?(t1, t2) when is_nil(t1) or is_nil(t2) do
    t1 == t2
  end

  def identical?(t1, t2) do
    if elem(t1, 0) == elem(t2, 0) do
      identical?(elem(t1, 1), elem(t2, 1)) && identical?(elem(t1, 2), elem(t2, 2))
    else
      false
    end
  end
end

IO.puts Tree.identical?(tree1, tree1)
IO.puts Tree.identical?(tree2, tree2)
IO.puts Tree.identical?(tree1, tree2)
