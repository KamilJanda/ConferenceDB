USE [jsroka_a]
GO
/****** Object:  View [dbo].[CustomerDebt]    Script Date: 2018-02-04 12:36:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





create view [dbo].[CustomerDebt] as 
Select CustomerName,'Conference ' as 'Type',ConferenceDays.ConferenceDayID, 
sum(dbo.totalPriceForReservation(ConferenceReservations.ConferenceReservationID)) as 'UnpaidReservationCost'
from Customer
inner join ConferenceReservations 
on Customer.CustomerID = ConferenceReservations.CustomerID 
and DATEDIFF(day,ConferenceReservations.ReservationDate, getdate()) < 7
and ConferenceReservations.Paid = 0
and ConferenceReservations.isCanceled = 0
inner join ConferenceDays 
on ConferenceDays.ConferenceDayID = ConferenceReservations.ConferenceDayID
inner join Conferences
on Conferences.ConferenceID = ConferenceDays.ConferenceID 
and Conferences.isCanceled = 0
group by CustomerName, ConferenceDays.ConferenceDayID
union 
select  CustomerName,
		'Workshop ' as 'Type',
		ConferenceDays.ConferenceDayID,
		sum(Workshops.Price * WorkshopReservations.Quantity) as 'UnpaidReservationCost'
			from WorkshopReservations
inner join ConferenceReservations 
on ConferenceReservations.ConferenceReservationID = WorkshopReservations.ConferenceReservatioID
	and ConferenceReservations.Paid = 1 
	and WorkshopReservations.Paid = 0
	and WorkshopReservations.isCanceled = 0
	and DATEDIFF(day,WorkshopReservations.ReservationDate ,getdate()) < 7 
inner join Customer 
on Customer.CustomerID = ConferenceReservations.CustomerID
inner join ConferenceDays 
on ConferenceReservations.ConferenceDayID = ConferenceDays.ConferenceDayID
inner join Workshops
on Workshops.WorkshopID = WorkshopReservations.WorkshopID
and Workshops.isCanceled = 0 
group by CustomerName, ConferenceDays.ConferenceDayID 
GO
