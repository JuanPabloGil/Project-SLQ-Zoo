/*

Author  : Henry Naoto Ishiyama
Email   : henryishiyama@gmail.com
Date    : 2019/04/20
Version : 1.0.0

Description :
This program was developed as a part of the assignment/project for
"THE ODIN PROJECT".

Project :
SQL Zoo

Project URL :
https://www.theodinproject.com/courses/databases/lessons/sql#project-sql-zoo
https://github.com/TheOdinProject/curriculum/blob/master/databases/project_databases.md

https://sqlzoo.net/wiki/NSS_Tutorial

*/

/*
1.
The example shows the number who responded for:

question 1
at 'Edinburgh Napier University'
studying '(8) Computer Science'
Show the the percentage who STRONGLY AGREE

SELECT response
  FROM nss
 WHERE question='Q01'
   AND institution='Edinburgh Napier University'
   AND subject='(8) Computer Science'
*/

SELECT
  A_STRONGLY_AGREE
FROM nss
WHERE
  (question = 'Q01')
AND
  (institution = 'Edinburgh Napier University')
AND
  (subject = '(8) Computer Science');

/*
2.
Show the institution and subject where the score is at least 100 for question 15.

SELECT response
  FROM nss
 WHERE question='Q01'
   AND institution='Edinburgh Napier University'
   AND subject='(8) Computer Science'
*/

SELECT
  institution,
  subject
FROM nss
WHERE
  (question = 'Q15')
AND
  (score >= 100);

/*
3.
Show the institution and score where the score for '(8) Computer Science' is less than 50 for question 'Q15'.

SELECT institution,score
  FROM nss
 WHERE question='Q15'
   AND institution='Edinburgh Napier University'
   AND subject='(8) Computer Science'
*/

SELECT
  institution,
  score
FROM nss
WHERE
  (question = 'Q15')
AND
  (score < 50)
AND
  (subject = '(8) Computer Science');

/*
4.
Show the subject and total number of students who responded to question 22 for each of the subjects '(8) Computer Science' and '(H) Creative Arts and Design'.

HINT
You will need to use SUM over the response column and GROUP BY subject.

SELECT institution,score
  FROM nss
 WHERE question='Q15'
   AND institution='Edinburgh Napier University'
   AND subject='(8) Computer Science'
*/

SELECT
  subject,
  sum(response)
FROM nss
WHERE
  (question = 'Q22')
AND
  ((subject = '(8) Computer Science')
  OR
  (subject = '(H) Creative Arts and Design'))
GROUP BY subject;

/*
5.
Show the subject and total number of students who A_STRONGLY_AGREE to question 22 for each of the subjects '(8) Computer Science' and '(H) Creative Arts and Design'.

HINT
The A_STRONGLY_AGREE column is a percentage. To work out the total number of students who strongly agree you must multiply this percentage by the number who responded (response) and divide by 100 - take the SUM of that.

SELECT institution,score
  FROM nss
 WHERE question='Q15'
   AND institution='Edinburgh Napier University'
   AND subject='(8) Computer Science'
*/

SELECT
  subject,
  (sum(response * A_STRONGLY_AGREE) / 100)
FROM nss
WHERE
  (question = 'Q22')
AND
  ((subject = '(8) Computer Science')
  OR
  (subject = '(H) Creative Arts and Design'))
GROUP BY subject;

/*
6.
Show the percentage of students who A_STRONGLY_AGREE to question 22 for the subject '(8) Computer Science' show the same figure for the subject '(H) Creative Arts and Design'.

Use the ROUND function to show the percentage without decimal places.

SELECT institution,score
  FROM nss
 WHERE question='Q15'
   AND institution='Edinburgh Napier University'
   AND subject='(8) Computer Science'
*/

SELECT
  subject,
  round((sum(response * A_STRONGLY_AGREE) / 100) / sum(response) * 100)
FROM nss
WHERE
  (question = 'Q22')
AND
  ((subject = '(8) Computer Science')
  OR
  (subject = '(H) Creative Arts and Design'))
GROUP BY subject;

/*
7.
Show the average scores for question 'Q22' for each institution that include 'Manchester' in the name.

The column score is a percentage - you must use the method outlined above to multiply the percentage by the response and divide by the total response. Give your answer rounded to the nearest whole number.

SELECT institution,subject,score,response
  FROM nss
 WHERE question='Q22'
   AND (institution LIKE '%Manchester%')
ORDER BY institution
*/

SELECT
  institution,
  round((sum(response * score) / 100) / sum(response) * 100)
FROM nss
WHERE
  (question='Q22')
AND
  (institution LIKE '%Manchester%')
GROUP BY institution;

/*
8.
Show the institution, the total sample size and the number of computing students for institutions in Manchester for 'Q01'.

SELECT institution,subject,score,response
  FROM nss
 WHERE question='Q22'
   AND (institution LIKE '%Manchester%')
*/

SELECT
  x.institution,
  sum(x.sample),
  (SELECT
     y.sample
   FROM nss y
   WHERE
     (y.question = 'Q01')
   AND
     (y.institution = x.institution)
   AND
     (y.subject = '(8) Computer Science'))
FROM nss x
WHERE
  (x.question = 'Q01')
AND
  (x.institution LIKE '%Manchester%')
GROUP BY x.institution;
