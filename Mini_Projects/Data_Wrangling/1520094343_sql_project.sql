/* Welcome to the SQL mini project. For this project, you will use
Springboard' online SQL platform, which you can log into through the
following link:

https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

Note that, if you need to, you can also download these tables locally.

In the mini project, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */



/* Q1: Some of the facilities charge a fee to members, but some do not.
Please list the names of the facilities that do. */
SELECT * 
FROM  `Facilities` 
WHERE membercost = 0

/* Q2: How many facilities do not charge a fee to members? */
SELECT COUNT( * ) 
FROM  `Facilities` 
WHERE membercost =0
print out 4 

/* Q3: How can you produce a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost?
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */
SELECT facid, name, membercost, monthlymaintenance
FROM  `Facilities` 
WHERE membercost >0
AND membercost < ( .20 * monthlymaintenance ) 


/* Q4: How can you retrieve the details of facilities with ID 1 and 5?
Write the query without using the OR operator. */
SELECT * 
FROM  `Facilities` 
WHERE facid
IN ( 1, 5 ) 
LIMIT 0 , 30

/* Q5: How can you produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100? Return the name and monthly maintenance of the facilities
in question. */
SELECT name, monthlymaintenance, 
CASE WHEN (
monthlymaintenance >0
)
AND (
monthlymaintenance <=100
)
THEN  'CHEAP'
ELSE  'EXPENSIVE'
END AS CHEAP_OR_EXPENSIVE


/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Do not use the LIMIT clause for your solution. */
SELECT firstname, surname, joindate FROM `Members` Order by joindate DESC


/* Q7: How can you produce a list of all members who have used a tennis court?
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */
SELECT DISTINCT CONCAT( country_club.Members.firstname, country_club.Members.surname ) AS MembersFullName, country_club.Facilities.name AS FacilityName
FROM country_club.Members
JOIN country_club.Bookings ON country_club.Members.memid = country_club.Bookings.memid
JOIN country_club.Facilities ON country_club.Facilities.facid = country_club.Bookings.facid
ORDER BY MembersFullName


/* Q8: How can you produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30? Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */

select "name" as "facilityname", concat(firstname, ' ', surname) as personname, case when b.memid=0 then guestcost*slots
else membercost*slots end as cost, bookid
from Bookings as b
inner join Facilities as f on b.facid=f.facid
inner join Members as m on b.memid=m.memid
where starttime>='2012-09-14' and starttime<'2012-09-15' and 
(case when b.memid=0 then guestcost*slots
else membercost*slots end)>30
order by cost desc

/* Q9: This time, produce the same result as in Q8, but using a subquery. */
select "name" as "facilityname", concat(firstname, ' ', surname) as personname, cost, bookid  
from
(select memid, "name", guestcost*slots as "cost", bookid
from Bookings as b
inner join Facilities as f on b.facid=f.facid
where starttime>='2012-09-14' and starttime<'2012-09-15' and memid=0 and guestcost*slots>30
Union all
select memid, "name", membercost*slots as "cost", bookid
from Bookings as b
inner join Facilities as f on b.facid=f.facid
where starttime>='2012-09-14' and starttime<'2012-09-15' and memid<>0 and membercost*slots>30) as cost30
inner join Members on cost30.memid = Members.memid
order by cost desc

/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */
select "name",
sum(case when memid=0 then guestcost*slots
else membercost*slots end) as revenue
from Bookings as b
inner join Facilities as f on b.facid=f.facid
group by "name"
having sum(case when memid=0 then guestcost*slots
else membercost*slots end)<1000
