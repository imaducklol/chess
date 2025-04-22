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
		if (GlobalBoard.main_board[pos] == Piece.State.NONE):
			return
		selected_piece_moves = GlobalBoard.get_moves(GlobalBoard.main_board, pos, GlobalBoard.turn)
		if selected_piece_moves.size() == 0:
			return
		selected_piece = pos
		highlight(pos)
		for h_pos: int in selected_piece_moves:
			highlight(h_pos)
		for texture_b in display_board:
			texture_b.move_to_front()
		return
	# Second selection
	else:
		if pos in selected_piece_moves:
			GlobalBoard.real_move(GlobalBoard.main_board, selected_piece, pos)
			clear_highlight_selection()
			GlobalBoard.minimax.run(Piece.State.WHITE & 0, Minimax.mode.PRUNED, 5)
			update()
		else:
			clear_highlight_selection()
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
	
func clear_highlight_selection():
	selected_piece = -1
	selected_piece_moves.clear()
	for tile in highlighted:
		tile.queue_free()
	highlighted.clear()
	update()

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
			
			var piece := GlobalBoard.main_board[i*8 + j]
			var file_string: String = ""
			var icon: Texture2D
			if piece & 0b1000 == Piece.State.WHITE:
				file_string += "w"
			else:
				file_string += "b"
			match abs(piece) & 0b111:
				Piece.State.PAWN:
					file_string += "P"
				Piece.State.KING:
					file_string += "K"
				Piece.State.QUEEN:
					file_string += "Q"
				Piece.State.BISHOP:
					file_string += "B"
				Piece.State.KNIGHT:
					file_string += "N"
				Piece.State.ROOK:
					file_string += "R"
				_:
					icon = null
					button.texture_normal = icon
					continue
			icon = load(image_directory+file_string+".svg")
			button.texture_normal = icon
