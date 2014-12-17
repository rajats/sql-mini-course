/*credits: stanford university*/
/*
Description:
Students at your hometown high school have decided to organize their social network using databases. So far, they have collected information about sixteen students in four grades, 9-12. Here's the schema: 

Highschooler ( ID, name, grade ) 
English: There is a high school student with unique ID and a given first name in a certain grade. 

Friend ( ID1, ID2 ) 
English: The student with ID1 is friends with the student with ID2. Friendship is mutual, so if (123, 456) is in the Friend table, so is (456, 123). 

Likes ( ID1, ID2 ) 
English: The student with ID1 likes the student with ID2. Liking someone is not necessarily mutual, so if (123, 456) is in the Likes table, there is no guarantee that (456, 123) is also present. 

Your modifications will run over a small data set conforming to the schema. 
*/

/*1.)It's time for the seniors to graduate. Remove all 12th graders from Highschooler. */
delete from Highschooler where grade is 12;

/*2.)If two students A and B are friends, and A likes B but not vice-versa, remove the Likes tuple. */
delete from Likes where Likes.ID1 in(select t.lid1 as liid1 from (select Likes.ID1 as lid1,Likes.ID2 as lid2 from Likes 
where 
Likes.ID1 in (select Friend.ID1 from Friend where Friend.ID2=Likes.ID2)) t where 
t.lid2 not in (select ID1 from Likes where ID2=t.lid1)) and 
Likes.ID2 in(select t.lid2 as liid2 from (select Likes.ID1 as lid1,Likes.ID2 as lid2 from Likes 
where 
Likes.ID1 in (select Friend.ID1 from Friend where Friend.ID2=Likes.ID2)) t where 
t.lid2 not in (select ID1 from Likes where ID2=t.lid1));