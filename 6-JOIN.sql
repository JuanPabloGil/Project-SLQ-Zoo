/*

Author  : Henry Naoto Ishiyama
Email   : henryishiyama@gmail.com
Date    : 2019/04/14
Version : 1.0.0

Description :
This program was developed as a part of the assignment/project for
"THE ODIN PROJECT".

Project :
SQL Zoo

Project URL :
https://www.theodinproject.com/courses/databases/lessons/sql#project-sql-zoo
https://github.com/TheOdinProject/curriculum/blob/master/databases/project_databases.md

https://sqlzoo.net/wiki/The_JOIN_operation

*/

/*
1.
The first example shows the goal scored by a player with the last name 'Bender'. The * says to list all the columns in the table - a shorter way of saying matchid, teamid, player, gtime

Modify it to show the matchid and player name for all goals scored by Germany. To identify German players, check for: teamid = 'GER'.

SELECT * FROM goal
  WHERE player LIKE '%Bender'
*/

SELECT
  x.matchid,
  x.player
FROM goal x
WHERE
  (x.teamid = (SELECT
                 y.id
               FROM eteam y
               WHERE
                 (y.teamname = 'Germany')));

/*
2.
From the previous query you can see that Lars Bender's scored a goal in game 1012. Now we want to know what teams were playing in that match.

Notice in the that the column matchid in the goal table corresponds to the id column in the game table. We can look up information about game 1012 by finding that row in the game table.

Show id, stadium, team1, team2 for just game 1012.

SELECT id,stadium,team1,team2
  FROM game
*/

SELECT
  id,
  stadium,
  team1,
  team2
FROM game
WHERE
  (id = 1012);

/*
3.
You can combine the two steps into a single query with a JOIN.

SELECT *
  FROM game JOIN goal ON (id=matchid)
The FROM clause says to merge data from the goal table with that from the game table. The ON says how to figure out which rows in game go with which rows in goal - the matchid from goal must match id from game. (If we wanted to be more clear/specific we could say
ON (game.id=goal.matchid)

The code below shows the player (from the goal) and stadium name (from the game table) for every goal scored.

Modify it to show the player, teamid, stadium and mdate for every German goal.

SELECT player,stadium
  FROM game JOIN goal ON (id=matchid)
*/

SELECT
  b.player,
  b.teamid,
  a.stadium,
  a.mdate
FROM game a
JOIN goal b
  ON (a.id = b.matchid)
WHERE
  (b.teamid = 'GER');

/*
4.
Use the same JOIN as in the previous question.

Show the team1, team2 and player for every goal scored by a player called Mario player LIKE 'Mario%'.
*/

SELECT
  a.team1,
  a.team2,
  b.player
FROM game a
JOIN goal b
  ON (a.id = b.matchid)
WHERE
  (b.player LIKE 'Mario%');

/*
5.
The table eteam gives details of every national team including the coach. You can JOIN goal to eteam using the phrase goal JOIN eteam on teamid=id

Show player, teamid, coach, gtime for all goals scored in the first 10 minutes gtime<=10.

SELECT player, teamid, gtime
  FROM goal
 WHERE gtime<=10
*/

SELECT
  x.player,
  x.teamid,
  y.coach,
  x.gtime
FROM goal x
JOIN eteam y
  ON (x.teamid = y.id)
WHERE
  (x.gtime <= 10);

/*
6.
To JOIN game with eteam you could use either
game JOIN eteam ON (team1=eteam.id) or game JOIN eteam ON (team2=eteam.id)

Notice that because id is a column name in both game and eteam you must specify eteam.id instead of just id

List the the dates of the matches and the name of the team in which 'Fernando Santos' was the team1 coach.
*/

SELECT
  game.mdate,
  eteam.teamname
FROM game
JOIN eteam
  ON (game.team1 = eteam.id)
WHERE
  (eteam.coach = 'Fernando Santos');

/*
7.
List the player for every goal scored in a game where the stadium was 'National Stadium, Warsaw'.
*/

SELECT
  goal.player
FROM goal
JOIN game
  ON (game.id= goal.matchid)
WHERE
  (game.stadium = 'National Stadium, Warsaw');

/*
8.
The example query shows all goals scored in the Germany-Greece quarterfinal.
Instead show the name of all players who scored a goal against Germany.

HINT
Select goals scored only by non-German players in matches where GER was the id of either team1 or team2.

You can use teamid!='GER' to prevent listing German players.

You can use DISTINCT to stop players being listed twice.

SELECT player, gtime
  FROM game JOIN goal ON matchid = id
    WHERE (team1='GER' AND team2='GRE')
*/

SELECT
  DISTINCT goal.player
FROM game
JOIN goal
  ON (goal.matchid = game.id)
WHERE
  ((game.team1='GER')
  OR
  (game.team2 = 'GER'))
AND
  (goal.teamid != 'GER');

/*
9.
Show teamname and the total number of goals scored.
COUNT and GROUP BY
You should COUNT(*) in the SELECT line and GROUP BY teamname.

SELECT teamname, player
  FROM eteam JOIN goal ON id=teamid
 ORDER BY teamname
*/

SELECT
  eteam.teamname,
  count(goal.player)
FROM eteam
JOIN goal
  ON (eteam.id = goal.teamid)
GROUP BY eteam.teamname;

/*
10.
Show the stadium and the number of goals scored in each stadium.
*/

SELECT
  game.stadium,
  count(goal.player)
FROM game
JOIN goal
  ON (game.id = goal.matchid)
GROUP BY game.stadium;

/*
11.
For every match involving 'POL', show the matchid, date and the number of goals scored.

SELECT matchid,mdate, team1, team2,teamid
  FROM game JOIN goal ON matchid = id
 WHERE (team1 = 'POL' OR team2 = 'POL')
*/

SELECT
  goal.matchid,
  game.mdate,
  count(goal.teamid)
FROM game
JOIN goal
  ON (goal.matchid = game.id)
WHERE
  (game.team1 = 'POL')
OR
  (game.team2 = 'POL')
GROUP BY goal.matchid, game.mdate;

/*
12.
For every match where 'GER' scored, show matchid, match date and the number of goals scored by 'GER'.
*/

SELECT
  goal.matchid,
  game.mdate,
  count(goal.teamid)
FROM game
JOIN goal
  ON (goal.matchid = game.id)
WHERE
  (goal.teamid = 'GER')
GROUP BY goal.matchid, game.mdate;

/*
13.
List every match with the goals scored by each team as shown. This will use "CASE WHEN" which has not been explained in any previous exercises.
https://sqlzoo.net/wiki/CASE
mdate	team1	score1	team2	score2
1 July 2012	ESP	4	ITA	0
10 June 2012	ESP	1	ITA	1
10 June 2012	IRL	1	CRO	3
...
Notice in the query given every goal is listed. If it was a team1 goal then a 1 appears in score1, otherwise there is a 0. You could SUM this column to get a count of the goals scored by team1. Sort your result by mdate, matchid, team1 and team2.

SELECT mdate,
  team1,
  CASE WHEN teamid=team1 THEN 1 ELSE 0 END score1
  FROM game JOIN goal ON matchid = id
*/

SELECT
  game.mdate,
  game.team1,
  sum(CASE WHEN (goal.teamid = game.team1)
      THEN 1
      ELSE 0
      END) AS score1,
  game.team2,
  sum(CASE WHEN (goal.teamid = game.team2)
      THEN 1
      ELSE 0
      END) AS score2
FROM game
LEFT JOIN goal
  ON (goal.matchid = game.id)
GROUP BY game.mdate, game.team1, game.team2;
