extends Control

var board: Board
var board_helper: BoardHelper
var move_generation: MoveGeneration
var minimax: Minimax

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	board = Board.new()
	board_helper = BoardHelper.new()
	move_generation = MoveGeneration.new(board.main_board)
	minimax = Minimax.new()
	
	board_helper.initialize_board(board.main_board)
	board_helper.load_from_fen(board.main_board, board.turn, "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1")
	
	#print(minimax.get_possible_moves(board.main_board, Piece.Team.BLACK).size())

	for i in range(1, 20):
		# w/o pruning
		board_helper.load_from_fen(board.main_board, board.turn, "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1")
		var starttime := Time.get_ticks_usec()
		minimax.best_move(board.main_board, i, Piece.Team.WHITE, false)
		var stoptime := Time.get_ticks_usec() - starttime
		var wo_runtimes = minimax.runtimes
		minimax.runtimes = 0
		
		# w/ pruning
		board_helper.load_from_fen(board.main_board, board.turn, "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1")
		var prune_starttime = Time.get_ticks_usec()
		minimax.best_move(board.main_board, i, Piece.Team.WHITE, true)
		var prune_stoptime = Time.get_ticks_usec() - prune_starttime
		var w_runtimes = minimax.runtimes
		minimax.runtimes = 0
		
		print("Depth: ", i, "\tMinimax (us): ", stoptime, " ", wo_runtimes, " \tWith Pruning: ", prune_stoptime, " ", w_runtimes)
