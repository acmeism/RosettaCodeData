def ptree(tree,indent="  ")
  case tree
  when Array
    head,*tail=tree
    ptree(head,indent)
    s=tail.size-1
    tail.each_with_index { |tree1,i| ptree(tree1,"#{indent}#{((i==s) ? ' ':'|')}  ") }
  else
     puts(indent.gsub(/\s\s$/,"--").gsub(/ --$/,"\\--")+tree.to_s)
  end
end
ptree [1,2,3,[4,5,6,[7,8,9]],3,[22,33]]
