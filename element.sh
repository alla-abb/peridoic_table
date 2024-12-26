#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit
fi


if [[ $1 =~ ^[1-9]+$ ]]
then
  ELEMENT_RESULT=$($PSQL "select atomic_number, name, symbol,types.type, atomic_mass, melting_point_celsius, boiling_point_celsius from elements join properties using(atomic_number) join types using(type_id) where atomic_number = '$1'")
else
  ELEMENT_RESULT=$($PSQL "select atomic_number, name, symbol,types.type, atomic_mass, melting_point_celsius, boiling_point_celsius from elements join properties using(atomic_number) join types using(type_id) where name = '$1' or symbol = '$1'")
fi


if [[ -z  $ELEMENT_RESULT ]]
then
  echo "I could not find that element in the database."
  exit
else
  echo $ELEMENT_RESULT | while IFS=" |" read an name symbol type mass mp bp 
  do
    echo "The element with atomic number $an is $name ($symbol). It's a $type, with a mass of $mass amu. $name has a melting point of $mp celsius and a boiling point of $bp celsius."
  done
fi

