class_name BoardHelper

func initialize_board(board: Array[int]) -> void:
	for i in range(0, 8):
		for j in range(0, 8):
			board.append(0)

func load_from_fen(board: Array[int], fen: String, board_updated: Signal) -> void:
	var segments := fen.split(" ")
	var rows := segments[0].split("/")
	for i in range(0, 8):
		var j := 0
		for letter in rows[i]:
			var ascii: int = letter.unicode_at(0) - "0".unicode_at(0)
			if 0 <= ascii and ascii <= 9:
				for k in range(0, ascii):
					board[i*8 + j] = 0
					j += 1
				continue
			
			match letter:
				"p":
					board[i*8 + j] = Piece.Team.BLACK | Piece.Type.PAWN
				"k":
					board[i*8 + j] = Piece.Team.BLACK | Piece.Type.KING
				"q":
					board[i*8 + j] = Piece.Team.BLACK | Piece.Type.QUEEN
				"b":
					board[i*8 + j] = Piece.Team.BLACK | Piece.Type.BISHOP
				"n":
					board[i*8 + j] = Piece.Team.BLACK | Piece.Type.KNIGHT
				"r":
					board[i*8 + j] = Piece.Team.BLACK | Piece.Type.ROOK
				"P":
					board[i*8 + j] = Piece.Team.WHITE | Piece.Type.PAWN
				"K":
					board[i*8 + j] = Piece.Team.WHITE | Piece.Type.KING
				"Q":
					board[i*8 + j] = Piece.Team.WHITE | Piece.Type.QUEEN
				"B":
					board[i*8 + j] = Piece.Team.WHITE | Piece.Type.BISHOP
				"N":
					board[i*8 + j] = Piece.Team.WHITE | Piece.Type.KNIGHT
				"R":
					board[i*8 + j] = Piece.Team.WHITE | Piece.Type.ROOK
			j += 1
	board_updated.emit()
