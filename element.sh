#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  # test if the argument is integer
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    # gather data using just atomic id
    GET_ATOMIC_NUMBER=$($PSQL "SELECT  atomic_number, name, symbol, t.type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties p INNER JOIN elements e USING(atomic_number) LEFT JOIN types t USING(type_id) WHERE atomic_number = $1;");
  else
    # gather data using atomic's name or symbol
    GET_ATOMIC_NUMBER=$($PSQL "SELECT  atomic_number, name, symbol, t.type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties p INNER JOIN elements e USING(atomic_number) LEFT JOIN types t USING(type_id) WHERE (UPPER(name) LIKE UPPER('$1')) OR (UPPER(symbol) LIKE UPPER('$1'));");
  fi

  echo "$GET_ATOMIC_NUMBER" | while IFS='|' read ATOMIC_NUMBER NAME SYMBOL TYPE ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS
    do
    # testing if the data gathering does not return null...
    if [[ -z $ATOMIC_NUMBER ]]
    then
      echo "I could not find that element in the database."
    else
      # printing the atomic description
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
    fi
    done
fi