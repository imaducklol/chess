class_name Board
extends Node2D

## The chess board
var board: Array[Piece] = []

signal board_updated

var board_helper: BoardHelper

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	board_helper = BoardHelper.new()
	
	board_helper.initialize_board(board)
	board_helper.load_from_fen(board, "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1", board_updated)
	board_helper.load_from_fen(board, "rnbqkbnr/pp1ppppp/8/2p5/4P3/8/PPPP1PPP/RNBQKBNR w KQkq c6 0 2", board_updated)


func get_moves(pos: int) -> Array[int]:
	var piece := board[pos]
	
	match piece.type:
		Piece.Type.PAWN:
			return pawn_moves(piece, pos)
		Piece.Type.KING:
			return king_moves(piece, pos)
		Piece.Type.QUEEN:
			return queen_moves(piece, pos)
		Piece.Type.BISHOP:
			return bishop_moves(piece, pos)
		Piece.Type.KNIGHT:
			return knight_moves(piece, pos)
		Piece.Type.ROOK:
			return rook_moves(piece, pos)
	return []

func valid_position(pos: int) -> bool:
	return 0 <= pos and pos <= 63

func pawn_moves(piece: Piece, pos: int) -> Array[int]:
	var moves: Array[int]
	if piece.team == Piece.Team.WHITE:
		# Check for attackable squares
		if piece.is_enemy_of(board[pos + 7]): moves.append(pos + 7)
		if piece.is_enemy_of(board[pos + 9]): moves.append(pos + 9)
		# Forwards!
		if board[pos + 8].is_none(): moves.append(pos + 8)
		# Double!
		if board[pos + 16].is_none() and not piece.has_moved: moves.append(pos + 16)
	else:
		# Check for attackable squares
		if piece.is_enemy_of(board[pos - 7]): moves.append(pos - 7)
		if piece.is_enemy_of(board[pos - 9]): moves.append(pos - 9)
		# Forwards!
		if board[pos - 8].is_none(): moves.append(pos - 8)
		# Double!
		if board[pos - 16].is_none() and not piece.has_moved: moves.append(pos - 16)
	# En Passant - Holy Hell
	if piece.is_enemy_of(board[pos + 1]) and board[pos + 1].just_double_moved: moves.append(pos + 1)
	if piece.is_enemy_of(board[pos - 1]) and board[pos - 1].just_double_moved: moves.append(pos - 1)
	return moves

func king_moves(piece: Piece, pos: int) -> Array[int]:
	var moves: Array[int]
	# Unit circle
	if not piece.is_ally_of(board[pos + 7]): moves.append(pos + 7)
	if not piece.is_ally_of(board[pos + 8]): moves.append(pos + 8)
	if not piece.is_ally_of(board[pos + 9]): moves.append(pos + 9)
	if not piece.is_ally_of(board[pos - 1]): moves.append(pos - 1)
	if not piece.is_ally_of(board[pos + 1]): moves.append(pos + 1)
	if not piece.is_ally_of(board[pos - 7]): moves.append(pos - 7)
	if not piece.is_ally_of(board[pos - 8]): moves.append(pos - 8)
	if not piece.is_ally_of(board[pos - 9]): moves.append(pos - 9)
	# Castling?!
	if piece.has_moved: return moves
	if not board[pos - 2].has_moved and board[pos - 2].type == Piece.Type.ROOK:
		moves.append(pos - 2)
	if not board[pos + 2].has_moved and board[pos + 2].type == Piece.Type.ROOK:
		moves.append(pos + 2)
	return moves

func straight_moves(piece: Piece, pos: int) -> Array[int]:
	var moves: Array[int]
	for i in range(-7, 8):
		if valid_position(pos + 8*i) and not piece.is_ally_of(board[pos + 8*i]): moves.append(pos + 8*i)
		if valid_position(pos + i) and not piece.is_ally_of(board[pos + i]):     moves.append(pos + i)
	return moves

func diagonal_moves(piece: Piece, pos: int) -> Array[int]:
	var moves: Array[int]
	return moves

func queen_moves(piece: Piece, pos: int) -> Array[int]:
	var moves: Array[int]
	return moves


func bishop_moves(piece: Piece, pos: int) -> Array[int]:
	var moves: Array[int]
	return moves


func knight_moves(piece: Piece, pos: int) -> Array[int]:
	var moves: Array[int]
	return moves


func rook_moves(piece: Piece, pos: int) -> Array[int]:
	var moves: Array[int]
	return moves
