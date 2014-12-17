/*credits: stanford university*/
/*
description:
Students at your hometown high school have decided to organize their social network using databases. So far, they have collected information about sixteen students in four grades, 9-12. Here's the schema: 

Highschooler ( ID, name, grade ) 
English: There is a high school student with unique ID and a given first name in a certain grade. 

Friend ( ID1, ID2 ) 
English: The student with ID1 is friends with the student with ID2. Friendship is mutual, so if (123, 456) is in the Friend table, so is (456, 123). 

Likes ( ID1, ID2 ) 
English: The student with ID1 likes the student with ID2. Liking someone is not necessarily mutual, so if (123, 456) is in the Likes table, there is no guarantee that (456, 123) is also present. 
*/

/*1.)Find the names of all students who are friends with someone named Gabriel. */
select name from Highschooler,Friend where (ID1=ID and ID2=1689) or (ID1=ID and ID2=1911);

/*2.)For every student who likes someone 2 or more grades younger than themselves, return that student's name and grade, and the name and grade of the student they like. */
select  l1.name,l1.grade,l2.name,l2.grade from Highschooler l1,Highschooler l2,Likes  
where (l1.ID=ID1 and ID2=l2.ID) and (l1.grade-2)>=l2.grade; 

/*3.)For every pair of students who both like each other, return the name and grade of both students. Include each pair only once, with the two names in alphabetical order. */
select l1.name,l1.grade,l2.name,l2.grade from Highschooler l1,Highschooler l2,Likes  
where (l1.ID=ID1 and l2.ID=ID2) and l2.ID in(select ID1 from Likes where ID2=l1.ID) and 
l1.name<l2.name; 

/*4.)Find all students who do not appear in the Likes table (as a student who likes or is liked) and return their names and grades. Sort by grade, then by name within each grade. */
select distinct name,grade from Highschooler,Likes where ID not in(select ID1 from Likes) and ID not in 
(select ID2 from Likes) order by grade,name;

/*5.)For every situation where student A likes student B, but we have no information about whom B likes (that is, B does not appear as an ID1 in the Likes table), return A and B's names and grades. */
select  l1.name,l1.grade,l2.name,l2.grade from Highschooler l1,Highschooler l2,Likes  
where (l1.ID=ID1 and ID2=l2.ID) and l2.ID not in(select ID1 from Likes); 

/*6.)Find names and grades of students who only have friends in the same grade. Return the result sorted by grade, then by name within each grade. */
select t.nm,t.grad from(select h1.ID as mid,h1.name as nm,h1.grade as grad,ID2,h2.name,h2.grade as grad1 
from Highschooler h1,Highschooler h2,Friend where h1.ID=ID1 
and h2.ID=ID2) t group by t.mid having (max(t.grad1)=t.grad and min(t.grad1)=t.grad) order by 
t.grad,t.nm;

/*7.)For each student A who likes a student B where the two are not friends, find if they have a friend C in common (who can introduce them!). For all such trios, return the name and grade of A, B, and C. */
select t.an,t.ag,t.bn,t.bg,t.cn,t.cg from 
(select distinct a.name as an,a.grade as ag,b.name as bn,b.grade as bg,c.name as cn, 
c.grade as cg,b.ID as bid,c.ID as cid from Highschooler a,Highschooler b, 
Highschooler c,Friend,Likes where (a.ID=Likes.ID1 and b.ID=Likes.ID2) and (a.ID=Friend.ID1 and 
b.ID not in(select f.ID2 from friend f where f.ID1=a.ID)) and (a.ID=Friend.ID1 and c.ID 
in(select f1.ID2 from friend f1 where f1.ID1=a.ID))) t where t.cid in(select f2.ID2 from friend f2 
where f2.ID1=t.bid);

/*8.)Find the difference between the number of students in the school and the number of different first names. */
select count(name)-count(distinct name) from Highschooler

/*9.)Find the name and grade of all students who are liked by more than one other student. */
select  name,grade from Highschooler,(select ID2 as gotit,count(ID2) as occ 
from Likes group by ID2) t where 
ID=t.gotit and t.occ>1 ;