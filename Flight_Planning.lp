% Name: Cameron Gibson
% RNumber: 
% Class: CS 4331 201
% Command to run: clingo "C:\Users\camer\OneDrive\Desktop\Planning Final\Flight_Planning.lp"
% Software: Clingo Version 5.4.0
% Initial Description:
% 	Assign 10 flight attendants to 5 flights. 
% 	Each flight needs a certain number of employees, and they have to speak certain languages.
% 	Every employee will be required to take one flight off after an attended flight.

#const number_of_flights = 5.
#const min_rest = 1. % minimum flights off after an attended flight

% Domains
flights(1..number_of_flights).

%-----------------------------------------------------------------------------------------
%  10 Flight Attendants, and the languages they speak

p(richard, 	(attendant;english;german)).
p(halsey, 	(attendant;german)).
p(cameron, 	(attendant;english)).
p(alli, 	(attendant;spanish;english)).
p(billy, 	(attendant;english;spanish)).
p(jerry, 	(attendant;spanish)).
p(rob, 		(attendant;german)).
p(jacob, 	(attendant;spanish;german)).
p(gian, 	(attendant;english)).
p(rick, 	(attendant;spanish)).

% Type of languages
langs(Lang):- p(_, Lang).

% Assigning name
person(Person):- p(Person, _).

%-----------------------------------------------------------------------------------------
% The Crew for each flight, and the number of employees needed
% crew(flight, num needed).

crew_number(1, 2).
crew_number(2, 2).
crew_number(3, 3).
crew_number(4, 1).
crew_number(5, 3).

%-----------------------------------------------------------------------------------------
% The flight number, lang, and number of Employees needed:
% flight(flight, lang, num needed)

% Flight 1
flight(1, attendant, 2).
flight(1, english, 1).
flight(1, spanish, 1).

% Flight 2
flight(2, attendant, 2).
flight(2, english, 1).
flight(2, german, 1).

% Flight 3
flight(3, attendant, 3).
flight(3, english, 1).
flight(3, spanish, 1).
flight(3, german, 1).

% Flight 4
flight(4, attendant, 1).
flight(4, spanish, 1).

% Flight 5
flight(5, attendant, 3).
flight(5, english, 1).
flight(5, spanish, 1).
flight(5, german, 1).


%-----------------------------------------------------------------------------------------
% The crew must have num persons in the crew (Has to meet exact requirement)

Num{crew(Flight, Person): person(Person)} Num:- crew_number(Flight, Num).

%-----------------------------------------------------------------------------------------
% The crew must speak the required language(s)

:- flight(Flight, Lang, Num), {crew(Flight, Person): p(Person, Lang)} Num-1.

%-----------------------------------------------------------------------------------------
% Every employee gets one flight off after an attended flight.

:- crew(Flight1, Person), 
    crew(Flight2, Person), 
    Flight2 > Flight1, 
    Flight2-Flight1 <= min_rest.

%-----------------------------------------------------------------------------------------
% A person is assigned if they are in a crew

assigned(Person): person(Person):- crew(Flight, Person). 

%-----------------------------------------------------------------------------------------
% Minimize statement from book: The statement instructs it to compute only those answer
% sets of the program that contain the smallest number of occurrencess of atoms formed 
% In this setting it will assin the minamal amount of employees.

#minimize {1,Person: assigned(Person)}.

%-----------------------------------------------------------------------------------------
% To show extra information, I've included a function to count the number of flights,
% and one to list the employees who have not been assigned. 

% Counts the number of flights for each individual employee
emp_number_of_flights(Person, N):- 
    person(Person), 
    flights(N), 
    N {crew(Flight, Person)} N.

% Lists the employees not assigned to any flights
not_assigned(Person):- person(Person), not assigned(Person).


#show crew/2.
#show not_assigned/1.
#show emp_number_of_flights/2.