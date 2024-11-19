class_name Board
extends Node2D

## The chess board
var board: Array[int]

signal board_updated

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	startingPosition()
	load_from_fen("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1")

func startingPosition() -> void:
	for i in range(0, 8):
		for j in range(0, 8):
			board.append(0)

func load_from_fen(fen: String) -> void:
	var segments := fen.split(" ")
	print(segments)
	var rows := segments[0].split("/")
	for i in range(0, 8):
		var j := 0
		for letter in rows[i]:
			var ascii: int = letter.unicode_at(0) - "0".unicode_at(0)
			if 0 <= ascii and ascii <= 9:
				for k in range(0, ascii):
					board[i*8 + j] = 0
					j += 1
				continue
			
			match letter:
				"p":
					board[i*8 + j] = Piece.Team.BLACK | Piece.Type.PAWN
				"k":
					board[i*8 + j] = Piece.Team.BLACK | Piece.Type.KING
				"q":
					board[i*8 + j] = Piece.Team.BLACK | Piece.Type.QUEEN
				"b":
					board[i*8 + j] = Piece.Team.BLACK | Piece.Type.BISHOP
				"n":
					board[i*8 + j] = Piece.Team.BLACK | Piece.Type.KNIGHT
				"r":
					board[i*8 + j] = Piece.Team.BLACK | Piece.Type.ROOK
				"P":
					board[i*8 + j] = Piece.Team.WHITE | Piece.Type.PAWN
				"K":
					board[i*8 + j] = Piece.Team.WHITE | Piece.Type.KING
				"Q":
					board[i*8 + j] = Piece.Team.WHITE | Piece.Type.QUEEN
				"B":
					board[i*8 + j] = Piece.Team.WHITE | Piece.Type.BISHOP
				"N":
					board[i*8 + j] = Piece.Team.WHITE | Piece.Type.KNIGHT
				"R":
					board[i*8 + j] = Piece.Team.WHITE | Piece.Type.ROOK
			j += 1
	board_updated.emit()
	print(board)
