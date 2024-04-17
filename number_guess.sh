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
  USER=$($PSQL "SELECT games_played, best_game FROM users WHERE username = '$USERNAME'")
else
  echo $USER | while read GAMES_PLAYED BAR BEST_GAME
  do
    echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
  done
fi
echo $NUMBER

echo -e " \nGuess the secret number between 1 and 1000:"

COUNT=1

read GUESS

while [[ ! $GUESS == $NUMBER ]]
do

  COUNT=$(( $COUNT + 1 ))

  while [[ ! $GUESS =~ ^[0-9]+$ ]]
  do
    echo -e "\nThat is not an integer, guess again:"

    read GUESS
  done 

  if [[ $GUESS -gt $NUMBER ]]
  then
    echo -e "\nIt's lower than that, guess again:"
    read GUESS
  elif [[ $GUESS -lt $NUMBER ]]
  then
    echo -e "\nIt's higher than that, guess again:"
    read GUESS
  fi
done

echo $USER | while read GAMES_PLAYED BAR BEST_GAME
do
  if [[ $COUNT -lt $BEST_GAME ]]
  then
    BEST_GAME=$COUNT
  fi
  echo "You guessed it in $COUNT tries. The secret number was $NUMBER. Nice job!"
  GAMES_PLAYED=$(($GAMES_PLAYED + 1))
  UPDATE_USER_DATA=$($PSQL "UPDATE users SET games_played = $GAMES_PLAYED, best_game = $BEST_GAME WHERE username = '$USERNAME'")
done
