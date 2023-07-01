using System;
using System.Collections.Generic;
using System.Text;

  public class SNode
    {
        private List<SNode> _items;
        public string Name { get; set; }
        public IReadOnlyCollection<SNode> Items { get { return _items.AsReadOnly(); } }
        public SNode()
        {
            this._items = new List<SNode>();
        }
        public SNode(string name):this()
        {
            this.Name=name;
        }
        public void AddNode(SNode node)
        {
            this._items.Add(node);
        }
    }

    public class SNodeFull : SNode
    {
        private bool _isLeaf;
        public bool IsLeaf { get => _isLeaf; }
        public SNodeFull(bool isLeaf) : base()
        {
            this._isLeaf = isLeaf;
        }

        public SNodeFull(string name, bool isLeaf) : base(name)
        {
            this._isLeaf = isLeaf;
        }

        public SNodeFull RootNode { get; set; }

        public void AddNode(SNodeFull node)
        {
            base.AddNode(node);
            node.RootNode = this;
        }
    }
