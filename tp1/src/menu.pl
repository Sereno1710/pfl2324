menu:-
  print_menu,
  process_menu_input.

process_menu_input:- 
  get_char(Option),
  process_menu_input(Option).

process_menu_input('1'):- display_game(GameState).
process_menu_input(_):- write('Invalid option.'), nl.