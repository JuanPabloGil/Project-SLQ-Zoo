/*

Author  : Henry Naoto Ishiyama
Email   : henryishiyama@gmail.com
Date    : 2019/04/21
Version : 1.0.0

Description :
This program was developed as a part of the assignment/project for
"THE ODIN PROJECT".

Project :
SQL Zoo

Project URL :
https://www.theodinproject.com/courses/databases/lessons/sql#project-sql-zoo
https://github.com/TheOdinProject/curriculum/blob/master/databases/project_databases.md

https://sqlzoo.net/wiki/Self_join

*/

/*
1.
How many stops are in the database.
*/

SELECT
  count(id)
FROM stops;

/*
2.
Find the id value for the stop 'Craiglockhart'.
*/

SELECT
  id
FROM stops
WHERE
  (name = 'Craiglockhart');

/*
3.
Give the id and the name for the stops on the '4' 'LRT' service.
*/

SELECT
  stops.id,
  stops.name
FROM stops
INNER JOIN route
  ON (stops.id = route.stop)
WHERE
  (route.company = 'LRT')
AND
  (route.num = 4);

/*
4.
The query shown gives the number of routes that visit either London Road (149) or Craiglockhart (53). Run the query and notice the two services that link these stops have a count of 2. Add a HAVING clause to restrict the output to these two routes.

SELECT company, num, COUNT(*)
FROM route WHERE stop=149 OR stop=53
GROUP BY company, num
*/

SELECT
  company,
  num,
  count(*) AS count
FROM route
WHERE
  (stop = 149)
OR
  (stop = 53)
GROUP BY company, num
HAVING (count = 2);

/*
5.
Execute the self join shown and observe that b.stop gives all the places you can get to from Craiglockhart, without changing routes. Change the query so that it shows the services from Craiglockhart to London Road.

SELECT a.company, a.num, a.stop, b.stop
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
WHERE a.stop=53
*/

SELECT
  a.company,
  a.num,
  a.stop,
  b.stop
FROM route a
INNER JOIN route b
  ON ((a.company = b.company)
     AND
     (a.num = b.num))
WHERE
  (a.stop = 53)
AND
  (b.stop = 149);

/*
6.
The query shown is similar to the previous one, however by joining two copies of the stops table we can refer to stops by name rather than by number. Change the query so that the services between 'Craiglockhart' and 'London Road' are shown. If you are tired of these places try 'Fairmilehead' against 'Tollcross'.

SELECT a.company, a.num, stopa.name, stopb.name
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
  JOIN stops stopa ON (a.stop=stopa.id)
  JOIN stops stopb ON (b.stop=stopb.id)
WHERE stopa.name='Craiglockhart'
*/

SELECT
  a.company,
  a.num,
  stopa.name,
  stopb.name
FROM route a
JOIN route b
  ON ((a.company = b.company)
     AND
     (a.num = b.num))
JOIN stops stopa
  ON (a.stop = stopa.id)
JOIN stops stopb
  ON (b.stop = stopb.id)
WHERE
  (stopa.name = 'Craiglockhart')
AND
  (stopb.name = 'London Road');

/*
7.
Give a list of all the services which connect stops 115 and 137 ('Haymarket' and 'Leith').
*/

SELECT
  a.company,
  a.num
FROM route a
JOIN route b
  ON ((a.company = b.company)
     AND
     (a.num = b.num))
JOIN stops stopa
  ON (stopa.id = a.stop)
JOIN stops stopb
  ON (stopb.id = b.stop)
WHERE
  (stopa.name = 'Haymarket')
AND
  (stopb.name = 'Leith')
GROUP BY a.num, a.company;

/*
8.
Give a list of the services which connect the stops 'Craiglockhart' and 'Tollcross'.
*/

SELECT
  a.company,
  a.num
FROM route a
JOIN route b
  ON ((a.company = b.company)
     AND
     (a.num = b.num))
JOIN stops stopa
  ON (stopa.id = a.stop)
JOIN stops stopb
  ON (stopb.id = b.stop)
WHERE
  (stopa.name = 'Craiglockhart')
AND
  (stopb.name = 'Tollcross');

/*
9.
Give a distinct list of the stops which may be reached from 'Craiglockhart' by taking one bus, including 'Craiglockhart' itself, offered by the LRT company. Include the company and bus no. of the relevant services.
*/

SELECT
  stopb.name,
  a.company,
  a.num
FROM route a
JOIN route b
  ON ((a.company = b.company)
     AND
     (a.num = b.num))
JOIN stops stopa
  ON (stopa.id = a.stop)
JOIN stops stopb
  ON (stopb.id = b.stop)
WHERE
  (stopa.name = 'Craiglockhart')
AND
  (a.company = 'LRT')
ORDER BY stopb.name;

/*
10.
Find the routes involving two buses that can go from Craiglockhart to Lochend.
Show the bus no. and company for the first bus, the name of the stop for the transfer,
and the bus no. and company for the second bus.

Hint
Self-join twice to find buses that visit Craiglockhart and Lochend, then join those on matching stops.
*/

SELECT
  a.num,
  a.company,
  stopc.name AS transfer,
  c.num,
  c.company
FROM route a
JOIN route b
  ON ((a.company = b.company)
     AND
     (a.num = b.num))
JOIN route c
JOIN route d
  ON ((c.company = d.company )
     AND
     (c.num = d.num))
JOIN stops stopa
  ON (a.stop = stopa.id)
JOIN stops stopb
  ON (b.stop = stopb.id)
JOIN stops stopc
  ON (c.stop = stopc.id)
JOIN stops stopd
  ON (d.stop = stopd.id)
WHERE
  (stopa.name = 'Craiglockhart')
AND
  (stopd.name = 'Lochend')
AND
  (stopb.name = stopc.name);
