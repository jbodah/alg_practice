tree1 = {
  1,
  {2, nil, nil}, # depth = 2
  {3, {4, nil, {5, nil, nil}}, nil} # depth = 4
}

tree2 = {
  1,
  {
    2,
    {
      3,
      {
        4,
        {
          5,
          {
            6, # depth = 6
            nil,
            nil
          },
          nil
        },
        nil
      },
      nil
    },
    nil
  },
  nil
}

defmodule Tree do
  def depth(t) do
    depth(t, 0)
  end

  def depth(nil, acc), do: acc

  def depth(t, acc) do
    acc2 = acc + 1
    max(
      depth(elem(t, 1), acc2),
      depth(elem(t, 2), acc2)
    )
  end
end

IO.puts Tree.depth(tree1) == 4
IO.puts Tree.depth(tree2) == 6
