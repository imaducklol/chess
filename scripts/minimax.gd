class_name MiniMax

func run():
	var moves = get_possible_moves(GlobalBoard.main_board, Piece.Team.BLACK)
	print(moves)
	var move = moves.pick_random()
	GlobalBoard.move(GlobalBoard.main_board, move.x, move.y)

func minimax(board: Array[Piece], depth: int, is_maximizing: bool, pruning: bool, alpha: float, beta: float):
	if depth == 0:
		return board_eval(board)

	if is_maximizing:
		var max_eval = -INF
		for move in get_possible_moves(board, Piece.Team.WHITE):
			var testboard = board.duplicate()
			GlobalBoard.make_move(testboard , move.x, move.y)
			var eval = minimax(testboard , depth - 1, false, false, alpha, beta)
			max_eval = max(max_eval, eval)
			alpha = max(alpha, eval)
			if beta <= alpha:
				break
		return max_eval
	else:
		var min_eval = INF
		for move in get_possible_moves(board, Piece.Team.BLACK):
			var testboard = board.duplicate()
			GlobalBoard.make_move(testboard , move.x, move.y)
			var eval = minimax(testboard, depth - 1, true, false, alpha, beta)
			min_eval = min(min_eval, eval)
			beta = min(beta, eval)
			if beta <= alpha:
				break
		return min_eval

func best_move(board: Array[Piece], depth: int, player: Piece.Team):
	var best_move = null
	var best_value = -INF if player == Piece.Team.WHITE else INF

	for move in get_possible_moves(board, player):
		var testboard = board.duplicate()
		GlobalBoard.make_move(testboard, move, player)
		var eval = minimax(testboard, depth - 1, player == Piece.Team.BLACK, false, -INF, INF)

		if player == Piece.Team.WHITE and eval > best_value:
			best_value = eval
			best_move = move
		elif player == Piece.Team.BLACK and eval < best_value:
			best_value = eval
			best_move = move
	return best_move
	
func board_eval(board_to_eval: Array[Piece]) -> float:
	var eval := 0.0
	eval += pieces_value(board_to_eval)
	return eval
	
func pieces_value(board_to_eval: Array[Piece]) -> float:
	var value := 0.0
	for i in range(0, 64):
		var piece_value := 0.0
		var piece := board_to_eval[i]
		match piece.type:
			Piece.Type.NONE:
				continue
			Piece.Type.PAWN:
				piece_value = 1
			Piece.Type.KNIGHT:
				piece_value = 3
			Piece.Type.BISHOP:
				piece_value = 3
			Piece.Type.ROOK:
				piece_value = 5
			Piece.Type.QUEEN:
				piece_value = 9
			Piece.Type.KING:
				piece_value = 200
		
		if piece.team == Piece.Team.BLACK:
			piece_value *= -1
		
		value += piece_value
	return value
	
func get_possible_moves(board: Array[Piece], team: Piece.Team) -> Array[Vector2i]:
	var moves: Array[Vector2i] = []
	for src in range(0, 64):
		var piece := board[src]
		if piece.team == team:
			var piece_moves := GlobalBoard.get_moves(board, src)
			for move in piece_moves:
				moves.append(Vector2i(src, move))
	return moves
	