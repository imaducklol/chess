class_name Queen
extends Piece

func _init(piece_team: Team):
	type = Type.QUEEN
	team = piece_team

func valid_moves(board: Array) -> Array:
	return []
