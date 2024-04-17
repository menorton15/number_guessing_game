#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess --tuples-only -c"
NUMBER=$((1 + $RANDOM % 1000))

echo "Enter your username:"


