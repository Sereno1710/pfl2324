:- use_module(library(lists)).

% start_game(+RedType, +BlueType)
% starts the game and creates a game loop.
start_game(RedType, BlueType):-  
  initial_state( _, GameState),
  game_loop(GameState, RedType, BlueType).

% game_loop(+GameState, +RedType, +BlueType)
% until one of the win conditions is verified, keeps the game in loop.
game_loop([Board, Turn], RedType, BlueType):-
  game_over([Board, Turn], Winner), !,
  display_game(Board),
  get_player_type(Winner, RedType, BlueType, WinnerType),
  display_winner(Winner, WinnerType).
game_loop([Board, Turn], RedType, BlueType):-
  display_game(Board),
  repeat,
  read_move(Move),
  move([Board, Turn], Move, NewGameState),
  game_loop(NewGameState, RedType, BlueType).

% validate_move(+GameState, +Move, +Source, +Dest , +MoveType)
% verifies if the move is valid.
validate_move([Board,Turn],[X1,Y1,X2,Y2],SourceNum,DestNum,MoveType):-
  valid_source([Board, Turn], [X1,Y1], SourceNum),
  valid_destination([Board, Turn], [X2,Y2], DestNum), 
  get_max_steps(SourceNum, MaxSteps),
  valid_path(Board, [X1, Y1], [X2, Y2], MaxSteps),
  get_move_type(SourceNum, DestNum, MoveType).


% move(+GameState , +[X1, Y1, X2, Y2], -NewGameState)
% if the move is valid, it is executed, modifying the board and changing turn.
move([Board, Turn], [X1,Y1,X2,Y2], NewGameState):-
  validate_move([Board, Turn], [X1,Y1,X2,Y2], SourceNum,DestNum, MoveType),
  execute_move(Board, [X1,Y1,X2,Y2], NewBoard, SourceNum, DestNum, MoveType),
  get_enemy_colour(Turn, NewTurn),
  NewGameState = [NewBoard, NewTurn].

% game_over(+GameState, -Winner)
% verifies all possible win conditions, if a players pentagon still exists or if a full turn has passed and there are two pieces of the same colour in the golden tiles.
game_over([Board, blue], red):-
  \+ find_tile_num(Board, 15).
game_over([Board, red], blue):-
  \+ find_tile_num(Board, 11).
game_over([Board, red], red):-
  get_all_gold_tiles(Board, GoldTiles),
  check_gold_tiles(GoldTiles, red).
game_over([Board, blue], blue):-
  get_all_gold_tiles(Board, GoldTiles),
  check_gold_tiles(GoldTiles, blue).

% get_all_gold_tiles(+Board, -GoldTiles)
% obtains the golden tiles of the board.
get_all_gold_tiles([], []).
get_all_gold_tiles([Head|Tail], GoldTiles):-
  get_row_gold_tiles(Head, Result),
  get_all_gold_tiles(Tail, TailResult),
  append(Result, TailResult, GoldTiles).


% get_row_gold_tiles(+Row, -GoldTiles)
% searches the golden tiles in each row.
get_row_gold_tiles([], []).
get_row_gold_tiles([Head|Tail], Result):-
  Head >= 20,
  get_row_gold_tiles(Tail, TailResult),
  append([Head], TailResult, Result).
get_row_gold_tiles([Head|Tail], Result):-
  Head < 20,
  get_row_gold_tiles(Tail, Result).

% check_gold_tiles(+GoldTiles, +Turn)
% checks if there are units in each golden tile.
check_gold_tiles([], _).
check_gold_tiles([Head | Tail], red):-
  Head >= 21,
  Head =< 24,
  check_gold_tiles(Tail, red).
check_gold_tiles([Head | Tail], blue):-
  Head >= 25,
  Head =< 28,
  check_gold_tiles(Tail, blue).


% read_move(+[X1,Y1,X2,Y2])
% reads user input of coordinates for the move.
read_move([X1,Y1,X2,Y2]):-
  read_coordinates('Source', X1-Y1),
  read_coordinates('Dest', X2-Y2).

% read_coordinates(+Type, +X-Y)
% reads user input for one coordinates
read_coordinates(Type, X-Y):-
  format('~a coordinates (format X-Y): ', Type),
  read(X-Y).

% valid_source(+GameState, SourceCoords, -SourceNum)
% verifies if source coordinate is valid.
valid_source([Board, red], [X1, Y1], SourceNum):-
  inside_board(Board, [X1, Y1]),
  get_tile_num(Board, [X1, Y1], SourceNum),
  get_units_tens(SourceNum, Units, _),
  Units >= 1,
  Units =< 4.
valid_source([Board, blue], [X1, Y1], SourceNum):-
  inside_board(Board, [X1, Y1]),
  get_tile_num(Board, [X1, Y1], SourceNum),
  get_units_tens(SourceNum, Units, _),
  Units >= 5,
  Units =< 8.

% valid_destination(+GameState, DestCoords, -SourceNum)
% verifies if destination coordinate is valid.
valid_destination([Board, _], [X2, Y2], DestNum):-
  inside_board(Board, [X2, Y2]),
  get_tile_num(Board, [X2, Y2], DestNum),
  get_units_tens(DestNum, Units, _),
  Units = 0.
valid_destination([Board, red], [X2, Y2], DestNum):-
  inside_board(Board, [X2, Y2]),
  get_tile_num(Board, [X2, Y2], DestNum),
  get_units_tens(DestNum, Units, _),
  Units >= 5,
  Units =< 8.
valid_destination([Board, blue], [X2, Y2], DestNum):-
  inside_board(Board, [X2, Y2]),
  get_tile_num(Board, [X2, Y2], DestNum),
  get_units_tens(DestNum, Units, _),
  Units >= 1,
  Units =< 4.

% get_max_steps(+TileNum, -MaxSteps)
% obtains the maximum amount of tiles that a piece can travel.
get_max_steps(TileNum, MaxSteps):-
  get_units_tens(TileNum, Units, _),
  get_piece(Units, Piece, _, _),
  get_piece_max_steps(Piece, MaxSteps).

% get_move_type(+SourceNum, +DestNum, -MoveType)
% checks what type of move will be realized, as well as if is possible at all in case of combat happening.
get_move_type(_, DestNum, 1):-
  get_units_tens(DestNum, DestUnits, _),
  DestUnits = 0.
get_move_type(SourceNum, DestNum, MoveType):-
  get_units_tens(SourceNum, SourceUnits, _),
  get_units_tens(DestNum, DestUnits, _),
  get_piece(SourceUnits, SourcePiece, _, _),
  get_piece(DestUnits, DestPiece, _, _),
  combat_outcome(SourcePiece, DestPiece, MoveType).

% inside_board(+Board, +[X1,Y1])
% checks that coordinates are within the board.
inside_board(Board, [X1, Y1]):-
  board_size(Board, [SizeX, SizeY]),
  X1 >= 0,
  X1 < SizeX,
  Y1 >= 0,
  Y1 < SizeY.

% adj_tile(+[X,Y], -[X1,Y1]) 
% calculates all adjacent tiles from a specific tile
adj_tile([X,Y], [X1,Y]):- 
  X1 is X+2.
adj_tile([X,Y], [X1,Y]):- 
  X1 is X-2.
adj_tile([X,Y], [X1,Y1]):- 
  X1 is X+1,
  Y1 is Y+1.
adj_tile([X,Y], [X1,Y1]):- 
  X1 is X+1,
  Y1 is Y-1.
adj_tile([X,Y], [X1,Y1]):- 
  X1 is X-1,
  Y1 is Y+1.
adj_tile([X,Y], [X1,Y1]) :- 
  X1 is X-1,
  Y1 is Y-1.

% available_tile(+Board , +[X,Y], +[X1,Y1])
% from all the adjacent tiles, sees which ones are available.
available_tile(Board, [X,Y], [X1,Y1]):-
  adj_tile([X,Y], [X1,Y1]),
  inside_board(Board, [X1, Y1]),
  get_tile_num(Board, [X1, Y1], TileNum),
  get_units_tens(TileNum, Units, _),
  Units = 0.

% valid_path(+Board, +Source, +Dest, +MaxSteps)
% searches for a possible path for the move, if it does not exist, move will not be possible.
valid_path(Board, Source, Dest, MaxSteps):- valid_path(Board, Source, Dest, 0, MaxSteps).
valid_path(_, Curr, Dest, StepCount, MaxSteps):-
  StepCount < MaxSteps,
  adj_tile(Curr, Dest).
valid_path(Board, Curr, Dest, StepCount, MaxSteps):-
  StepCount < MaxSteps,
  available_tile(Board, Curr, NewTile),
  StepCount1 is StepCount + 1,
  valid_path(Board, NewTile, Dest, StepCount1, MaxSteps).

% execute_move(+Board, +Move, -NewBoard, +SourceNum, +DestNum. +MoveType)
% executes the move changing the board.
execute_move(Board, [X1,Y1,X2,Y2], NewBoard, SourceNum, DestNum, 1):-
  NewSourceNum is (SourceNum // 10) * 10,
  nth0(Y1, Board, Row0),
  replace(Row0, X1, NewSourceNum, NewRow0),
  replace(Board, Y1, NewRow0, NewBoard0),
  NewDestNum is ((DestNum // 10) * 10) + (SourceNum rem 10),
  nth0(Y2, NewBoard0, Row),
  replace(Row, X2, NewDestNum, NewRow),
  replace(NewBoard0, Y2, NewRow, NewBoard).
execute_move(Board, [X1,Y1,X2,Y2], NewBoard, SourceNum, DestNum, 2):-
  NewSourceNum is (SourceNum // 10) * 10,
  nth0(Y1, Board, Row0),
  replace(Row0, X1, NewSourceNum, NewRow0),
  replace(Board, Y1, NewRow0, NewBoard0),
  NewDestNum is (DestNum // 10) * 10,
  nth0(Y2, NewBoard0, Row),
  replace(Row, X2, NewDestNum, NewRow),
  replace(NewBoard0, Y2, NewRow, NewBoard).


