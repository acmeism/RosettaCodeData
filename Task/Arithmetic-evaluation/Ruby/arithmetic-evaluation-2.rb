exp = "1 + 2 - 3 * (4 / 6)"
puts("Original: " + exp)

tree = infix_exp_to_tree(exp)
puts("Prefix: " + tree.to_s(:prefix))
puts("Infix: " + tree.to_s(:infix))
puts("Postfix: " + tree.to_s(:postfix))
puts("Result: " + tree.eval.to_s)
