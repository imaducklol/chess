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


func get_moves(position: int) -> Array[int]:
	var piece := board[position]
	
	match piece.type:
		Piece.Type.PAWN:
			return pawn_moves(piece, position)
		Piece.Type.KING:
			return king_moves(piece, position)
		Piece.Type.QUEEN:
			return queen_moves(piece, position)
		Piece.Type.BISHOP:
			return bishop_moves(piece, position)
		Piece.Type.KNIGHT:
			return knight_moves(piece, position)
		Piece.Type.ROOK:
			return rook_moves(piece, position)
	return []

func valid_position(pos: int) -> bool:
	return 0 <= pos and pos <= 63

func pawn_moves(piece: Piece, position: int) -> Array[int]:
	var moves: Array[int]
	if piece.team == Piece.Team.WHITE:
		# Check for attackable squares
		if piece.is_enemy_of(board[position + 7]): moves.append(position + 7)
		if piece.is_enemy_of(board[position + 9]): moves.append(position + 9)
		# Forwards!
		if board[position + 8].is_none(): moves.append(position + 8)
		# Double!
		if board[position + 16].is_none() and not piece.has_moved: moves.append(position + 16)
	else:
		# Check for attackable squares
		if piece.is_enemy_of(board[position - 7]): moves.append(position - 7)
		if piece.is_enemy_of(board[position - 9]): moves.append(position - 9)
		# Forwards!
		if board[position - 8].is_none(): moves.append(position - 8)
		# Double!
		if board[position - 16].is_none() and not piece.has_moved: moves.append(position - 16)
	# En Passant - Holy Hell
	if piece.is_enemy_of(board[position + 1]) and board[position + 1].just_double_moved: moves.append(position + 1)
	if piece.is_enemy_of(board[position - 1]) and board[position - 1].just_double_moved: moves.append(position - 1)
	return moves

func king_moves(piece: Piece, position: int) -> Array[int]:
	var moves: Array[int]
	# Unit circle
	if not piece.is_ally_of(board[position + 7]): moves.append(position + 7)
	if not piece.is_ally_of(board[position + 8]): moves.append(position + 8)
	if not piece.is_ally_of(board[position + 9]): moves.append(position + 9)
	if not piece.is_ally_of(board[position - 1]): moves.append(position - 1)
	if not piece.is_ally_of(board[position + 1]): moves.append(position + 1)
	if not piece.is_ally_of(board[position - 7]): moves.append(position - 7)
	if not piece.is_ally_of(board[position - 8]): moves.append(position - 8)
	if not piece.is_ally_of(board[position - 9]): moves.append(position - 9)
	# Castling?!
	if piece.has_moved: return moves
	if not board[position - 2].has_moved and board[position - 2].type == Piece.Type.ROOK:
		moves.append(position - 2)
	if not board[position + 2].has_moved and board[position + 2].type == Piece.Type.ROOK:
		moves.append(position + 2)
	return moves

func straight_moves(piece: Piece, position: int) -> Array[int]:
	var moves: Array[int]
	for i in range(-7, 8):
		if valid_position(position + 8*i) and not piece.is_ally_of(board[position + 8*i]): moves.append(position + 8*i)
		if valid_position(position + i) and not piece.is_ally_of(board[position + i]):     moves.append(position + i)
	return moves

func diagonal_moves(piece: Piece, position: int) -> Array[int]:
	pass

func queen_moves(piece: Piece, position: int) -> Array[int]:
	var moves: Array[int]
	return moves


func bishop_moves(piece: Piece, position: int) -> Array[int]:
	var moves: Array[int]
	return moves


func knight_moves(piece: Piece, position: int) -> Array[int]:
	var moves: Array[int]
	return moves


func rook_moves(piece: Piece, position: int) -> Array[int]:
	var moves: Array[int]
	return moves
