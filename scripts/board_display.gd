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

var selected_piece: int = -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup()
	update()
	GlobalBoard.board_updated.connect(update)

func on_button_press(button: ScriptButton):
	print(button.board_position)
	if (selected_piece == -1):
		selected_piece = button.board_position
		return
	else:
		GlobalBoard.move(selected_piece, button.board_position)
		selected_piece = -1
		update()
		return
	

## Setup the board and tiles
func setup() -> void:
	board_position = Vector2(
			(get_viewport_rect().size.y - 8 * board_scale) / 2, 
			(get_viewport_rect().size.y - 8 * board_scale) / 2)
	for i in range(0, 8):
		for j in range (0, 8):
			var tile := ColorRect.new()
			tile.z_index = 0
			add_child(tile)
			display_tiles.append(tile)
			
			var icon := ScriptButton.new()
			icon.board_position = i*8 + j
			icon.pressed.connect(on_button_press.bind(icon))
			icon.z_index = 1
			icon.stretch_mode = 0
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
