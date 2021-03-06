USE [jsroka_a]
GO
/****** Object:  View [dbo].[WorkshopPopularity]    Script Date: 2018-02-04 12:36:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[WorkshopPopularity] as 
select Conferences.ConferenceID,
		ConferenceName,
		ConferenceDays.ConferenceDayID,
		Workshops.WorkshopID,
		Workshops.WorkshopName,
		ISNULL(sum(WorkshopReservations.Quantity),0) 'PaidReservations',
		max(Workshops.Seats) as 'Seats',
		round (cast(ISNULL(sum(WorkshopReservations.Quantity),0)as float)/cast (max(Workshops.Seats) as float),2)'ReservedFraction'
from conferences
inner join ConferenceDays
on ConferenceDays.ConferenceID = Conferences.ConferenceID
inner join Workshops
on Workshops.ConferenceDayID = ConferenceDays.ConferenceDayID
left join WorkshopReservations
on  WorkshopReservations.WorkshopID = Workshops.WorkshopID
and WorkshopReservations.Paid =1 
group by Conferences.ConferenceID,
		ConferenceName,
		ConferenceDays.ConferenceDayID,
		Workshops.WorkshopID,
		Workshops.WorkshopName
GO
