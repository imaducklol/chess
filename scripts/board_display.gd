extends Node2D

@export var dark_tile: Color
@export var light_tile: Color
@export var board_scale := 70.0:
	set(value):
		board_scale = value
		update()
@export var button_scale: float:
	set(value):
		button_scale = value
		update()
#@export var board_position := Vector2(50, 45):
	#set(value):
		#board_position = value
		#update()
var board_position: Vector2
@export var image_directory := "res://icons/":
	set(value):
		image_directory = value
		update()

var display_tiles: Array[ColorRect] = []
var display_board: Array[TextureButton] = []
var highlighted:   Array[ColorRect] = []

var selected_piece: int = -1
var selected_piece_moves: Array[int]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup()
	update()
	GlobalBoard.board_updated.connect(update)

func on_button_press(button: ScriptButton) -> void:
	var pos := button.board_position
	# First selection
	if (selected_piece == -1):
		# Don't select a none piece
		if (GlobalBoard.board[pos].type == Piece.Type.NONE):
			return
		selected_piece = pos
		selected_piece_moves = GlobalBoard.get_moves(pos)
		#highlight(pos)
		for h_pos: int in selected_piece_moves:
			highlight(h_pos)
		for texture_b in display_board:
			texture_b.move_to_front()
		return
	# Second selection
	else:
		if pos in selected_piece_moves:
			GlobalBoard.move(selected_piece, pos)
		selected_piece = -1
		selected_piece_moves.clear()
		for tile in highlighted:
			tile.queue_free()
		highlighted.clear()
		update()
		return
	
func highlight(pos: int) -> void:
	var x := pos % 8
	@warning_ignore("integer_division")
	var y := pos / 8
	
	var tile := ColorRect.new()
	tile.z_index = 0
	tile.set_size(Vector2(board_scale, board_scale))
	tile.set_position(Vector2(x*board_scale, y*board_scale) + board_position)
	tile.color = Color(255, 0, 0, .5)
	add_child(tile)
	highlighted.append(tile)
	

## Setup the board and tiles
func setup() -> void:
	board_position = Vector2(
			(get_viewport_rect().size.y - 8 * board_scale) / 2, 
			(get_viewport_rect().size.y - 8 * board_scale) / 2)
	for i in range(0, 8):
		for j in range (0, 8):
			var tile := ColorRect.new()
			tile.z_index = -1
			add_child(tile)
			display_tiles.append(tile)
			
			var icon := ScriptButton.new()
			icon.board_position = i*8 + j
			icon.pressed.connect(on_button_press.bind(icon))
			icon.z_index = 1
			icon.stretch_mode = TextureButton.STRETCH_SCALE
			icon.ignore_texture_size = true
			add_child(icon)
			display_board.append(icon)

## Update the board based on all of its variables
## TODO: Make this multiple functions
func update() -> void:
	board_position = Vector2(
			(get_viewport_rect().size.y - 8 * board_scale) / 2, 
			(get_viewport_rect().size.x - 8 * board_scale) / 2)
	# Skip if either are empty to avoid bad accesses
	if (display_board.size() == 0 or display_tiles.size() == 0):
		return
		
	# Loop and update baby
	for i in range(0, 8):
		for j in range(0, 8):
			var rotated_i := j
			var rotated_j := i
			
			var tile: ColorRect = display_tiles[i*8 + j]
			tile.set_size(Vector2(board_scale, board_scale))
			tile.set_position(Vector2(rotated_i*board_scale, rotated_j*board_scale) + board_position)
			tile.color = light_tile if (i + j) % 2 == 0 else dark_tile

			var button: TextureButton = display_board[i*8 + j]
			button.size = (Vector2(board_scale, board_scale))
			button.set_position(Vector2(rotated_i*board_scale, rotated_j*board_scale) + board_position)
			
			var piece := GlobalBoard.board[i*8 + j]
			var file_string: String = ""
			var icon: Texture2D
			match piece.team:
				Piece.Team.WHITE:
					file_string += "w"
				Piece.Team.BLACK:
					file_string += "b"
			match piece.type:
				Piece.Type.PAWN:
					file_string += "P"
				Piece.Type.KING:
					file_string += "K"
				Piece.Type.QUEEN:
					file_string += "Q"
				Piece.Type.BISHOP:
					file_string += "B"
				Piece.Type.KNIGHT:
					file_string += "N"
				Piece.Type.ROOK:
					file_string += "R"
				_:
					icon = null
					button.texture_normal = icon
					continue
			icon = load(image_directory+file_string+".svg")
			button.texture_normal = icon
