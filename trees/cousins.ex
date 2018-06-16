tree1 = {
  1,
  {2, {4, nil, nil}, {5, nil, nil}},
  {3, {6, nil, nil}, {7, nil, nil}}
}

defmodule Tree do
  def cousins?(tree, c1, c2) do
    {:ok, agent} = Agent.start_link(fn -> {nil, nil} end)

    preorder(
      tree,
      fn {val, _left, _right}, meta = {_parent, depth} ->
        if val == c1, do: Agent.update(agent, & put_elem(&1, 0, meta))
        if val == c2, do: Agent.update(agent, & put_elem(&1, 1, meta))
        {:ok, {val, depth + 1}}
      end,
      {nil, 0}
    )

    case Agent.get(agent, & &1) do
      {{p1, d1}, {p2, d2}} -> d1 == d2 && p1 != p2
      _ -> false
    end
  end

  # todo - better to use breadth first
  # todo - escape hatch when passing level
  def preorder(nil, _, _), do: :ok

  def preorder(tree, fun, acc) do
    {_val, left, right} = tree
    with {:ok, acc2} <- fun.(tree, acc),
         :ok <- preorder(left, fun, acc2) do
      preorder(right, fun, acc2)
    end
  end
end

IO.puts Tree.cousins?(tree1, 4, 6) == true
IO.puts Tree.cousins?(tree1, 4, 7) == true
IO.puts Tree.cousins?(tree1, 5, 6) == true
IO.puts Tree.cousins?(tree1, 5, 7) == true

IO.puts Tree.cousins?(tree1, 2, 3) == false
IO.puts Tree.cousins?(tree1, 4, 5) == false
IO.puts Tree.cousins?(tree1, 6, 7) == false
IO.puts Tree.cousins?(tree1, 4, 3) == false
