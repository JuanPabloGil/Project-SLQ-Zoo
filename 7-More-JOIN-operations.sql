/*

Author  : Henry Naoto Ishiyama
Email   : henryishiyama@gmail.com
Date    : 2019/04/15
Version : 1.0.0

Description :
This program was developed as a part of the assignment/project for
"THE ODIN PROJECT".

Project :
SQL Zoo

Project URL :
https://www.theodinproject.com/courses/databases/lessons/sql#project-sql-zoo
https://github.com/TheOdinProject/curriculum/blob/master/databases/project_databases.md

https://sqlzoo.net/wiki/More_JOIN_operations

*/

/*
1.
List the films where the yr is 1962 [Show id, title]

SELECT id, title
 FROM movie
 WHERE yr=1962
*/

SELECT
  id,
  title
FROM movie
WHERE
  (yr = 1962);

/*
2.
Give year of 'Citizen Kane'.


*/

SELECT
  yr
FROM movie
WHERE
  (title = 'Citizen Kane');

/*
3.
List all of the Star Trek movies, include the id, title and yr (all of these movies include the words Star Trek in the title). Order results by year.
*/

SELECT
  id,
  title,
  yr
FROM movie
WHERE
  (title LIKE '%Star Trek%');

/*
4.
What id number does the actor 'Glenn Close' have?
*/

SELECT
  id
FROM actor
WHERE
  (name = 'Glenn Close');

/*
5.
What is the id of the film 'Casablanca'
*/

SELECT
  id
FROM movie
WHERE
  (title = 'Casablanca');

/*
6.
Obtain the cast list for 'Casablanca'.

what is a cast list?
The cast list is the names of the actors who were in the movie.

Use movieid=11768, (or whatever value you got from the previous question)
*/

SELECT
  actor.name
FROM actor
JOIN casting
  ON (casting.actorid = actor.id)
JOIN movie
  ON (casting.movieid = movie.id)
WHERE
  (casting.movieid = (SELECT
                        movie.id
                      FROM movie
                      WHERE
                        (movie.title = 'Casablanca')));

/*
7.
Obtain the cast list for the film 'Alien'
*/

SELECT
  actor.name
FROM actor
JOIN casting
  ON (casting.actorid = actor.id)
JOIN movie
  ON (casting.movieid = movie.id)
WHERE
  (casting.movieid = (SELECT
                movie.id
              FROM movie
              WHERE
                (title = 'Alien')));

/*
8.
List the films in which 'Harrison Ford' has appeared
*/

SELECT
  movie.title
FROM movie
JOIN casting
  ON (casting.movieid = movie.id)
JOIN actor
  ON (casting.actorid = actor.id)
WHERE
  (casting.actorid = (SELECT
                actor.id
              FROM actor
              WHERE
                (actor.name= 'Harrison Ford')));

/*
9.
List the films where 'Harrison Ford' has appeared - but not in the starring role. [Note: the ord field of casting gives the position of the actor. If ord=1 then this actor is in the starring role]
*/

SELECT
  movie.title
FROM movie
JOIN casting
  ON (casting.movieid = movie.id)
JOIN actor
  ON (casting.actorid = actor.id)
WHERE
  (casting.actorid = (SELECT
                actor.id
              FROM actor
              WHERE
                (actor.name = 'Harrison Ford')
              AND
                (casting.ord != 1)));

/*
10.
List the films together with the leading star for all 1962 films.
*/

SELECT
  movie.title,
  actor.name
FROM movie
JOIN casting
  ON (movie.id = casting.movieid)
JOIN actor
  ON (actor.id = casting.actorid)
WHERE
  (casting.ord = 1)
AND
  (movie.yr = 1962);


/*
11.
Which were the busiest years for 'John Travolta', show the year and the number of movies he made each year for any year in which he made more than 2 movies.
*/

SELECT
  movie.yr,
  COUNT(movie.title)
FROM movie
JOIN casting
  ON (movie.id = casting.movieid)
JOIN actor
  ON (casting.actorid = actor.id)
WHERE
  (actor.name = 'John Travolta')
GROUP BY movie.yr
HAVING (COUNT(movie.title) = (SELECT
                                MAX(c)
                              FROM (SELECT
                                      movie.yr,
                                      COUNT(movie.title) AS c
                                    FROM movie
                                    JOIN casting
                                      ON (movie.id = casting.movieid)
                                    JOIN actor
                                      ON (casting.actorid = actor.id)
                                    WHERE
                                      (actor.name = 'John Travolta')
                                    GROUP BY movie.yr) AS t));

/*
12.
List the film title and the leading actor for all of the films 'Julie Andrews' played in.

Did you get "Little Miss Marker twice"?
Julie Andrews starred in the 1980 remake of Little Miss Marker and not the original(1934).

Title is not a unique field, create a table of IDs in your subquery

SELECT movieid FROM casting
WHERE actorid IN (
  SELECT id FROM actor
  WHERE name='Julie Andrews')
*/

SELECT
  movie.title,
  actor.name
FROM movie
JOIN casting
  ON (movie.id = casting.movieid )
JOIN actor
  ON (actor.id = casting.actorid)
WHERE
  casting.movieid IN (SELECT
                        casting.movieid
                      FROM casting
                      WHERE
                        actorid IN (SELECT
                                      actor.id
                                    FROM actor
                                    WHERE
                                      actor.name = 'Julie Andrews'))
AND
  (casting.ord = 1);

/*
13.
Obtain a list, in alphabetical order, of actors who've had at least 30 starring roles.
*/

SELECT
  actor.name
FROM casting
JOIN actor
  ON (casting.actorid = actor.id)
WHERE
  (casting.ord = 1)
GROUP BY actor.name
HAVING (count(casting.actorid) >= 30);

/*
14.
List the films released in the year 1978 ordered by the number of actors in the cast, then by title.
*/

SELECT
  movie.title,
  count(casting.actorid)
FROM movie
JOIN casting
  ON (movie.id = casting.movieid)
WHERE
  (yr = '1978')
GROUP BY movie.title
ORDER BY count(casting.actorid) DESC, movie.title;

/*
15.
List all the people who have worked with 'Art Garfunkel'.
*/

SELECT
  DISTINCT actor.name
FROM casting
RIGHT JOIN actor
  ON (casting.actorid = actor.id)
WHERE casting.actorid IN (SELECT
                            casting.actorid
                          FROM casting
                          WHERE
                            (casting.actorid != (SELECT
                                                   actor.id
                                                 FROM actor
                                                 WHERE
                                                   (actor.name = 'Art Garfunkel')))
                                                 AND
                                                   (casting.movieid IN (SELECT
                                                                          casting.movieid
                                                                        FROM casting
                                                                        WHERE
                                                                          (casting.actorid = (SELECT
                                                                                                actor.id
                                                                                              FROM actor
                                                                                              WHERE
                                                                                                (actor.name = 'Art Garfunkel'))))));
