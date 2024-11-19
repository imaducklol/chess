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
@export var board_position := Vector2(50, 45):
	set(value):
		board_position = value
		update()
@export var image_directory := "res://icons/":
	set(value):
		image_directory = value
		update()

var display_tiles: Array[ColorRect] = []
var display_board: Array[TextureButton] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup()
	update()
	GlobalBoard.board_updated.connect(update)

## Setup the board and tiles
func setup() -> void:
	for i in range(0, 8):
		for j in range (0, 8):
			var tile := ColorRect.new()
			tile.z_index = 0
			add_child(tile)
			display_tiles.append(tile)
			
			var icon := TextureButton.new()
			icon.z_index = 1
			icon.stretch_mode = 6
			add_child(icon)
			display_board.append(icon)

## Update the board based on all of its variables
## TODO: Make this multiple functions
func update() -> void:
	# Skip if either are empty to avoid bad accesses
	if (display_board.size() == 0 or display_tiles.size() == 0):
		return
		
	# Loop and update baby
	for i in range(0, 8):
		for j in range(0, 8):
			var rotated_i := j
			var rotated_j := 8-i
			
			var tile: ColorRect = display_tiles[i*8 + j]
			tile.set_size(Vector2(board_scale, board_scale))
			tile.set_position(Vector2(rotated_i*board_scale, rotated_j*board_scale) + board_position)
			tile.color = light_tile if (i + j) % 2 == 0 else dark_tile

			var button: TextureButton = display_board[i*8 + j]
			button.set_position(Vector2(rotated_i*board_scale, rotated_j*board_scale) + board_position)
			
			var icon: Texture2D
			match GlobalBoard.board[i*8 + j]:
				Piece.Team.WHITE | Piece.Type.PAWN:
					icon = load(image_directory+"wP.svg")
				Piece.Team.WHITE | Piece.Type.KING:
					icon = load(image_directory+"wK.svg")
				Piece.Team.WHITE | Piece.Type.QUEEN:
					icon = load(image_directory+"wQ.svg")
				Piece.Team.WHITE | Piece.Type.BISHOP:
					icon = load(image_directory+"wB.svg")
				Piece.Team.WHITE | Piece.Type.KNIGHT:
					icon = load(image_directory+"wN.svg")
				Piece.Team.WHITE | Piece.Type.ROOK:
					icon = load(image_directory+"wR.svg")
				Piece.Team.BLACK | Piece.Type.PAWN:
					icon = load(image_directory+"bP.svg")
				Piece.Team.BLACK | Piece.Type.KING:
					icon = load(image_directory+"bK.svg")
				Piece.Team.BLACK | Piece.Type.QUEEN:
					icon = load(image_directory+"bQ.svg")
				Piece.Team.BLACK | Piece.Type.BISHOP:
					icon = load(image_directory+"bB.svg")
				Piece.Team.BLACK | Piece.Type.KNIGHT:
					icon = load(image_directory+"bN.svg")
				Piece.Team.BLACK | Piece.Type.ROOK:
					icon = load(image_directory+"bR.svg")
				_:
					icon = null
			
			button.texture_normal = icon
			button.scale = (Vector2(1/button_scale, 1/button_scale))
