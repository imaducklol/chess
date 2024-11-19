class_name Board

## The chess board
var board = [8][8]


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func startingPosition() -> void:
	var white_count := 0
	var black_count := 0
	var template := [
		[1, 2, 3, 4, 5, 3, 2, 1,],
		[6, 6, 6, 6, 6, 6, 6, 6,],
		[0, 0, 0, 0, 0, 0, 0, 0,],
		[0, 0, 0, 0, 0, 0, 0, 0,],
		[0, 0, 0, 0, 0, 0, 0, 0,],
		[0, 0, 0, 0, 0, 0, 0, 0,],
		[6, 6, 6, 6, 6, 6, 6, 6,],
		[1, 2, 3, 4, 5, 3, 2, 1,],
	]
	
	for i in range(0, 8):
		for j in range(0, 8):
			match template[i][j]:
				0:
					board[i][j] = new 
				
