tree = {
  1,
  {
    2,
    {
      4,
      nil,
      nil
    },
    {
      5,
      nil,
      nil
    },
  },
  {
    3,
    nil,
    nil
  }
}

defmodule Tree do
  def inorder(nil, _), do: :ok

  def inorder({val, left, right}, fun) do
    inorder(left, fun)
    fun.(val)
    inorder(right, fun)
  end

  def preorder(nil, _), do: :ok

  def preorder({val, left, right}, fun) do
    fun.(val)
    preorder(left, fun)
    preorder(right, fun)
  end

  def postorder(nil, _), do: :ok

  def postorder({val, left, right}, fun) do
    postorder(left, fun)
    postorder(right, fun)
    fun.(val)
  end

  def breadth_first(tree, fun) do
    do_breadth_first([tree], fun)
  end

  def do_breadth_first([], _) do
    :ok
  end

  def do_breadth_first([{val, left, right}|tail], fun) do
    fun.(val)
    queue = tail
    queue = if left, do: queue ++ [left], else: queue
    queue = if right, do: queue ++ [right], else: queue
    do_breadth_first(queue, fun)
  end
end

{:ok, agent} = Agent.start_link(fn -> [] end)
Tree.inorder(tree, fn v -> Agent.update(agent, & &1 ++ [v]) end)
IO.inspect Agent.get(agent, & &1) == [4, 2, 5, 1, 3]

{:ok, agent} = Agent.start_link(fn -> [] end)
Tree.preorder(tree, fn v -> Agent.update(agent, & &1 ++ [v]) end)
IO.inspect Agent.get(agent, & &1) == [1, 2, 4, 5, 3]

{:ok, agent} = Agent.start_link(fn -> [] end)
Tree.postorder(tree, fn v -> Agent.update(agent, & &1 ++ [v]) end)
IO.inspect Agent.get(agent, & &1) == [4, 5, 2, 3, 1]

{:ok, agent} = Agent.start_link(fn -> [] end)
Tree.breadth_first(tree, fn v -> Agent.update(agent, & &1 ++ [v]) end)
IO.inspect Agent.get(agent, & &1) == [1, 2, 3, 4, 5]
