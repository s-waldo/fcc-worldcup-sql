#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams, games")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WIN_SCORE OPP_SCORE
do
  if [[ $YEAR != year ]]
  then
    # get winner_id
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    # if not exists
    if [[ -z $WINNER_ID ]]
    then
      # save team
      WINNER_ID_RETURN=$($PSQL "INSERT INTO teams (name) VALUES ('$WINNER')")
      if [[ $WINNER_ID_RETURN == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $WINNER
      fi
      # get new winner_id
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    fi
    
    # get opp_id
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    # if not exists
    if [[ -z $OPPONENT_ID ]]
    then
      # save team
      OPPONENT_ID_RETURN=$($PSQL "INSERT INTO teams (name) VALUES ('$OPPONENT')")
      if [[ $OPPONENT_ID_RETURN == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $OPPONENT
      fi
      # get new opp_id
      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    fi

    # save game
    GAME_RETURN=$($PSQL "INSERT INTO games (year, round, winner_goals, opponent_goals, winner_id, opponent_id) VALUES ($YEAR, '$ROUND', $WIN_SCORE, $OPP_SCORE, $WINNER_ID, $OPPONENT_ID)")
    if [[ $GAME_RETURN = "INSERT 0 1" ]]
    then
      echo Inserted into games, $YEAR $ROUND $WINNER
    fi
  fi
done
