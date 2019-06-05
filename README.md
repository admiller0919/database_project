# database_project
Files from a database course project

Here is the total description of the project, incase you are interested in knowing how all of the features I worked on fit into the whole project. I have added the description for each feature to the top of all files so they are easier to understand.



Database Application Development
Spring 2019
Online Movie Ticket Purchase System
Overview
You will form groups of four to five people in this project. It is recommended that each group consists of at least four people given the amount of work. Please read the whole document carefully before starting your project.
Your assignment is to design an online movie ticket purchase system. You can get yourself familiar with the systems by visiting websites such as fandango.com, movietickets.com. You will design the database, insert some sample data, and implement a set of required features. Each feature will be implemented as one or more Oracle PL/SQL procedures/functions. You do NOT need to write a graphic user interface. 

Assumptions:
You can make the following assumptions in this project. 
1.	The system needs to store data about users. Each user has user id, name of user, email, address, and password. 
2.	The system needs to store data about cinemas. Each cinema belongs to a company (e.g., AMC, Regal). Each cinema has a cinema ID, cinema name, address, phone, and has one or more auditoriums. 
3.	Each company (like AMC) has a company ID, company name.
4.	Each company has discounts for child and senior. The discount rate may vary. E.g., company A may have a rate of 0.8 (i.e., 20% off) for child and 0.9 (i.e., 10% off) for senior. 
5.	Each cinema auditorium has an auditorium ID (only unique within the cinema), cinema ID, auditorium type (regular, 3D, or IMAX), and capacity (#of seats). 3D auditorium can show both regular and 3D movies. Regular auditorium can only show regular movies. IMAX auditorium can only show IMAX movies.
6.	Each IMAX cinema auditorium has a seat map with a varchar type seat ID. E.g., '9A' means a seat in row 9. The combination of cinema ID, cinema auditorium ID, and seat ID will uniquely identify a seat in the whole system. 
7.	The system stores information about movies, including movie ID, title, release_date, rating (e.g., 'PG 13'), average imdb review score, length of the movie (in hours and minutes).
8.	The system stores show time of a movie at a cinema, including a show time ID, movie id, auditorium id, cinema id, start time of the show, format (regular, 3D, or IMAX), whether the show is full (no more tickets can be purchased), whether the show allows selection of seat (typically for IMAX format), base price (for adults). 
9.	For shows that allow selection of seats (typically IMAX movies), the system keeps track of whether a seat in the seat map table is still available for that show time. 
10.	The system stores information about purchase transactions, including a transaction ID, user ID, show ID, purchase time, quantity (#of tickets), status (1 means paid, 0 not paid, 2 canceled), and total amount of the transaction, which includes sum of price of each ticket in the transaction plus a $1.50 fee per ticket and a 6% sales tax.
11.	The system stores information about tickets. Each ticket is associated with a purchase transaction. Each ticket has a unique ticket ID, a ticket type (adult, child, or senior), price for that ticket (equals base price * applicable discount rate depending on the type of ticket), optional cinema ID, auditorium ID, and seat ID (identifying the assigned seat), and whether the ticket has been issued (after the transaction has been paid in full). 
12.	The system stores information about payment. Each payment has a unique payment ID, ID of the transaction the payment is applied to, a payment type (1 means payment, 2 means refund), payment method (1 credit card/gift card, 2 debit card, 3 paypal), last 4 digits of payment card, amount of payment, and payment time. It is possible to make multiple payment to a transaction (e.g., using a gift card plus a credit card) as long as the total payment reaches the total amount of the transaction. 
13.	The system stores reviews about cinema auditoriums, including review ID, user ID, cinema ID, a numerical score from 1 to 5, and a textual content and review time. 
Features: (those with *** are more difficult ones and may require at least twice or more time to finish than other features. Be aware of this when you assign features)
Please check special cases and normally if an error message is printed you should end the procedure.
Features for user management:

1.	Registration: a user needs to provide name, email, address, and password. The procedure should check whether the email already exists in the users table. If so, please print a message saying the user already exists. Otherwise insert the user into users table and print the new user ID.  
2.	Login: Allow a user to log on by providing email and password. Please check whether email exists and password matches. If not, please print a message to indicate the error. Otherwise print a message to indicate user has logged on. The procedure should return a value 1 for success login and 0 for unsuccessful log in.

Features related to movies and show time

3.	*** Add a show time. Input includes movie id, auditorium id, cinema id, show start time, format (regular, 3D or IMAX), whether users can select seat, and base price (for adult). 
a.	Please check whether the movie exists, if not print invalid movie id
b.	Next check whether the cinema id and auditorium id matches existing cinema, if not print invalid auditorium id or cinema id. 
c.	Next check if start time is no earlier than movie release time, otherwise print “movie can be shown only after release”. 
d.	Please check if the movie format can be shown in the movie auditorium, (3D can only be shown in 3D auditorium, regular movie can be shown in regular or 3D auditorium, IMAX can be only shown in IMAX auditorium)
e.	Please also check whether there is a conflict with shows at the same cinema and same auditorium. E.g., if the input show time starts at 4:30 pm, but there is already a show at the same auditorium and same cinema starting at 3:30 pm showing a movie with length of 2 hours, then it is impossible to add this new show. Please print a message saying there is a conflict. Hint: think of the condition of checking conflict, e.g., for show A and show B, compare show A’s end time (start time + length) to show B’s start time and compare show A’s start time to show B’s end time. 
f.	Finally insert the show time. Also insert seat availability information if the show allows selecting seats. For each seat in the cinema auditorium in the seat map, add a row and mark it available for this show.

4.	Add a movie. Input includes title, year, rating, and avg_imdb_review and length. 
a.	First check whether there is a movie with same title and release date
b.	If so, print a message that the movie has been inserted 
c.	Otherwise, insert a new movie and print out movie id.

5.	List show time of a movie. Input includes movie title and a date. 
a.	First check whether movie title matches any movie, the title can be part of the full movie title.
b.	Find all show time on that day for movies matching the input title. Print cinema name, start time, format, and whether it is full. Order results by movie title, cinema, format, and start time.

6.	List all movies in a cinema. Input includes cinema name and an input time. 
a.	First check whether any cinema has the given name (could be part of the full name, e.g., AMC
b.	If there is no matching cinema, print out no such cinema
c.	List all movies shown in that cinema on the same date but after the input time. Print title, format, start time and whether it is full, and order results by cinema name, movie title, cinema, format, and start time.

Features related to purchasing tickets
7.	Display available seats for a movie show. Input includes movie id, cinema id, start time of the movie, format. 
a.	First check whether movie id is valid. If not print a message saying the movie does not exist.
b.	Next find a show with given movie id, cinema id, start time, and format, and allows seat selection and is not full. If no match, print a message no such show. 
c.	Finally, print out all available seats for the matching show, order by show id and then seat id.

8.	*** Buy tickets for a movie show. Input includes user id, a cinema id, movie title (could be part of the full title), start time of the movie, format, #of adults, #of kids, and #of senior. 
a.	Check if user id is valid. If not print an error message. 
b.	Find a show time matching the input cinema id, movie title (could be part of the title), start time, and format. In case there is no matching show, print an error message. In case of there are multiple matches, print a message please provide more specific movie title. 
c.	Next check whether there are enough seats (capacity of the cinema auditorium - sold tickets of this show>= total tickets requested including adult, child, and senior tickets). If there are not enough seats left print an error message.
d.	If there are enough seats, create a new transaction, compute the total due as sum of each ticket ‘s price (discount needs to be applied based on type of tickets), plus $1.50 per ticket fee and 6% tax. Set the transaction status to unpaid. 
e.	Please print out the detail breakdown of the total including price for each category (adult, child, senior), #of tickets in each category, total in each category, fee, tax and final total.
f.	If the capacity of the auditorium has been reached (sold tickets + this transaction’s quantity = auditorium’s capacity), update the show to be full. 
g.	Also create tickets with status 0 (not issued, a ticket will only be issued after payment) and appropriate ticket type (adult, child, senior), leave seat id as null as it will be assigned in feature 9.

9.	*** Select seats for a transaction. Input includes a transaction id and a varray of selected seats, 
a.	First check whether transaction id is valid. If not print an error message. 
b.	Next check if the associated movie show allows selection of seats, if not print an error message
c.	Next check if input array size = quantity of tickets of the transaction, if not print an error message.
d.	Next check whether any input seat is still available. If not print an error message and end the procedure. 
e.	Finally update the ticket table to assign given seat id to each ticket in the transaction. 

10.	Pay a transaction. Input includes transaction id, payment method, last 4 digits of payment card, amount.
a.	First check whether transaction id is valid. If not print a message. 
b.	It is possible that multiple payment can be made for the same transaction (e.g., someone used a gift card plus a credit card to pay). So check if total existing payment for that transaction reaches the total due. If so no new payment is needed and print an error message. 
c.	If the existing payment does not reach the total due, check if new payment + existing payment reaches the total. If so set the transaction status to paid and set all tickets' associated with that transaction to the status issued. Insert a new payment record including current time as payment time and total due – existing payment as new payment (this will prevent overpayment). 
d.	If new payment + existing payment does not reach the total due, just insert a new payment record.

11.	*** Cancel a purchase. The input is a transaction id and current time (current time is an input to simplify testing). 
a.	It first checks whether the transaction id is valid. If not print an error message. 
b.	It then checks whether the current time is at least 30 minutes before the show starts and the transaction has not been canceled yet. Otherwise print an error message. 
c.	If the transaction can be canceled, check if the transaction has been paid. If so for each payment record insert a corresponding refund record with the same payment method, last 4 digits of payment card, and the amount should be negative of existing amount. The payment type should be refund. 
d.	Next mark the transaction as canceled, and delete related tickets. If those tickets have assigned seats, also update those seats to set them available again.
Features for review and statistics:
12.	Add a review for a cinema. Input includes a user ID, cinema ID, review score, and content of review. 
a.	First check whether user ID, cinema ID are valid and review score is from 1 to 5. If not print an error message. 
b.	Please also check if the same user has left a review for the same cinema within 30 days. If so print an error message that you cannot review the same place twice within 30 days. Otherwise insert a new review with the review time is current time.


13.	*** Compute statistics for movies: given a time period (start and end dates), for each movie showing in this period, compute total ticket sales as well as occupancy rate. 
a.	Total ticket sales is the sum of total amount of paid transactions for that movie 
b.	Occupancy rate is total number of tickets sold for that movie divided by maximal possible number of tickets (maximal possible #of tickets = capacity of the cinema auditorium showing the movie*#of shows in that auditorium and then sum over all such cinema auditoriums). E.g., suppose a movie is shown in a cinema auditorium with capacity 100 for 10 times and a cinema auditorium with capacity of 50 for 10 times, but only sold 300 tickets, the occupancy rate is 300/(100*10+50*10)=300/1500=0.2. 
c.	Please order results by descending order. 
Hint: 1) it is easier to compute total tickets sold for a movie and maximal possible number of tickets separately. 2) Even if a show has sold zero tickets it still needs to be counted in the maximal possible number of tickets. 3) You can use subquery in from clause. 
14.	Compute statistics for each cinema. Input is a date range. Compute statistics for each cinema in this period, including total tickets sold, total sales (in dollars), occupancy rate (computed as total tickets sold divided by maximal possible tickets sold) and average review score during the period.

Hint: the SQL code is similar to feature 13. You can compute total sales, occupancy rate, and average review score separately. 

15.	*** Computer statistics for a given user. Input includes user id and a date range. First check whether the user id is valid. If not print an error message. Otherwise compute for that user the following statistics: 
a.	#of paid transactions, 
b.	#of tickets bought, total money spent
c.	#of canceled transactions,  
d.	the most frequently visited cinema (with the maximal number of paid transactions). 
Hint: to compute most frequently visited cinema, you can use subquery in having clause. 
16.	*** Identify suspicions reviews. Suspicious reviews are those 1) very short (no more than x characters long where x is input and with extreme scores (1 or 5); or 2) the reviewer has never purchased any tickets for shows at the reviewed cinema. For example, if a reviewer A has left a review for cinema X. But only users B, C, and D have purchased tickets at X (they have transactions with shows at X), then A's review for X is fake. Please print out review id and reason for fake review.

Hint: for the second condition, use subquery.


Deliverables: 
There will be 4 deliverables. D1 and D3 will be due before class starts on the due date. D2 and D4 are due midnight of the due date. Delayed submission will result in a penalty of 30% of your score (e.g., if your score for part 2 is 20 but you are late, your score will be 14). The final presentation is due at class time and no delay is allowed.
1.	10%. Due 2/12. Project Management Schedule. 
a.	Include team members and a timeline showing each phase of your project with its tasks and time duration, for the entire effort. 
b.	It is expected that every member should participate in all phases of the project. For example, every member should implement at least three features including at least one difficult feature (with *).
c.	Each task in the same phase may be assigned to different members. E.g., you can specify that features 1-5 are assigned to member X. 
d.	Tasks should include system design, populating tables, writing code, testing code, running example queries, writing documents, preparing for presentation, etc. Smaller milestones should be set for deliverable 3 and 4. 
e.	This deliverable will be graded based on whether items a) to d) are included and whether the schedule is reasonable (e.g., enough time such as 3 weeks are left for testing and integration).

2.	25%. Due 3/5. Design Document which includes the following:
a.	ER diagram of the database. You don’t have to follow exact notations of ER diagram, but need to show tables, columns, primary keys, and foreign key links.
b.	SQL statements to create database tables and to insert some sample data (at least 3 rows per table). Please include drop table and drop sequence statements before create table, create sequence and insert. 
c.	Specification for each required feature. The specification should include a description of input parameters and output (usually printing a message), and an example of how a user can use this feature (e.g., exec XXX(…) where XXX is the procedure name). You don’t need to implement any of these features at this point.

3.	30%. Due 5/8. Demonstration at the lab session. If you team consists of members from multiple lab sessions your group will demonstrate in the earliest lab session of your team members. Your work will be demonstrated to the class in real time, where you will present the design of your system and you will run a demo. You don’t need to submit anything.

4.	35% Due 5/14. The code should include:
Final code submitted through blackboard. The code should include:
a.	Drop table and sequence statements to drop tables if they exist (remember to use cascade constraints). 
b.	Create table statements and create sequence statements
c.	Insert statements
d.	Create procedure statements (with code for the procedures). Each feature can be implemented as one PL/SQL procedure (in the procedure you may call other procedures or functions). Please include some comments in your code explaining the major steps. You should use create or replace to avoid procedure name conflict. 
e.	Test script to show that all your features work correctly. The script should include some examples to test different cases. E.g., for feature 1, one example for new user (email is not in database) and one example for existing user (using existing email). Please include:
i.	PL/SQL script to call the appropriate PL/SQL procedure for this feature. E.g., exec procedure-name(parameter values)
ii.	Explanation of what should be the correct output. The output could be updated tables (you can have some select statement to show the updated tables), some print out, etc.
iii.	Make sure you have tested your examples from beginning to end. Remember that database tables may have been changed in the process. So you may need to start with a clean database (i.e., right after you execute all the drop table, create table, and insert statements).

Grading Guidelines

What I look for while grading software code (deliverable 4):
1.	Existence of code
2.	Comments: Both descriptive and inline for every procedure/function
3.	Software quality
a.	Whether it is correct (giving correct results).
b.	Whether it is complete and clear. 
c.	Efficiency of code. You should not use too many SQL statements, and you shoud put as much work as possible in SQL. For example, if you can do a join, do not use two select statements and then do a join in your program.
d.	Whether it has considered all special cases such as whether a user has already registered in Feature 1.

Regarding the presentation of your project: Each student must participate in the project demonstration by presenting to the entire class some slides. You will be graded on:
1.	Timeliness of presentation
2.	Presentation Style
3.	Demo (running the code)

For the demo, you will be graded on the following items:
1.	Existence of tables and data. You need to have at least 5 rows in each table.
2.	The correctness of features. This can be shown by checking whether the screen output is correct and the database has been updated correctly.

Each member of the team should contribute more or less equally. It is unfair for a few members to do most of the work while others do less. You will be asked to evaluate your teammate’s effort at the end of the project. The instructor will adjust the grade based on the evaluation. Normally if most of your teammates agree that you do not contribute at all or contribute too little (e.g., your group has 4 members and you contribute only 5%), you may lose up to 80% of your project grade. If your teammates agree that you contribute much more than anyone else (e.g., your group has 4 members and you contribute 40%), you may gain up to 20% of your project grade (but not exceeding 100% of project grade). Multiple peer evaluations will be conducted throughout the semester to determine the contribution of each team member.
