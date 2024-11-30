class_name BoardHelper

func initialize_board(board: Array[Piece]) -> void:
	for i in range(0, 8):
		for j in range(0, 8):
			board.append(Piece.new())

func load_from_fen(board: Array[Piece], turn: bool, fen: String, board_updated: Signal) -> void:
	var segments := fen.split(" ")
	var rows := segments[0].split("/")
	for i in range(0, 8):
		var j := 0
		for letter in rows[i]:
			if letter.is_valid_int():
				for k in range(0, int(letter)):
					board[i*8 + j] = Piece.new()
					j += 1
				continue
			var piece := Piece.new()
			piece.team = Piece.Team.BLACK if letter == letter.to_upper() else Piece.Team.WHITE
			match letter.to_lower():
				"p":
					piece.type = Piece.Type.PAWN
				"k":
					piece.type = Piece.Type.KING
				"q":
					piece.type = Piece.Type.QUEEN
				"b":
					piece.type = Piece.Type.BISHOP
				"n":
					piece.type = Piece.Type.KNIGHT
				"r":
					piece.type = Piece.Type.ROOK
			board[i*8 + j] = piece
			j += 1
	
	match segments[1]:
		'w': turn = true
		'b': turn = false
		_: printerr("Error in loading fen: Character `", segments[1], "` not recognized as a team")
	print(turn)
	board_updated.emit()
