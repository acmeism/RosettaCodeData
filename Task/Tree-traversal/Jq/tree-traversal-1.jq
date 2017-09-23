def preorder:
  if length == 0 then empty
  else .[0], (.[1]|preorder), (.[2]|preorder)
  end;

def inorder:
  if length == 0 then empty
  else (.[1]|inorder), .[0] , (.[2]|inorder)
  end;

def postorder:
  if length == 0 then empty
  else (.[1] | postorder), (.[2]|postorder), .[0]
  end;

# Helper functions for levelorder:
  # Produce a stream of the first elements
  def heads: map( .[0] | select(. != null)) | .[];

# Produce a stream of the left/right branches:
  def tails:
    if length == 0 then empty
    else [map ( .[1], .[2] ) | .[] | select( . != null)]
    end;

def levelorder: [.] | recurse( tails ) | heads;
