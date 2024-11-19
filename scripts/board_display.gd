extends Node2D

@export var dark_tile: Color
@export var light_tile: Color
@export var board_scale: float:
	set(value):
		board_scale = value
		set_board_scale()
@export var board_position: Vector2:
	set(value):
		board_position = value
		set_board_scale()

var display_tiles: Array[ColorRect] = []
var display_board: Array[TextureButton] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(board_scale)
	print(board_position)
	for i in range(0, 8):
		for j in range (0, 8):
			var tile := ColorRect.new()
			add_child(tile)
			display_tiles.append(tile)
			
			var icon := TextureButton.new()
			#icon.texture_normal = load("res://icon.svg")

			add_child(icon)
			display_board.append(icon)
	set_board_scale()


func set_board_scale() -> void:
	print(display_board.size())
	print(display_tiles.size())
	if (display_board.size() == 0 or display_tiles.size() == 0):
		print("Skipping scaling")
		return
	for i in range(0, 8):
		for j in range(0, 8):
			display_tiles[i*8+j].set_size(Vector2(board_scale, board_scale))
			display_tiles[i*8+j].set_position(Vector2(i*board_scale, j*board_scale) + board_position)
			display_tiles[i*8+j].color = light_tile if (i*8 + i + j) % 2 == 0 else dark_tile

			#display_board[i*8+j].set_size(Vector2(board_scale, board_scale))
			#display_board[i*8+j].scale = (Vector2(board_scale, board_scale))
			#display_board[i*8+j].set_position(Vector2(i*board_scale, j*board_scale) + board_position)
			
