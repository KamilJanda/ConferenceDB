USE [jsroka_a]
GO
/****** Object:  StoredProcedure [dbo].[getParticipantIDForWorkshop]    Script Date: 2018-02-04 12:36:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Procedure  [dbo].[getParticipantIDForWorkshop]   
  @WorkshopID INT
AS BEGIN   
SET NOCOUNT ON; 
	If @WorkshopID is null
		Throw 51000, '@WorkshopID is null', 1
	Declare @id int 
	Select @id = (Select WorkshopID from Workshops where WorkshopID = @WorkshopID)
	IF @id is null
		Throw 51000, 'Workshop with given Id does not exist' , 1

	Select Attendee.AttendeeID, Attendee.FirstName, Attendee.LastName, isNULL(Customer.CustomerName, '') as 'Company'
	from Workshops  
	inner join WorkshopReservations 
	on WorkshopReservations.WorkshopID = Workshops.WorkshopID
	and Workshops.WorkshopID = @WorkshopID 
	and WorkshopReservations.Paid=1
	inner join WorkshopPrincipants
	on WorkshopPrincipants.WorkshopReservationID = WorkshopReservations.WorkshopReservationID
	inner join Attendee 
	on Attendee.AttendeeID = WorkshopPrincipants.AttendeeID
	left join Customer 
	on Customer.CustomerID = Attendee.CustomerID
	and Customer.isCompany = 1 


END
GO
