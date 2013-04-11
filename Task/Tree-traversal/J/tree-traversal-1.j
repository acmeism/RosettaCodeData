preorder=: ]S:0
postorder=: ([:; postorder&.>@}.) , >@{.
levelorder=: ;@({::L:1 _~ [: (/: #@>) <S:1@{::)
inorder=: ([:; inorder&.>@(''"_`(1&{)@.(1<#))) , >@{. , [:; inorder&.>@}.@}.
