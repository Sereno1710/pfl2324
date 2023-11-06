valid_moves(GameState, _ , ListOfMoves):-
  findall(X1-Y1-X2-Y2, valid_move(GameState, X1-Y1-X2-Y2, _, _), ListOfMoves).

choose_move(GameState, Player, 1, ColI-RowI-ColF-RowF):-
  valid_moves(GameState, Player, ListOfMoves),
  random_member(ColI-RowI-ColF-RowF, ListOfMoves).
/*

value(+GameState, +Player, -Value):-

& Level 1 should return a valid random move. Level 2 should return the best one.
choose_move(+GameState, +Player, +Level, -Move):-
*/
