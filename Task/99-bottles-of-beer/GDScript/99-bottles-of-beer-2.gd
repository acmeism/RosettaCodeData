extends Node

@export var alcoholism: int = 99

func _ready():
	# Add the lyrics as child nodes
	var padding := "" # Avoid name clashes by adding spaces
	for bottleCount in range(alcoholism, 0, -1):
		# Seperate paragraphs with blank nodes
		if bottleCount < alcoholism:
			add_lyric(padding)
		add_lyric("%s of beer on the wall" % [_formatBottles(bottleCount)])
		add_lyric("%s of beer" % [_formatBottles(bottleCount)])
		add_lyric("Take one down, pass it around" + padding)
		add_lyric("%s of beer on the wall " % [_formatBottles(bottleCount - 1)]) # Extra space for name clash avoidance
		padding += " " # Add spaces so the names don't clash

func _formatBottles(bottleCount: int) -> String:
	return "%d bottle%s" % [bottleCount, "" if bottleCount == 1 else "s"]

func add_lyric(lyric: String) -> void:
	var new_child := Node.new()
	new_child.name = lyric
	add_child(new_child)
