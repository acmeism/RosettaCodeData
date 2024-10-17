defmodule Tree_Traversal do
  defp tnode, do: {}
  defp tnode(v), do: {:node, v, {}, {}}
  defp tnode(v,l,r), do: {:node, v, l, r}

  defp preorder(_,{}), do: :ok
  defp preorder(f,{:node,v,l,r}) do
    f.(v)
    preorder(f,l)
    preorder(f,r)
  end

  defp inorder(_,{}), do: :ok
  defp inorder(f,{:node,v,l,r}) do
    inorder(f,l)
    f.(v)
    inorder(f,r)
  end

  defp postorder(_,{}), do: :ok
  defp postorder(f,{:node,v,l,r}) do
    postorder(f,l)
    postorder(f,r)
    f.(v)
  end

  defp levelorder(_, []), do: []
  defp levelorder(f, [{}|t]), do: levelorder(f, t)
  defp levelorder(f, [{:node,v,l,r}|t]) do
    f.(v)
    levelorder(f, t++[l,r])
  end
  defp levelorder(f, x), do: levelorder(f, [x])

  def main do
    tree = tnode(1,
                 tnode(2,
                       tnode(4, tnode(7), tnode()),
                       tnode(5, tnode(), tnode())),
                 tnode(3,
                       tnode(6, tnode(8), tnode(9)),
                       tnode()))
    f = fn x -> IO.write "#{x} " end
    IO.write "preorder:   "
    preorder(f, tree)
    IO.write "\ninorder:    "
    inorder(f, tree)
    IO.write "\npostorder:  "
    postorder(f, tree)
    IO.write "\nlevelorder: "
    levelorder(f, tree)
    IO.puts ""
  end
end

Tree_Traversal.main
