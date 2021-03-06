USE [jsroka_a]
GO
/****** Object:  StoredProcedure [dbo].[modifyConferencePrincipant]    Script Date: 2018-02-04 12:36:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



Create Procedure [dbo].[modifyConferencePrincipant](
	@ConferencePrincipantID int,
	@AttendeeID int 
) AS BEGIN
  SET NOCOUNT ON;  
		IF @AttendeeID is null 
			THROW 51000, '@AttendeeID is null', 1
		
		Declare @id int
		Select @id =  (Select AttendeeID from Attendee where AttendeeID = @AttendeeID)
		IF @id is null 
			THROW 51000, 'Attendee with given Id does not exist ', 1
		
		IF @ConferencePrincipantID is null 
			THROW 51000, '@ConferencePrincipantID is null', 1

		Declare @reservationID int
		Select @reservationID =  (Select ConferencePrincipants.ConferenceReservationID from ConferencePrincipants where ConferencePrincipantID = @ConferencePrincipantID)
		IF @reservationID is null 
			THROW 51000, 'ConferencePrincipant with given Id does not exist ', 1
		
		Declare @reservationCustomerID int 
		Select @reservationCustomerID = (select ConferenceReservations.CustomerID from ConferenceReservations
										inner join ConferencePrincipants on ConferencePrincipants.ConferenceReservationID = ConferenceReservations.ConferenceReservationID
										and ConferencePrincipantID = @ConferencePrincipantID)
		Declare @participantCustomerID int 
		select @participantCustomerID = (select Customerid from Attendee where @AttendeeID = AttendeeID)
		IF @participantCustomerID is not null and @reservationCustomerID <> @participantCustomerID
			THROW 51000, 'Attendee is not conected to customer whose reservation is modified', 1

		Update ConferencePrincipants
		set AttendeeID = @AttendeeID
		where ConferencePrincipantID = @ConferencePrincipantID
  
		IF 1 < (select count(ConferencePrincipants.ConferencePrincipantID) from ConferencePrincipants 
				where ConferencePrincipants.AttendeeID = @AttendeeID 
				and ConferencePrincipants.ConferenceReservationID = @reservationID)
				THROW 51000, 'Attendee is already mentioned in that reservation', 1
END  
GO
