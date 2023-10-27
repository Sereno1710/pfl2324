menu:-
  print_menu,
  process_menu_input.

print_menu:-
  clear_screen,
  write('  _________   __________________________  _   __'), nl,
  write(' /_  __/   | / ____/_  __/  _/ ____/ __ \\/ | / /'), nl,
  write('  / / / /| |/ /     / /  / // / __/ / / /  |/ / '), nl,
  write(' / / / ___ / /___  / / _/ // /_/ / /_/ / /|  /  '), nl,
  write('/_/ /_/  |_\\____/ /_/ /___/\\____/\\____/_/ |_/   '), nl,
  nl,
  write('1. Player vs Player'), nl,
  write('Select an Option: ').

process_menu_input:- 
  get_char(Option),
  process_menu_input(Option).

process_menu_input('1'):- display_game(GameState).
process_menu_input(_):- 
  write('Invalid option.'),nl,
  process_menu_input.