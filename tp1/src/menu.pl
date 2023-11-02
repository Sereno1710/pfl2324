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
  write('1. Human vs Human'), nl,
  write('2. Human vs Machine'), nl,
  write('3. Machine vs Human'), nl,
  write('4. Machine vs Machine'), nl,
  write('Select an Option: ').

process_menu_input:- 
  read(Option),
  process_menu_input(Option).

process_menu_input(1):- start_game(human, human).
process_menu_input(2):- start_game(human, machine).
process_menu_input(3):- start_game(machine, human).
process_menu_input(4):- start_game(machine, machine).
process_menu_input(_):- 
  write('Invalid option.'),nl,
  write('Select an Option: '),
  process_menu_input.