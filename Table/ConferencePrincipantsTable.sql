USE [jsroka_a]
GO
/****** Object:  Table [dbo].[ConferencePrincipants]    Script Date: 2018-02-04 12:36:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ConferencePrincipants](
	[ConferencePrincipantID] [int] IDENTITY(1,1) NOT NULL,
	[ConferenceReservationID] [int] NOT NULL,
	[AttendeeID] [int] NULL,
 CONSTRAINT [PK_ConferencePrincipants] PRIMARY KEY CLUSTERED 
(
	[ConferencePrincipantID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [idx_ConferenceAttendeeIDFK]    Script Date: 2018-02-04 12:36:19 ******/
CREATE NONCLUSTERED INDEX [idx_ConferenceAttendeeIDFK] ON [dbo].[ConferencePrincipants]
(
	[AttendeeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_ConferenceReservationIDFK]    Script Date: 2018-02-04 12:36:19 ******/
CREATE NONCLUSTERED INDEX [idx_ConferenceReservationIDFK] ON [dbo].[ConferencePrincipants]
(
	[ConferenceReservationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ConferencePrincipants]  WITH NOCHECK ADD  CONSTRAINT [FK_ConferencePrincipants_Atendee] FOREIGN KEY([AttendeeID])
REFERENCES [dbo].[Attendee] ([AttendeeID])
GO
ALTER TABLE [dbo].[ConferencePrincipants] NOCHECK CONSTRAINT [FK_ConferencePrincipants_Atendee]
GO
ALTER TABLE [dbo].[ConferencePrincipants]  WITH NOCHECK ADD  CONSTRAINT [FK_ConferencePrincipants_ConferenceReservations] FOREIGN KEY([ConferenceReservationID])
REFERENCES [dbo].[ConferenceReservations] ([ConferenceReservationID])
GO
ALTER TABLE [dbo].[ConferencePrincipants] NOCHECK CONSTRAINT [FK_ConferencePrincipants_ConferenceReservations]
GO
/****** Object:  Trigger [dbo].[CheckConferenceRegistrationAttendeDuplicate]    Script Date: 2018-02-04 12:36:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[CheckConferenceRegistrationAttendeDuplicate] ON [dbo].[ConferencePrincipants]  
AFTER INSERT, UPDATE  
AS  
IF Exists (Select ConferenceReservations.CustomerID,
				ConferenceReservations.ConferenceDayID,
				ConferencePrincipants.AttendeeID,
				count(ConferencePrincipants.AttendeeID)
			from ConferenceReservations
			inner join ConferencePrincipants
			on ConferencePrincipants.ConferenceReservationID = ConferenceReservations.ConferenceReservationID
			group by ConferenceReservations.CustomerID,
				ConferenceReservations.ConferenceDayID,
				ConferencePrincipants.AttendeeID
			having count(ConferencePrincipants.ConferencePrincipantID) > 1 )
BEGIN  
RAISERROR ('Participant were signed multiple times to same ConferenceDay', 16, 1);  
ROLLBACK TRANSACTION;  
RETURN   
END;  
GO
ALTER TABLE [dbo].[ConferencePrincipants] ENABLE TRIGGER [CheckConferenceRegistrationAttendeDuplicate]
GO
/****** Object:  Trigger [dbo].[CheckConferenceRegistrationCustomerCompatibility]    Script Date: 2018-02-04 12:36:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[CheckConferenceRegistrationCustomerCompatibility] ON [dbo].[ConferencePrincipants]  
AFTER INSERT, UPDATE  
AS  
IF Exists (Select ConferenceReservations.CustomerID,
					Attendee.CustomerID
			from ConferenceReservations
			inner join ConferencePrincipants
			on ConferencePrincipants.ConferenceReservationID = ConferenceReservations.ConferenceReservationID
			inner join Attendee 
			on Attendee.AttendeeID = ConferencePrincipants.AttendeeID
			and Attendee.CustomerID is not null
			where Attendee.CustomerID <> ConferenceReservations.CustomerID)
BEGIN  
RAISERROR ('Participant were signed to other customer reservation', 16, 1);  
ROLLBACK TRANSACTION;  
RETURN   
END;  
GO
ALTER TABLE [dbo].[ConferencePrincipants] ENABLE TRIGGER [CheckConferenceRegistrationCustomerCompatibility]
GO
/****** Object:  Trigger [dbo].[CheckConferenceRegistrationCustomerPayment]    Script Date: 2018-02-04 12:36:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[CheckConferenceRegistrationCustomerPayment] ON [dbo].[ConferencePrincipants]  
AFTER INSERT, UPDATE  
AS  
IF Exists (Select ConferenceReservations.CustomerID,
				ConferenceReservations.Paid
			from ConferenceReservations
			inner join ConferencePrincipants
			on ConferencePrincipants.ConferenceReservationID = ConferenceReservations.ConferenceReservationID
			where ConferenceReservations.Paid = 0)
BEGIN  
RAISERROR ('Participant were signed to unpaid reservation', 16, 1);  
ROLLBACK TRANSACTION;  
RETURN   
END;  
GO
ALTER TABLE [dbo].[ConferencePrincipants] ENABLE TRIGGER [CheckConferenceRegistrationCustomerPayment]
GO
/****** Object:  Trigger [dbo].[CheckConferenceRegistrationQuantity]    Script Date: 2018-02-04 12:36:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[CheckConferenceRegistrationQuantity] ON [dbo].[ConferencePrincipants]  
AFTER INSERT, UPDATE  
AS  
IF Exists (Select ConferenceReservations.ConferenceReservationID,
					ConferenceReservations.Quantity,
					count(ConferencePrincipants.ConferencePrincipantID)
			from ConferenceReservations
			inner join ConferencePrincipants
			on ConferencePrincipants.ConferenceReservationID = ConferenceReservations.ConferenceReservationID
			group by ConferenceReservations.ConferenceReservationID,
					ConferenceReservations.Quantity
					having  ConferenceReservations.Quantity < count(ConferencePrincipants.ConferencePrincipantID) )
BEGIN  
RAISERROR ('There are more Participants than paid reservations', 16, 1);  
ROLLBACK TRANSACTION;  
RETURN   
END;  
GO
ALTER TABLE [dbo].[ConferencePrincipants] ENABLE TRIGGER [CheckConferenceRegistrationQuantity]
GO
/****** Object:  Trigger [dbo].[CheckConferenceRegistrationStudentsQuantity]    Script Date: 2018-02-04 12:36:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[CheckConferenceRegistrationStudentsQuantity] ON [dbo].[ConferencePrincipants]  
AFTER INSERT, UPDATE  
AS  
IF Exists (Select ConferenceReservations.ConferenceReservationID,
					ConferenceReservations.Quantity  - ConferenceReservations.StudentsIncluded ,
					count(ConferencePrincipants.ConferencePrincipantID)
			from ConferenceReservations
			inner join ConferencePrincipants
			on ConferencePrincipants.ConferenceReservationID = ConferenceReservations.ConferenceReservationID
			inner join Attendee 
			on Attendee.AttendeeID = ConferencePrincipants.AttendeeID
			and Attendee.StudentIDCardNumber is null
			group by ConferenceReservations.ConferenceReservationID,
					ConferenceReservations.Quantity,
					ConferenceReservations.StudentsIncluded
					having  (ConferenceReservations.Quantity  - ConferenceReservations.StudentsIncluded )< count(ConferencePrincipants.ConferencePrincipantID) )
BEGIN  
RAISERROR ('There are too much participants without StudentIDCardNumber but there is still
available room for students participants', 16, 1);  
ROLLBACK TRANSACTION;  
RETURN   
END;  
GO
ALTER TABLE [dbo].[ConferencePrincipants] ENABLE TRIGGER [CheckConferenceRegistrationStudentsQuantity]
GO
