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
					piece = Piece.State.PAWN
				"k":
					piece = Piece.State.KING
				"q":
					piece = Piece.State.QUEEN
				"b":
					piece = Piece.State.BISHOP
				"n":
					piece = Piece.State.KNIGHT
				"r":
					piece = Piece.State.ROOK
			piece |= 0 if letter == letter.to_upper() else Piece.State.WHITE
			# Has moved bit not set by default (0)
			board[i*8 + j] = piece
			j += 1
	
	match segments[1]:
		'w': GlobalBoard.turn = true
		'b': GlobalBoard.turn = false
		_: printerr("Error in loading fen: Character `", segments[1], "` not recognized as a team")
	
