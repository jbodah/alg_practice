tree = {
  1,
  {2, nil, {4, nil, nil}},
  {3, {5, {7, nil, nil}, {8, nil, nil}}, {6, nil, nil}}
}

tree2 = {
  1,
  {2, nil, nil},
  {3, {5, {7, nil, nil}, {8, nil, nil}}, {6, nil, nil}}
}

defmodule Tree do
  def left_view(tree) do
    {:ok, agent} = Agent.start_link(fn -> [] end)

    preorder(
      tree,
      fn v, depth ->
        state = Agent.get(agent, & &1)
        if Enum.at(state, depth) do
          state
        else
          new_state = state ++ [v]
          Agent.update(agent, fn _ -> new_state end)
        end
        depth + 1
      end,
      0
    )

    Agent.get(agent, & &1)
  end

  def preorder(nil, _, acc), do: acc

  def preorder({val, left, right}, fun, acc) do
    acc2 = fun.(val, acc)
    preorder(left, fun, acc2)
    preorder(right, fun, acc2)
  end

  def bottom_view(tree) do
    {:ok, agent} = Agent.start_link(fn -> %{} end)

    breadth_first(
      tree,
      fn v, pos ->
        Agent.update(agent, & put_in(&1[pos], v))
        [left: pos - 1, right: pos + 1]
      end,
      0
    )

    map = Agent.get(agent, & &1)
    Map.keys(map) |> Enum.sort |> Enum.map(& map[&1])
  end

  def top_view(tree) do
    {:ok, agent} = Agent.start_link(fn -> %{} end)

    breadth_first(
      tree,
      fn v, pos ->
        Agent.update(agent, fn map ->
          if map[pos], do: map, else: put_in(map[pos], v)
        end)
        [left: pos - 1, right: pos + 1]
      end,
      0
    )

    map = Agent.get(agent, & &1)
    Map.keys(map) |> Enum.sort |> Enum.map(& map[&1])
  end

  def breadth_first(tree, fun, acc) do
    do_breadth_first([{tree, acc}], fun)
  end

  def do_breadth_first([], _) do
    :ok
  end

  def do_breadth_first([{{val, left, right}, acc}|tail], fun) do
    [left: left_acc, right: right_acc] = fun.(val, acc)
    queue = tail
    queue = if left, do: queue ++ [{left, left_acc}], else: queue
    queue = if right, do: queue ++ [{right, right_acc}], else: queue
    do_breadth_first(queue, fun)
  end
end

IO.puts Tree.left_view(tree) == [1, 2, 4, 7]
IO.puts Tree.bottom_view(tree) == [7, 5, 8, 6]
IO.puts Tree.top_view(tree) == [2, 1, 3, 6]
