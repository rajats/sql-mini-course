/*credits: stanford university*/
/*
description:
You've started a new movie-rating website, and you've been collecting data on reviewers' ratings of various movies. There's not much data yet, but you can still try out some data modifications. Here's the schema: 

Movie ( mID, title, year, director ) 
English: There is a movie with ID number mID, a title, a release year, and a director. 

Reviewer ( rID, name ) 
English: The reviewer with ID number rID has a certain name. 

Rating ( rID, mID, stars, ratingDate ) 
English: The reviewer rID gave the movie mID a number of stars rating (1-5) on a certain ratingDate. 

Your modifications will run over a small data set conforming to the schema.
*/

/*1.)Add the reviewer Roger Ebert to your database, with an rID of 209. */
insert into Reviewer values(209,'Roger Ebert');

/*2.)Insert 5-star ratings by James Cameron for all movies in the database. Leave the review date as NULL. */
insert into Rating select 207,mID,5,null from Movie;

/*3.)For all movies that have an average rating of 4 stars or higher, add 25 to the release year. (Update the existing tuples; don't insert new tuples.) */
update Movie set year=year+25 where title in(select t.title as st from (select avg(stars) as astar,year,title from Movie,Rating  where 
Movie.mID=Rating.mID group by Movie.mID) t where t.astar>=4);

/*4.)Remove all ratings where the movie's year is before 1970 or after 2000, and the rating is fewer than 4 stars.*/
delete from Rating where stars<4 and Rating.mID in (select Rating.mID as mm from Movie,Rating where 
Movie.mID=Rating.mID and 
(year<1970 or year>2000)); 