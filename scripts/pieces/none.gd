class_name Rook
extends Piece

func _init(piece_team: Team):
	type = Type.ROOK
	team = piece_team

func valid_moves(board: Array) -> Array:
	return []
