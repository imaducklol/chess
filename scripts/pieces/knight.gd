class_name Knight
extends Piece

func _init(piece_team: Team):
	type = Type.KNIGHT
	team = piece_team

func valid_moves(board: Array) -> Array:
	return []
