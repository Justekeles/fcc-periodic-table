#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  USER_INPUT=$1
  # Check if there is an empty input
  if [[ $USER_INPUT =~ ^[0-9]+$ ]]
  then
    ELEMENT_FULL_INFORMATION=$($PSQL "SELECT * FROM properties INNER JOIN elements ON properties.atomic_number=elements.atomic_number INNER JOIN types on properties.type_id = types.type_id WHERE properties.atomic_number='$USER_INPUT'")

    if [[ -z $ELEMENT_FULL_INFORMATION ]]
    then
      echo "I could not find that element in the database."
    else
      echo $ELEMENT_FULL_INFORMATION | while IFS="|" read ANUM AMASS MPOINT BPOINT ID ANUM2 SYMB NAME ID2 TYPE
      do
        echo "The element with atomic number $ANUM is $NAME ($SYMB). It's a $TYPE, with a mass of $AMASS amu. $NAME has a melting point of $MPOINT celsius and a boiling point of $BPOINT celsius."
      done
    fi
  else
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$USER_INPUT' OR name='$USER_INPUT'")

    if [[ -z $ATOMIC_NUMBER ]]
    then
      echo "I could not find that element in the database."
    else
      ELEMENT_FULL_INFORMATION=$($PSQL "SELECT * FROM properties INNER JOIN elements ON properties.atomic_number=elements.atomic_number INNER JOIN types ON properties.type_id = types.type_id WHERE properties.atomic_number='$ATOMIC_NUMBER'")
      echo $ELEMENT_FULL_INFORMATION | while IFS="|" read ANUM AMASS MPOINT BPOINT ID ANUM2 SYMB NAME ID2 TYPE
      do
        echo "The element with atomic number $ANUM is $NAME ($SYMB). It's a $TYPE, with a mass of $AMASS amu. $NAME has a melting point of $MPOINT celsius and a boiling point of $BPOINT celsius."
      done
    fi
  fi
fi
