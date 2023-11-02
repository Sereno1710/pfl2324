% start_game(+RedPlayer, +BluePlayer)
start_game(RedPlayer, BluePlayer):-  
  initial_state( _, GameState),
  game_loop(GameState, RedPlayer, BluePlayer).

% game_loop(+GameState, +RedPlayer, +BluePlayer)
game_loop([Board, Turn], RedPlayer, BluePlayer):-
  game_over(Board, Winner), !,
  display_game(Board). 
% TODO DISPLAY WINNER HERE
game_loop([Board, Turn], RedPlayer, BluePlayer):-
  display_game(Board),
  repeat,
  read_move(Move),
  move([Board, Turn], Move, NewGameState).

% game_over(+GameState, -Winner).
game_over(amogus, sus).

read_move([X1,Y1,X2,Y2]):-
  read_coordinates('Source', X1-Y1),
  read_coordinates('Destination', X2-Y2).

read_coordinates(Type, X-Y):-
  repeat,
  format('~a coordinates (format X-Y): ', Type),
  read(X-Y).

move(GameState, [X1,Y1,X2,Y2], NewGameState):-
  validate_move(GameState, [X1,Y1,X2,Y2]), !,
  execute_move(GameState, [X1,Y1,X2,Y2], NewGameState).
    
validate_move([Board, Turn], [X1,Y1,X2,Y2]):-
  inside_board(Board, X1, Y1), !,
  inside_board(Board, X2, Y2), !,
  get_tile_content(Board, [X1, Y1], SourceNum),
  get_tile_content(Board, [X2, Y2], DestinationNum),
  valid_source(Turn, SourceNum), !,
  valid_source(Turn, DestinationNum), !,
  get_max_steps(SourceNum, MaxSteps),
  valid_path([Board, Turn], [X1, Y1], [X2, Y2], MaxSteps).

valid_source(red, SourceNum):-
  get_units_tens(SourceNum, Units, _),
  Units >= 1,
  Units =< 4.
valid_source(blue, SourceNum):-
  get_units_tens(SourceNum, Units, _),
  Units >= 5,
  Units =< 8.

valid_destination(_, DestinationNum):-
  get_units_tens(DestinationNum, Units, _),
  Units = 0.
valid_destination(red, DestinationNum):-
  get_units_tens(DestinationNum, Units, _),
  Units >= 5,
  Units =< 8.
valid_destination(blue, DestinationNum):-
  get_units_tens(DestinationNum, Units, _),
  Units >= 1,
  Units =< 4.

valid_path(GameState, Source, Dest, MaxSteps):- valid_path(GameState, Source, Dest, 0, MaxSteps).

valid_path([Board, Turn], [X1, Y1], [X2, Y2], StepCount, MaxSteps):-
  StepCount < MaxSteps,
  


/*
valid_moves(+GameState, +Player, -ListOfMoves):-

value(+GameState, +Player, -Value):-

& Level 1 should return a valid random move. Level 2 should return the best one.
choose_move(+GameState, +Player, +Level, -Move):-




parse_input(Input, [X1, Y1], [X2, Y2]) :-
    atomic_list_concat([Start, End], '-', Input),
    atom_chars(Start, [X1Char, Y1Char]),
    atom_chars(End, [X2Char, Y2Char]),
    atom_number(X1Char, X1),
    atom_number(X2Char, X2),
    atom_chars(Y1Atom, [Y1Char]),
    atom_chars(Y2Atom, [Y2Char]),
    Y1 = Y1Atom,
    Y2 = Y2Atom.

*/



