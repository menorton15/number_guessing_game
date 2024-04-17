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

echo -e " \nGuess the secret number between 1 and 1000:"

COUNT=0

read GUESS

while [[ ! $GUESS == $NUMBER ]]
do

  COUNT=($COUNT + 1)

  while [[ ! $GUESS =~ ^[0-9]+$ ]]
  do
    echo -e "\nThat is not an integer, guess again:"

    read GUESS
  done 

  if [[ $GUESS > $NUMBER ]]
  then
    echo -e "\nIt's lower than that, guess again:"
    read GUESS
  else if [[ $GUESS < $NUMBER ]]
  then
    echo -e "\nIt's higher than that, guess again:"
    read GUESS
  else
    if [[ $COUNT < $BEST_GAME ]]
    then
      BEST_GAME=$COUNT
    fi
    echo -e "\nYou guessed it in $COUNT tries. The secret number was $NUMBER. Nice job!"

    UPDATE_USER_DATA=$($PSQL "UPDATE users SET games_played = (games_played + 1), best_game = $BEST_GAME WHERE username = '$USERNAME'")
  fi
done

