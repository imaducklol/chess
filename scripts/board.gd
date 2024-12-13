class_name Board
extends Node2D

## The chess board
var board: Array[Piece] = []
var turn: bool

signal board_updated

var board_helper: BoardHelper
var move_generation: MoveGeneration

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	board_helper = BoardHelper.new()
	move_generation = MoveGeneration.new()
	
	board_helper.initialize_board(board)
	#board_helper.load_from_fen(board, turn, "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1", board_updated)
	board_helper.load_from_fen(board, turn, "rnbqkbnr/pp1ppppp/8/2p5/4P3/8/PPPP1PPP/RNBQKBNR w KQkq c6 0 2", board_updated)
	#board_helper.load_from_fen(board, turn, "8/8/8/4Q3/8/8/8/8 w KQkq c6 0 2", board_updated)

func move(src: int, dest: int) -> void:
	var piece := board[src]
	if piece.type == Piece.Type.NONE:
		return;
	elif piece.type == Piece.Type.PAWN:
		# Double move
		if abs(src - dest) == 16:
			piece.just_double_moved = true
		# En passant
		#if abs(src - dest) == 1:
			#piece.has_moved = true
			#board[dest] = Piece.new()
			#board[dest + 8] = board[src]
			#board[src] = Piece.new()
			#return
	elif piece.type == Piece.Type.KING:
		# Castle kingside
		if dest - src == 3:
			board[src + 2] = board[src]
			board[dest - 2] = board[dest]
			board[src] = Piece.new()
			board[dest] = Piece.new()
		else:
			board[src - 2] = board[src]
			board[dest + 3] = board[dest]
			board[src] = Piece.new()
			board[dest] = Piece.new()
	
	piece.has_moved = true
	
	board[dest] = board[src]
	board[src] = Piece.new()
	turn = !turn

func get_moves(pos: int) -> Array[int]:
	var piece := board[pos]
	
	if not (piece.team == Piece.Team.WHITE) == turn:
		return []
	
	match piece.type:
		Piece.Type.PAWN:
			return move_generation.pawn_moves(piece, pos)
		Piece.Type.KING:
			return move_generation.king_moves(piece, pos)
		Piece.Type.QUEEN:
			return move_generation.queen_moves(piece, pos)
		Piece.Type.BISHOP:
			return move_generation.bishop_moves(piece, pos)
		Piece.Type.KNIGHT:
			return move_generation.knight_moves(piece, pos)
		Piece.Type.ROOK:
			return move_generation.rook_moves(piece, pos)
	return []

func board_eval() -> float:
	
