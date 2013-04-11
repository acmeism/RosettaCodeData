package
{
	public class Node
	{
		public var data:Object = null;
		public var link:Node = null;
		
		public function insert(node:Node):void
		{
			node.link = link;
			link = node;
		}
	}
}
