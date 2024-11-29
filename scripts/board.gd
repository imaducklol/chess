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
	#board_helper.load_from_fen(board, "rnbqkbnr/pp1ppppp/8/2p5/4P3/8/PPPP1PPP/RNBQKBNR w KQkq c6 0 2", board_updated)
	#board_helper.load_from_fen(board, "8/8/8/4Q3/8/8/8/8 w KQkq c6 0 2", board_updated)

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
			
	piece.has_moved = true
	
	board[dest] = board[src]
	board[src] = Piece.new()

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

func pos_is_enemy_of(piece: Piece, pos: int) -> bool:
	if valid_position(pos):
		return piece.is_enemy_of(board[pos])
	return false

func pos_is_ally_of(piece: Piece, pos: int) -> bool:
	if valid_position(pos):
		return piece.is_ally_of(board[pos])
	return false

func pos_is_none(pos: int) -> bool:
	if valid_position(pos):
		return board[pos].is_none()
	return false

func pawn_moves(piece: Piece, pos: int) -> Array[int]:
	var moves: Array[int]
	if piece.team == Piece.Team.WHITE:
		# Check for attackable squares
		if pos_is_enemy_of(piece, pos + 7): moves.append(pos + 7)
		if pos_is_enemy_of(piece, pos + 9): moves.append(pos + 9)
		# Forwards!
		if pos_is_none(pos + 8): moves.append(pos + 8)
		# Double!
		if pos_is_none(pos + 16) and not piece.has_moved: moves.append(pos + 16)
	else:
		# Check for attackable squares
		if pos_is_enemy_of(piece, pos - 7): moves.append(pos - 7)
		if pos_is_enemy_of(piece, pos - 9): moves.append(pos - 9)
		# Forwards!
		if pos_is_none(pos - 8): moves.append(pos - 8)
		# Double!
		if pos_is_none(pos - 16) and not piece.has_moved: moves.append(pos - 16)
	# En Passant - Holy Hell
	# Second array access is validated by the first function call
	#if pos_is_enemy_of(piece, pos + 1) and board[pos + 1].just_double_moved: moves.append(pos + 1)
	#if pos_is_enemy_of(piece, pos - 1) and board[pos - 1].just_double_moved: moves.append(pos - 1)
	return moves

func king_moves(piece: Piece, pos: int) -> Array[int]:
	var moves: Array[int]
	# Unit circle
	if not pos_is_ally_of(piece, pos + 7): moves.append(pos + 7)
	if not pos_is_ally_of(piece, pos + 8): moves.append(pos + 8)
	if not pos_is_ally_of(piece, pos + 9): moves.append(pos + 9)
	if not pos_is_ally_of(piece, pos - 1): moves.append(pos - 1)
	if not pos_is_ally_of(piece, pos + 1): moves.append(pos + 1)
	if not pos_is_ally_of(piece, pos - 7): moves.append(pos - 7)
	if not pos_is_ally_of(piece, pos - 8): moves.append(pos - 8)
	if not pos_is_ally_of(piece, pos - 9): moves.append(pos - 9)
	# Castling?!
	# Array accesses protected by piece.has_moved in most cases (won't work for other game modes)
	if piece.has_moved: return moves
	if not board[pos - 2].has_moved and board[pos - 2].type == Piece.Type.ROOK:
		moves.append(pos - 2)
	if not board[pos + 2].has_moved and board[pos + 2].type == Piece.Type.ROOK:
		moves.append(pos + 2)
	return moves

func straight_moves(piece: Piece, pos: int) -> Array[int]:
	var moves: Array[int]
	var row = pos / 8
	var column = pos % 8
	for i in range(-1, -8, -1):
		var dest = pos + 8*i
		if pos_is_none(dest) and dest % 8 == column:
			moves.append(dest)
		elif pos_is_enemy_of(piece, dest):
			moves.append(dest)
			break
		else: break
	for i in range(1, 8):
		var dest = pos + 8*i
		if pos_is_none(dest) and dest % 8 == column:
			moves.append(dest)
		elif pos_is_enemy_of(piece, dest):
			moves.append(dest)
			break
		else: break
	for i in range(-1, -8, -1):
		var dest = pos + i
		if pos_is_none(dest) and dest / 8 == row:
			moves.append(dest)
		elif pos_is_enemy_of(piece, dest):
			moves.append(dest)
			break
		else: break
	for i in range(1, 8):
		var dest = pos + i
		if pos_is_none(dest) and dest / 8 == row:
			moves.append(dest)
		elif pos_is_enemy_of(piece, dest):
			moves.append(dest)
			break
		else: break
	return moves

func diagonal_moves(piece: Piece, pos: int) -> Array[int]:
	var moves: Array[int]
	var prev:= Vector2(pos % 8, pos / 8)
	for i in range(-1, -8, -1):
		var dest = pos + 8*i + i
		if (Vector2(dest % 8, dest / 8) - prev).abs() != Vector2(1, 1):  
			break
		prev = Vector2(dest % 8, dest / 8)
		if pos_is_none(dest):
			moves.append(dest)
		elif pos_is_enemy_of(piece, dest):
			moves.append(dest)
			break
		else: break
	prev = Vector2(pos % 8, pos / 8)
	for i in range(1, 8):
		var dest = pos + 8*i + i
		if (Vector2(dest % 8, dest / 8) - prev).abs() != Vector2(1, 1):  
			break
		prev = Vector2(dest % 8, dest / 8)
		if pos_is_none(dest):
			moves.append(dest)
		elif pos_is_enemy_of(piece, dest):
			moves.append(dest)
			break
		else: break
	prev = Vector2(pos % 8, pos / 8)
	for i in range(-1, -8, -1):
		var dest = pos - 8*i + i
		if (Vector2(dest % 8, dest / 8) - prev).abs() != Vector2(1, 1):  
			break
		prev = Vector2(dest % 8, dest / 8)
		if pos_is_none(dest):
			moves.append(dest)
		elif pos_is_enemy_of(piece, dest):
			moves.append(dest)
			break
		else: break
	prev = Vector2(pos % 8, pos / 8)
	for i in range(1, 8):
		var dest = pos - 8*i + i
		if (Vector2(dest % 8, dest / 8) - prev).abs() != Vector2(1, 1):  
			break
		prev = Vector2(dest % 8, dest / 8)
		if pos_is_none(dest):
			moves.append(dest)
		elif pos_is_enemy_of(piece, dest):
			moves.append(dest)
			break
		else: break
	return moves

func queen_moves(piece: Piece, pos: int) -> Array[int]:
	var moves: Array[int]
	moves.append_array(straight_moves(piece, pos))
	moves.append_array(diagonal_moves(piece, pos))
	return moves

func bishop_moves(piece: Piece, pos: int) -> Array[int]:
	return diagonal_moves(piece, pos)

func knight_moves(piece: Piece, pos: int) -> Array[int]:
	var moves: Array[int]
	return moves

func rook_moves(piece: Piece, pos: int) -> Array[int]:
	return straight_moves(piece, pos)
