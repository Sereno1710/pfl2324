:- use_module(library(lists)).
:- use_module(library(system)).
:- use_module(library(random)).
:- use_module(library(between)).

:- consult('game.pl').
:- consult('menu.pl').
:- consult('display.pl').
:- consult('data.pl').
:- consult('utils.pl').
:- consult('machine.pl').

% initiates program
play:-
  menu.