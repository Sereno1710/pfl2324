/*
-1 - Ignore

Units:
0 - Empty Tile
1 - Red Pentagon
2 - Red Square
3 - Red Triangle
4 - Red Circle
5 - Blue Pentagon
6 - Blue Square
7 - Blue Triangle
8 - Blue Circle

Tens:
1 - Normal Tile
2 - Gold Tile
*/
% inital_state(+Size, -GameState)
initial_state(_, GameState) :-
    GameState = [
        [-1,-1,-1,-1,-1,-1,-1,-1,-1,10,-1,10,-1,-1,-1,-1,-1,-1,-1,-1,-1],
        [-1,-1,14,-1,10,-1,14,-1,10,-1,20,-1,10,-1,18,-1,10,-1,18,-1,-1],
        [-1,10,-1,12,-1,13,-1,10,-1,10,-1,10,-1,10,-1,17,-1,16,-1,10,-1],
        [14,-1,13,-1,11,-1,12,-1,14,-1,10,-1,18,-1,16,-1,15,-1,17,-1,18],
        [-1,10,-1,12,-1,13,-1,10,-1,10,-1,10,-1,10,-1,17,-1,16,-1,10,-1],
        [-1,-1,14,-1,10,-1,14,-1,10,-1,20,-1,10,-1,18,-1,10,-1,18,-1,-1],
        [-1,-1,-1,-1,-1,-1,-1,-1,-1,10,-1,10,-1,-1,-1,-1,-1,-1,-1,-1,-1]
    ].


start_game(Player1, Player2):-
  initial_state(_, GameState),
  display_game(GameState).

game_loop(Player1, Player2):- !.

% print_piece(+Id)
print_piece(Id):-
  get_piece(Id, _, _, PieceText),
  write(PieceText).

% get_piece(?Id, ?Piece, ?Colour, ?PieceText)
get_piece(1, pentagon, red, ' \x2B1F\ ').
get_piece(2, square, red, ' \x25A0\ ').
get_piece(3, triangle, red, ' \x25B2\ ').
get_piece(4, circle, red, ' \x25CF\ ').

get_piece(5, pentagon, blue, ' \x2B20\ ').
get_piece(6, square, blue, ' \x25A1\ ').
get_piece(7, triangle, blue, ' \x25B3\ ').
get_piece(8, circle, blue, ' \x25CB\ ').





/*
move(+GameState, +Move, -NewGameState):-

valid_moves(+GameState, +Player, -ListOfMoves):-

game_over(+GameState, -Winner):-

value(+GameState, +Player, -Value):-

& Level 1 should return a valid random move. Level 2 should return the best one.
choose_move(+GameState, +Player, +Level, -Move):-
*/