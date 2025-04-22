class_name BoardHelper

func initialize_board(board: Array[int]) -> void:
	for i in range(0, 8):
		for j in range(0, 8):
			board.append(0)

func load_from_fen(board: Array[int], turn: bool, fen: String) -> void:
	var segments := fen.split(" ")
	var rows := segments[0].split("/")
	for i in range(0, 8):
		var j := 0
		for letter in rows[i]:
			if letter.is_valid_int():
				for k in range(0, int(letter)):
					board[i*8 + j] = 0
					j += 1
				continue
			var piece := 0
			match letter.to_lower():
				"p":
					piece = Piece.Type.PAWN
				"k":
					piece = Piece.Type.KING
				"q":
					piece = Piece.Type.QUEEN
				"b":
					piece = Piece.Type.BISHOP
				"n":
					piece = Piece.Type.KNIGHT
				"r":
					piece = Piece.Type.ROOK
			piece *= Piece.Team.BLACK if letter == letter.to_upper() else Piece.Team.WHITE
			piece |= Piece.HasMoved.TRUE
			board[i*8 + j] = piece
			j += 1
	
	match segments[1]:
		'w': GlobalBoard.turn = true
		'b': GlobalBoard.turn = false
		_: printerr("Error in loading fen: Character `", segments[1], "` not recognized as a team")
	
