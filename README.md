# ConferenceDB

## System Responsibilities
1. provide Database system to store data related with conference managment.
2. provide user safe views of data.
3. provide easy way to register on conferences and workshops.
4. provide data about repayment when conference/workshop is canceled.

## Buisness Logic
1. Company organizes conferences(few days each).
2. Each conference day include workshops.
3. Customer can reserve tickets for his employees.
4. Employee can take part in workshop only if the ticket for conference were payed.
5. Conference ticket prices are dependent on the time left to first day of conference.
6. Ticket for workshop can bee free, or the cost of ticket is time-independent(constant for each workshop).
7. Unpayed reservation after 7 days is considered canceled.
8. Reservation can be canceled by cutomer but data about it should be stored in DB.
9. Customer can not reserve place for attendee who is not his employee.
