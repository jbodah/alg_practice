tree1 = {
  1,
  {2, {4, nil, nil}, {5, nil, nil}},
  {3, {6, nil, nil}, {7, nil, nil}}
}

tree2 = {
  1,
  {2, {4, nil, nil}, {5, nil, nil}},
  {3, {6, nil, nil}, nil}
}

tree3 = {
  1,
  {2, {4, nil, nil}, {5, nil, nil}},
  {3, nil, {7, nil, nil}}
}

defmodule Tree do
  def complete?(tree) do
    result =
      preorder(tree, fn
        {_, nil, right} when not is_nil(right) ->
          :error
        _ ->
          :ok
      end)

    case result do
      :ok -> true
      :error -> false
    end
  end

  def preorder(nil, _), do: :ok

  def preorder(tree, fun) do
    {_val, left, right} = tree
    with :ok <- fun.(tree),
         :ok <- preorder(left, fun) do
      preorder(right, fun)
    end
  end
end

IO.puts Tree.complete?(tree1) == true
IO.puts Tree.complete?(tree2) == true
IO.puts Tree.complete?(tree3) == false
