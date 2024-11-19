class_name Board
extends Node2D

## The chess board
var board: Array[int] = [64]

signal board_updated

var board_helper: BoardHelper

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	board_helper = BoardHelper.new()
	
	board_helper.initialize_board(board)
	board_helper.load_from_fen(board, "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1", board_updated)
