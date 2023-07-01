using System.Collections.Generic;
using System.Linq;

void Main()
{
	List<string> blocks =
	new List<string>() { "bo", "xk", "dq", "cp", "na", "gt", "re", "tg", "qd", "fs",
		"jw", "hu", "vi", "an", "ob", "er", "fs", "ly", "pc", "zm" };
	List<string> words = new List<string>() {
		"A", "BARK", "BOOK", "TREAT", "COMMON", "SQUAD", "CONFUSE"};
	
	var solver = new ABC(blocks);
	
	foreach( var word in words)
	{
		Console.WriteLine("{0} :{1}", word, solver.CanMake(word));
	}
}

class ABC
{
	readonly Dictionary<char, List<int>> _blockDict = new Dictionary<char, List<int>>();
	bool[] _used;
	int _nextBlock;

	readonly List<string> _blocks;

	private void AddBlockChar(char c)
	{
		if (!_blockDict.ContainsKey(c))
		{
			_blockDict[c] = new List<int>();
		}
		_blockDict[c].Add(_nextBlock);
	}

	private void AddBlock(string block)
	{
		AddBlockChar(block[0]);
		AddBlockChar(block[1]);
		_nextBlock++;
	}

	public ABC(List<string> blocks)
	{
		_blocks = blocks;
		foreach (var block in blocks)
		{
			AddBlock(block);
		}
	}

	public bool CanMake(string word)
	{
		word = word.ToLower();
		if (word.Length > _blockDict.Count)
		{
			return false;
		}
		_used = new bool[_blocks.Count];
		return TryMake(word);
	}

	public bool TryMake(string word)
	{
		if (word == string.Empty)
		{
			return true;
		}
		var blocks = _blockDict[word[0]].Where(b => !_used[b]);
		foreach (var block in blocks)
		{
			_used[block] = true;
			if (TryMake(word.Substring(1)))
			{
				return true;
			}
			_used[block] = false;
		}
		return false;
	}
}
