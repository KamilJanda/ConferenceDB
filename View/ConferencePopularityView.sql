USE [jsroka_a]
GO
/****** Object:  View [dbo].[ConferencePopularity]    Script Date: 2018-02-04 12:36:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create view [dbo].[ConferencePopularity] as 
select Conferences.ConferenceID,
		ConferenceName,
		ConferenceDays.ConferenceDayID,
		ISNULL(sum(ConferenceReservations.Quantity),0) 'PaidReservations',
		max(ConferenceDays.Seats) as 'Seats',
		round (cast(ISNULL(sum(ConferenceReservations.Quantity),0)as float)/cast (max(ConferenceDays.Seats) as float),2)'ReservedFraction'
from conferences
inner join ConferenceDays
on ConferenceDays.ConferenceID = Conferences.ConferenceID
left join ConferenceReservations
on ConferenceReservations.ConferenceDayID = ConferenceDays.ConferenceDayID 
and ConferenceReservations.Paid = 1 
group by Conferences.ConferenceID,
		ConferenceName,
		ConferenceDays.ConferenceDayID
GO
