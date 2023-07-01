public class DoublyLinkedList<Element>
{
	public class Entry
	{
		// Each entry owns the next entry
		public fileprivate(set) weak var prev: Entry?
		public fileprivate(set) var next: Entry?
		public let item: Element

		init(prev: Entry? = nil, next: Entry? = nil, item: Element)
		{
			self.prev = prev
			self.next = next
			self.item = item
		}
	}

	public init(){}

	public private(set) var headEntry: Entry? = nil
	public private(set) var tailEntry: Entry? = nil

	public var head: Element? { headEntry?.item }
	public var tail: Element? { tailEntry?.item }

	public func append(item: Element)
	{
		let newEntry = Entry(prev: tailEntry, item: item)
		if let tailEntry
		{
			tailEntry.next = newEntry
		}
		else
		{
			headEntry = newEntry
		}
		tailEntry = newEntry
	}

	public func prepend(item: Element)
	{
		let newEntry = Entry(next: headEntry, item: item)
		if let headEntry
		{
			headEntry.prev = newEntry
		}
		else
		{
			tailEntry = newEntry
		}
		headEntry = newEntry
	}

	public func insert(item: Element, before: Entry)
	{
		let newEntry = Entry(next: before, item: item)
		if let previous = before.prev
		{
			newEntry.prev = previous
			previous.next = newEntry
		}
		else
		{
			headEntry = newEntry
		}
		newEntry.next = before
	}

	public func insert(item: Element, after: Entry)
	{
		let newEntry = Entry(prev: after, item: item)
		if let next = after.next
		{
			newEntry.next = next
			next.prev = newEntry
		}
		else
		{
			tailEntry = newEntry
		}
		after.next = newEntry
	}

	@discardableResult public func remove(entry: Entry) -> Element
	{
		if let prevEntry = entry.prev
		{
			prevEntry.next = entry.next
		}
		else
		{
			headEntry = entry.next
		}
		if let nextEntry = entry.next
		{
			nextEntry.prev = entry.prev
		}
		else
		{
			tailEntry = entry.prev
		}
		entry.prev = nil
		entry.next = nil
		return entry.item
	}
}

extension DoublyLinkedList: CustomStringConvertible where Element: CustomStringConvertible
{
	public var description: String
	{
		var array: [Element] = []
		var currentEntry = headEntry
		while let thisEntry = currentEntry
		{
			array.append(thisEntry.item)
			currentEntry = thisEntry.next
		}
		return "[" + array.map({ $0.description }).joined(separator: ", ") + "]"
	}
}

let list = DoublyLinkedList<Int>()
for i in 0 ... 5
{
	list.append(item: i)
}
for i in 10 ... 15
{
	list.prepend(item: i)
}

if let insertPoint = list.headEntry?.next?.next
{
	list.insert(item: 99, after: insertPoint)
}
print("\(list)")
if let removePoint = list.headEntry?.next?.next?.next
{
	let item = list.remove(entry: removePoint)
}
print("\(list)")
