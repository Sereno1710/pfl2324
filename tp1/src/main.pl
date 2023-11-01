:- consult('game.pl').
:- consult('menu.pl').
:- consult('display.pl').

play:-
  menu.

clear_screen:- write('\33\[2J').