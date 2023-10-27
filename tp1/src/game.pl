display_game(GameState):-
  print_piece(pentagon, red), nl,
  print_piece(square, red), nl,
  print_piece(triangle, red), nl,
  print_piece(circle, red), nl,

  print_piece(pentagon, blue), nl,
  print_piece(square, blue), nl,
  print_piece(triangle, blue), nl,
  print_piece(circle, blue).

% print_piece(+Piece, +Colour)
print_piece(Piece, Colour):-
  get_piece_text(Piece, Colour, PieceText),
  write(PieceText).

% get_piece_text(+Piece, +Colour, -PieceText)
get_piece_text(pentagon, red, 'R_P').
get_piece_text(square, red, 'R_S').
get_piece_text(triangle, red, 'R_T').
get_piece_text(circle, red, 'R_C').

get_piece_text(pentagon, blue, 'B_P').
get_piece_text(square, blue, 'B_S').
get_piece_text(triangle, blue, 'B_T').
get_piece_text(circle, blue, 'B_C').



/*
initial_state(+Size, -GameState):-

move(+GameState, +Move, -NewGameState):-

valid_moves(+GameState, +Player, -ListOfMoves):-

game_over(+GameState, -Winner):-

value(+GameState, +Player, -Value):-

& Level 1 should return a valid random move. Level 2 should return the best one.
choose_move(+GameState, +Player, +Level, -Move):-
*/