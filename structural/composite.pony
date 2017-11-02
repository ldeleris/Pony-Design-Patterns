use "collections"

interface Node
  fun string(prefix: String): String

class Leaf  is Node
  let _data: String

  new create(data: String) => _data = data

  fun string(prefix: String): String =>
    prefix + _data + "\n"

class Tree is Node
  let _children: List[Node] = List[Node](0)

  fun ref add(child: Node) =>
   //_children.unshift(child)
    _children.push(child)

  fun ref remove() =>
    if _children.size() != 0 then
      try _children.remove(0)? end
    end
           
    fun string(prefix: String): String =>
        prefix + "(\n" + 
        _children.fold[String]({(acc: String, node: this->Node ref): String =>
          acc + node.string(prefix + prefix)} box, "") +
        prefix + ")\n"

actor Composite
  new create(env: Env) =>
    env.out.print("Composite:")
    let tree: Tree = Tree
    tree.add(Leaf("leaf 1"))

    let subtree1: Tree = Tree
    subtree1.add(Leaf("leaf 2"))

    let subtree2: Tree = Tree
    subtree2.add(Leaf("leaf 3"))
    subtree2.add(Leaf("leaf 4"))
    subtree1.add(subtree2)

    tree.add(subtree1)

    let subtree3: Tree = Tree
    let subtree4: Tree = Tree
    subtree4.add(Leaf("leaf 5"))
    subtree4.add(Leaf("leaf 6"))

    subtree3.add(subtree4)
    tree.add(subtree3)

    env.out.print(tree.string("-"))