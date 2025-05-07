class_name Board
extends Node2D

## The chess board
var main_board: Array[int] = []
## True: White, False: Black
var turn: bool

signal board_updated

var board_helper: BoardHelper
var move_generation: MoveGeneration
var minimax: Minimax


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	board_helper = BoardHelper.new()
	move_generation = MoveGeneration.new(main_board)
	minimax = Minimax.new()
	
	board_helper.initialize_board(main_board)
	board_helper.load_from_fen(main_board, turn, "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1")
	#board_helper.load_from_fen(main_board, turn, "rnbqkbnr/pp1ppppp/8/2p5/4P3/8/PPPP1PPP/RNBQKBNR w KQkq c6 0 2")
	#board_helper.load_from_fen(main_board, turn, "rnbqkbnr/pp1ppppp/8/2p5/4P3/5N2/PPPP1PPP/RNBQKB1R w KQkq - 1 2")
	board_updated.emit()
	
	
func real_move(board: Array[int], src: int, dest: int) -> void:
	move(board, src, dest)
	turn = !turn

func move(board: Array[int], src: int, dest: int) -> void:
	var piece := board[src]
	if piece == Piece.State.NONE:
		return;
	#elif abs(piece) & 0b111 == Piece.Type.PAWN:
		# Double move
		#if abs(src - dest) == 16:
			#piece.just_double_moved = true
		# En passant
		#if abs(src - dest) == 1:
			#piece.has_moved = true
			#board[dest] = Piece.new()
			#board[dest + 8] = board[src]
			#board[src] = Piece.new()
			#return
	elif piece & 0b111 == Piece.State.KING:
		# Castle kingside
		if dest - src == 3:
			board[src + 2] = board[src]
			board[dest - 2] = board[dest]
			board[src] = 0
			board[dest] = 0
		else:
			board[src - 2] = board[src]
			board[dest + 3] = board[dest]
			board[src] = 0
			board[dest] = 0
	
	# set the MOVED bit
	piece |= Piece.State.MOVED
	
	board[dest] = board[src]
	board[src] = 0
	

func get_moves(board: Array[int], pos: int, turn: bool) -> Array[int]:
	var piece := board[pos]
	
	# return no moves if the piece given does not match the turn
	if not (piece & 0b01000 == Piece.State.WHITE) == turn:
		return []
	
	# mask only the piece bits (last three), and return move for that piece
	match piece & 0b111:
		Piece.State.PAWN:
			return move_generation.pawn_moves(piece, pos)
		Piece.State.KING:
			return move_generation.king_moves(piece, pos)
		Piece.State.QUEEN:
			return move_generation.queen_moves(piece, pos)
		Piece.State.BISHOP:
			return move_generation.bishop_moves(piece, pos)
		Piece.State.KNIGHT:
			return move_generation.knight_moves(piece, pos)
		Piece.State.ROOK:
			return move_generation.rook_moves(piece, pos)
	return []
