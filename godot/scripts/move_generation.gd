class_name MoveGeneration

var board: Array[int]

func _init(init_board: Array[int]) -> void:
	board = init_board

func _valid_position(pos: int) -> bool:
	return 0 <= pos and pos <= 63

func _pos_is_ally_of(piece: int, pos: int) -> bool:
	if _valid_position(pos):
		return sign(piece) == sign(board[piece])
	return false

func _pos_is_enemy_of(piece: int, pos: int) -> bool:
	if _valid_position(pos):
		if board[pos] == 0 || piece == 0: return false
		return sign(piece) != sign(board[piece])
	return false

func _pos_is_none(pos: int) -> bool:
	if _valid_position(pos):
		return board[pos] == 0
	return false

func pawn_moves(piece: int, pos: int) -> Array[int]:
	var moves: Array[int]
	if sign(piece) == Piece.Team.WHITE:
		# Check for attackable squares
		if _pos_is_enemy_of(piece, pos + 7): moves.append(pos + 7)
		if _pos_is_enemy_of(piece, pos + 9): moves.append(pos + 9)
		# Forwards!
		if _pos_is_none(pos + 8): moves.append(pos + 8)
		# Double!
		if _pos_is_none(pos + 16) and !(piece & Piece.HasMoved.TRUE): moves.append(pos + 16)
	else:
		# Check for attackable squares
		if _pos_is_enemy_of(piece, pos - 7): moves.append(pos - 7)
		if _pos_is_enemy_of(piece, pos - 9): moves.append(pos - 9)
		# Forwards!
		if _pos_is_none(pos - 8): moves.append(pos - 8)
		# Double!
		if _pos_is_none(pos - 16) and !(piece & Piece.HasMoved.TRUE): moves.append(pos - 16)
	# En Passant - Holy Hell
	# Second array access is validated by the first function call
	#if pos_is_enemy_of(piece, pos + 1) and board[pos + 1].just_double_moved: moves.append(pos + 1)
	#if pos_is_enemy_of(piece, pos - 1) and board[pos - 1].just_double_moved: moves.append(pos - 1)
	return moves

func king_moves(piece: int, pos: int) -> Array[int]:
	var moves: Array[int]
	# Unit circle
	@warning_ignore("integer_division")
	var vec_pos := Vector2(pos % 8, pos / 8)
	for diff: int in [1, 7, 8, 9]:
		for mult: int in [-1, 1]:
			var dest := pos + diff * mult
			@warning_ignore("integer_division")
			var vec_dest := Vector2(dest % 8, dest / 8)
			if abs(vec_dest.x - vec_pos.x) > 1 or abs(vec_dest.y - vec_pos.y) > 1 or not _valid_position(dest):
				continue
			if not _pos_is_ally_of(piece, dest): moves.append(dest)

	# Castling?!
	# Array accesses protected by piece.has_moved in most cases (won't work for other game modes)
	if piece & Piece.HasMoved.TRUE: return moves
	if not board[pos - 4] & Piece.HasMoved.TRUE and board[pos - 4] == Piece.Type.ROOK:
		if board[pos - 1] == 0 and board[pos - 2] == 0 and board[pos - 3] == 0:
			moves.append(pos - 4)
	if not board[pos + 3] & Piece.HasMoved.TRUE and board[pos + 3] == Piece.Type.ROOK:
		if board[pos + 1] == 0 and board[pos + 2] == 0:
			moves.append(pos + 3)
	return moves

func _straight_moves(piece: int, pos: int) -> Array[int]:
	var moves: Array[int]
	@warning_ignore("integer_division")
	var row: int = pos / 8
	var column: int = pos % 8
	for i in range(-1, -8, -1):
		var dest := pos + 8*i
		if _pos_is_none(dest) and dest % 8 == column:
			moves.append(dest)
		elif _pos_is_enemy_of(piece, dest):
			moves.append(dest)
			break
		else: break
	for i in range(1, 8):
		var dest := pos + 8*i
		if _pos_is_none(dest) and dest % 8 == column:
			moves.append(dest)
		elif _pos_is_enemy_of(piece, dest):
			moves.append(dest)
			break
		else: break
	for i in range(-1, -8, -1):
		var dest := pos + i
		@warning_ignore("integer_division")
		if _pos_is_none(dest) and dest / 8 == row:
			moves.append(dest)
		elif _pos_is_enemy_of(piece, dest):
			moves.append(dest)
			break
		else: break
	for i in range(1, 8):
		var dest := pos + i
		@warning_ignore("integer_division")
		if _pos_is_none(dest) and dest / 8 == row:
			moves.append(dest)
		elif _pos_is_enemy_of(piece, dest):
			moves.append(dest)
			break
		else: break
	return moves

func _diagonal_moves(piece: int, pos: int) -> Array[int]:
	var moves: Array[int]
	@warning_ignore("integer_division")
	var prev:= Vector2(pos % 8, pos / 8)
	for i in range(-1, -8, -1):
		var dest := pos + 8*i + i
		@warning_ignore("integer_division")
		if (Vector2(dest % 8, dest / 8) - prev).abs() != Vector2(1, 1):  
			break
		@warning_ignore("integer_division")
		prev = Vector2(dest % 8, dest / 8)
		if _pos_is_none(dest):
			moves.append(dest)
		elif _pos_is_enemy_of(piece, dest):
			moves.append(dest)
			break
		else: break
	@warning_ignore("integer_division")
	prev = Vector2(pos % 8, pos / 8)
	for i in range(1, 8):
		var dest := pos + 8*i + i
		@warning_ignore("integer_division")
		if (Vector2(dest % 8, dest / 8) - prev).abs() != Vector2(1, 1):  
			break
		@warning_ignore("integer_division")
		prev = Vector2(dest % 8, dest / 8)
		if _pos_is_none(dest):
			moves.append(dest)
		elif _pos_is_enemy_of(piece, dest):
			moves.append(dest)
			break
		else: break
	@warning_ignore("integer_division")
	prev = Vector2(pos % 8, pos / 8)
	for i in range(-1, -8, -1):
		var dest := pos - 8*i + i
		@warning_ignore("integer_division")
		if (Vector2(dest % 8, dest / 8) - prev).abs() != Vector2(1, 1):  
			break
		@warning_ignore("integer_division")
		prev = Vector2(dest % 8, dest / 8)
		if _pos_is_none(dest):
			moves.append(dest)
		elif _pos_is_enemy_of(piece, dest):
			moves.append(dest)
			break
		else: break
	@warning_ignore("integer_division")
	prev = Vector2(pos % 8, pos / 8)
	for i in range(1, 8):
		var dest := pos - 8*i + i
		@warning_ignore("integer_division")
		if (Vector2(dest % 8, dest / 8) - prev).abs() != Vector2(1, 1):  
			break
		@warning_ignore("integer_division")
		prev = Vector2(dest % 8, dest / 8)
		if _pos_is_none(dest):
			moves.append(dest)
		elif _pos_is_enemy_of(piece, dest):
			moves.append(dest)
			break
		else: break
	return moves

func queen_moves(piece: int, pos: int) -> Array[int]:
	var moves: Array[int]
	moves.append_array(_straight_moves(piece, pos))
	moves.append_array(_diagonal_moves(piece, pos))
	return moves

func bishop_moves(piece: int, pos: int) -> Array[int]:
	return _diagonal_moves(piece, pos)

func knight_moves(piece: int, pos: int) -> Array[int]:
	var moves: Array[int]
	for diff: int in [-17, -15, -10, -6, 6, 10, 15, 17]:
		var dest := pos + diff
		@warning_ignore("integer_division")
		if abs(dest % 8 - pos % 8) > 2 or abs(dest / 8 - pos / 8) > 2:
			continue 
		if _valid_position(dest) and not _pos_is_ally_of(piece, dest): moves.append(dest) 
	return moves

func rook_moves(piece: int, pos: int) -> Array[int]:
	return _straight_moves(piece, pos)
