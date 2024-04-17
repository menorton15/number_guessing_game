#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess --tuples-only -c"
NUMBER=$((1 + $RANDOM % 1000))

echo "Enter your username:"

read USERNAME

USER=$($PSQL "SELECT games_played, best_game FROM users WHERE username = '$USERNAME'")

if [[ -z $USER ]]
then
  echo "Welcome, $USERNAME! It looks like this is your first time here."
  ADD_USER_RESULT=$($PSQL "INSERT INTO users(username) values('$USERNAME')")
else
  echo $USER | while read GAMES_PLAYED BAR BEST_GAME
  do
    echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
  done
fi


