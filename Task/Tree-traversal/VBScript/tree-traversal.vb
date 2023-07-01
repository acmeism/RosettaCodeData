'         1
'        / \
'       /   \
'      /     \
'     2       3
'    / \     /
'   4   5   6
'  /       / \
' 7       8   9
'with no pointers available, the binary tree has to be saved in an array
'   root at index 1
'   parent index is i\2
'   children indexes are i*2 and i*2+1
'   a value of 0 denotes an empty branch

  Sub print(s):
    On Error Resume Next
    WScript.stdout.Write(s)
    If  err= &h80070006& Then WScript.Echo " Please run this script with CScript": WScript.quit
  End Sub


 Sub inorder(i)
   If tree(i*2)<>0 Then  inorder(i*2)
    print tree(i)& vbtab
   If tree(i*2+1)<>0 Then inorder(i*2+1)
 End Sub


 Sub preorder(i)
   print tree(i)& vbtab
   If tree(i*2)<>0 Then  preorder(i*2)
   If tree(i*2+1)<>0 Then preorder(i*2+1)
 End Sub

  Sub postorder(i)
   If tree(i*2)<>0 Then  postorder(i*2)
   If tree(i*2+1)<>0 Then postorder(i*2+1)
   print tree(i)& vbTab
 End Sub

  Sub levelorder(x)
   Dim i
   For i= 1 To UBound(tree)
      If tree(i)<>0 Then print tree(i)& vbTab
   Next
  End sub

Dim tree
'            1 2 3 4 5 6 7 8 9 1011121314151617181920212223242526
'            1 2 2 3 3 3 3 4 4 4 4 4 4 4 4
tree=Array(0,1,2,3,4,5,6,0,7,0,0,0,8,9,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
print vbCrLf & "Preorder" & vbcrlf
preorder(1)
print vbCrLf & "Inorder" & vbcrlf
inorder(1)
print vbCrLf & "Postorder" & vbcrlf
postorder(1)
print vbCrLf & "Levelorder" & vbcrlf
levelorder(1)
