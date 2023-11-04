:- use_module(library(lists)).

% start_game(+RedPlayer, +BluePlayer)
start_game(RedPlayer, BluePlayer):-  
  initial_state( _, GameState),
  game_loop(GameState, RedPlayer, BluePlayer).

% game_loop(+GameState, +RedPlayer, +BluePlayer)
game_loop([Board, Turn], RedPlayer, BluePlayer):-
  game_over(Board, Winner), !,
  display_game(Board),
  display_winner(Winner).
% TODO DISPLAY WINNER HERE
game_loop([Board, Turn], RedPlayer, BluePlayer):-
  display_game(Board),
  repeat,
  read_move(Move),
  move([Board, Turn], Move, NewGameState),
  game_loop(NewGameState, RedPlayer, BluePlayer).

% game_over(+GameState, -Winner)
game_over([Board, red], Winner):-
  \+ get_pentagon(Board, 15),
  Winner is red.
game_over([Board, red], Winner):-
  get_golden_tiles(Board, [G1,G2]),
  G1 =< 24,
  G1 >= 21,
  G2 >= 21,
  G2 =< 24,
  Winner is red. 
game_over([Board, blue], Winner):-
  \+ get_pentagon(Board, 11),
  Winner is blue.
game_over([Board, Blue], Winner):-
  get_golden_tiles(Board, [G1,G2]),
  G1 =< 28, G1 > 24,
  G2 =< 28, G2 > 24,
  Winner is Blue. 

% read_move(+[X1,Y1,X2,Y2])
read_move([X1,Y1,X2,Y2]):-
  read_coordinates('Source', X1-Y1),
  read_coordinates('Dest', X2-Y2).

% read_coordinates(+Type, +X-Y)
read_coordinates(Type, X-Y):-
  format('~a coordinates (format X-Y): ', Type),
  read(X-Y).

% move(+GameState , +[X1, Y1, X2, Y2], -NewGameState)
move([Board, Turn], [X1,Y1,X2,Y2], [NewBoard,NewTurn]):-
  inside_board(Board, [X1, Y1]),
  inside_board(Board, [X2, Y2]),
  get_tile_num(Board, [X1, Y1], SourceNum),
  get_tile_num(Board, [X2, Y2], DestNum),
  valid_source(Turn, SourceNum),
  valid_destination(Turn, DestNum),
  get_max_steps(SourceNum, MaxSteps),
  valid_path(Board, [X1, Y1], [X2, Y2], MaxSteps),
  get_move_type(SourceNum, DestNum, MoveType),
  execute_move(Board, [X1,Y1,X2,Y2], NewBoard, SourceNum, DestNum, MoveType),
  get_enemy_colour(Turn, NewTurn).

% valid_source(+Colour, +SourceNum)
valid_source(red, SourceNum):-
  get_units_tens(SourceNum, Units, _),
  Units >= 1,
  Units =< 4.
valid_source(blue, SourceNum):-
  get_units_tens(SourceNum, Units, _),
  Units >= 5,
  Units =< 8.

% valid_destination(+Colour, +DestNum)
valid_destination(_, DestNum):-
  get_units_tens(DestNum, Units, _),
  Units = 0.
valid_destination(red, DestNum):-
  get_units_tens(DestNum, Units, _),
  Units >= 5,
  Units =< 8.
valid_destination(blue, DestNum):-
  get_units_tens(DestNum, Units, _),
  Units >= 1,
  Units =< 4.

% available_tile(+Board , +[X,Y], +[X1,Y1])
available_tile(Board, [X,Y], [X1,Y1]):-
  adj_tile([X,Y], [X1,Y1]),
  inside_board(Board, [X1, Y1]),
  get_tile_num(Board, [X1, Y1], TileNum),
  get_units_tens(TileNum, Units, _),
  Units = 0.

% valid_path(+Board, +Source, +Dest, +MaxSteps)
valid_path(Board, Source, Dest, MaxSteps):- valid_path(Board, Source, Dest, 0, MaxSteps).

% valid_path(+Board, +Curr, +Dest, +StepCount, +MaxSteps)
valid_path(_, Curr, Dest, StepCount, MaxSteps):-
  StepCount < MaxSteps,
  adj_tile(Curr, Dest).

valid_path(Board, Curr, Dest, StepCount, MaxSteps):-
  StepCount < MaxSteps,
  available_tile(Board, Curr, NewTile),
  StepCount1 is StepCount + 1,
  valid_path(Board, NewTile, Dest, StepCount1, MaxSteps).

replace([_|T], 0, X, [X|T]).
replace([H|T], I, X, [H|R]):- 
  I > -1, 
  NI is I-1, 
  replace(T, NI, X, R), !.
replace(L, _, _, L).

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


/*
valid_moves(+GameState, +Player, -ListOfMoves):-

value(+GameState, +Player, -Value):-

& Level 1 should return a valid random move. Level 2 should return the best one.
choose_move(+GameState, +Player, +Level, -Move):-
*/



