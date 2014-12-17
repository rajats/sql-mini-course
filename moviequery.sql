/*credits: stanford university*/
/* sql movie rating and query exercise
description:
You've started a new movie-rating website, and you've been collecting data on reviewers' ratings of various movies. There's not much data yet, but you can still try out some interesting queries. Here's the schema: 

Movie ( mID, title, year, director ) 
English: There is a movie with ID number mID, a title, a release year, and a director. 

Reviewer ( rID, name ) 
English: The reviewer with ID number rID has a certain name. 

Rating ( rID, mID, stars, ratingDate ) 
English: The reviewer rID gave the movie mID a number of stars rating (1-5) on a certain ratingDate. 
*/
/*1.) Find the titles of all movies directed by Steven Spielberg. */
select title from Movie where director='Steven Spielberg';

/*2.) Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order.  */
select distinct year from Movie,Rating where Movie.mID=Rating.mID and (stars=4 or 
stars=5) order by year;

/*3.) Find the titles of all movies that have no ratings.  */
select distinct title from Movie,Rating where Movie.mID not in(select Rating.mid from Rating);

/*4.) Some reviewers didn't provide a date with their rating. Find the names of all reviewers who have ratings with a NULL value for the date.  */
select name from Reviewer,Rating where Reviewer.rID=Rating.rID and Rating.ratingDate is null;

/*5.) Write a query to return the ratings data in a more readable format: reviewer name, movie title, stars, and ratingDate. Also, sort the data, first by reviewer name, then by movie title, and lastly by number of stars.    */
select name,title,stars,ratingDate from Movie,Reviewer,Rating where Movie.mID=Rating.mID and 
Reviewer.rID=Rating.rID order by name,title,stars;

/*6.) For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time, return the reviewer's name and the title of the movie.  */
select distinct rvr1.name,rvr1.title from (select name,title,stars,ratingDate from Movie,Reviewer,Rating where Movie.mID=Rating.mID and 
Reviewer.rID=Rating.rID order by ratingDate) rvr1,
(select name,title,stars,ratingDate from Movie,Reviewer,Rating where Movie.mID=Rating.mID and 
Reviewer.rID=Rating.rID order by ratingDate) rvr2
where (rvr1.title=rvr2.title and rvr1.name=rvr2.name) and (rvr1.stars<rvr2.stars and 
rvr1.ratingDate<rvr2.ratingdate);

/*7.)For each movie that has at least one rating, find the highest number of stars that movie received. Return the movie title and number of stars. Sort by movie title. */
select title,stars from Movie,Rating where Movie.mID=Rating.mID group by title having max(stars) 
order by title;

/*8.)For each movie, return the title and the 'rating spread', that is, the difference between highest and lowest ratings given to that movie. Sort by rating spread from highest to lowest, then by movie title. */
select title,max(stars)-min(stars) as spread from Movie,Rating 
where Movie.mID=Rating.mID group by title order by spread desc,title;

/*9.)Find the difference between the average rating of movies released before 1980 and the average rating of movies released after 1980. 
(Make sure to calculate the average rating for each movie, then the average of those averages for movies before 1980 and movies after. 
Don't just calculate the overall average rating before and after 1980.) */
select max(abinit.row) - min(abinit.row) from (select avg(init.astar) as row from(select avg(stars) as astar,year from Movie,Rating 
where Movie.mID=Rating.mID group by title) init where init.year>1980 union 
select avg(init.astar) as row from(select avg(stars) as astar,year from Movie,Rating 
where Movie.mID=Rating.mID group by title) init where init.year<1980) abinit;