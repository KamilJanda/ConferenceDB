USE [jsroka_a]
GO
/****** Object:  Table [dbo].[ConferenceReservations]    Script Date: 2018-02-04 12:36:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ConferenceReservations](
	[ConferenceReservationID] [int] IDENTITY(1,1) NOT NULL,
	[CustomerID] [int] NOT NULL,
	[ConferenceDayID] [int] NOT NULL,
	[Quantity] [int] NOT NULL,
	[StudentsIncluded] [int] NOT NULL,
	[Paid] [bit] NOT NULL,
	[ReservationDate] [smalldatetime] NOT NULL,
	[isCanceled] [bit] NOT NULL,
 CONSTRAINT [PK_ConferenceReservations] PRIMARY KEY CLUSTERED 
(
	[ConferenceReservationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [idx_ConferenceReservationCustomerIDFK]    Script Date: 2018-02-04 12:36:19 ******/
CREATE NONCLUSTERED INDEX [idx_ConferenceReservationCustomerIDFK] ON [dbo].[ConferenceReservations]
(
	[CustomerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_ConferenceReservationDayIDFK]    Script Date: 2018-02-04 12:36:19 ******/
CREATE NONCLUSTERED INDEX [idx_ConferenceReservationDayIDFK] ON [dbo].[ConferenceReservations]
(
	[ConferenceDayID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ConferenceReservations] ADD  CONSTRAINT [DF_ConferenceReservations_Paid]  DEFAULT ((0)) FOR [Paid]
GO
ALTER TABLE [dbo].[ConferenceReservations] ADD  CONSTRAINT [DF_ConferenceReservations_ReservationDate]  DEFAULT (getdate()) FOR [ReservationDate]
GO
ALTER TABLE [dbo].[ConferenceReservations] ADD  DEFAULT ((0)) FOR [isCanceled]
GO
ALTER TABLE [dbo].[ConferenceReservations]  WITH NOCHECK ADD  CONSTRAINT [FK_ConferenceReservations_ConferenceDays] FOREIGN KEY([ConferenceDayID])
REFERENCES [dbo].[ConferenceDays] ([ConferenceDayID])
GO
ALTER TABLE [dbo].[ConferenceReservations] NOCHECK CONSTRAINT [FK_ConferenceReservations_ConferenceDays]
GO
ALTER TABLE [dbo].[ConferenceReservations]  WITH NOCHECK ADD  CONSTRAINT [FK_ConferenceReservations_Customer] FOREIGN KEY([CustomerID])
REFERENCES [dbo].[Customer] ([CustomerID])
GO
ALTER TABLE [dbo].[ConferenceReservations] NOCHECK CONSTRAINT [FK_ConferenceReservations_Customer]
GO
ALTER TABLE [dbo].[ConferenceReservations]  WITH NOCHECK ADD  CONSTRAINT [CK_ConferenceReservations] CHECK  (([ReservationDate]<dateadd(hour,(1),getdate()) AND [ReservationDate]>dateadd(hour,(-1),getdate())))
GO
ALTER TABLE [dbo].[ConferenceReservations] NOCHECK CONSTRAINT [CK_ConferenceReservations]
GO
ALTER TABLE [dbo].[ConferenceReservations]  WITH NOCHECK ADD  CONSTRAINT [ConferenceStudentsIncluded] CHECK  (([StudentsIncluded]>=(0) AND [StudentsIncluded]<=[Quantity]))
GO
ALTER TABLE [dbo].[ConferenceReservations] NOCHECK CONSTRAINT [ConferenceStudentsIncluded]
GO
ALTER TABLE [dbo].[ConferenceReservations]  WITH NOCHECK ADD  CONSTRAINT [PaidAndCanceledConference] CHECK  ((([isCanceled]&[Paid])=(0)))
GO
ALTER TABLE [dbo].[ConferenceReservations] NOCHECK CONSTRAINT [PaidAndCanceledConference]
GO
ALTER TABLE [dbo].[ConferenceReservations]  WITH NOCHECK ADD  CONSTRAINT [ReservationNotNegativeQuantity] CHECK  (([Quantity]>(0)))
GO
ALTER TABLE [dbo].[ConferenceReservations] NOCHECK CONSTRAINT [ReservationNotNegativeQuantity]
GO
/****** Object:  Trigger [dbo].[CheckConferenceReservationAvailableBasicPrice]    Script Date: 2018-02-04 12:36:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[CheckConferenceReservationAvailableBasicPrice] ON [dbo].[ConferenceReservations]
AFTER INSERT, UPDATE 
AS 
IF Exists (Select  * from ConferenceReservations
				inner join ConferenceDays
				on ConferenceDays.ConferenceDayID = ConferenceReservations.ConferenceDayID
				left join Prices
				on Prices.ConferenceDayID = ConferenceDays.ConferenceDayID
				and Prices.DaysToConference = 0
				where PriceID is null
				)
BEGIN 
RAISERROR ('There is a reservation on Conference without Basic price (0 days to conference)', 16, 1); 
ROLLBACK TRANSACTION; 
RETURN  
END; 
GO
ALTER TABLE [dbo].[ConferenceReservations] ENABLE TRIGGER [CheckConferenceReservationAvailableBasicPrice]
GO
/****** Object:  Trigger [dbo].[CheckConferenceReservationQuantity]    Script Date: 2018-02-04 12:36:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[CheckConferenceReservationQuantity] ON [dbo].[ConferenceReservations]  
AFTER INSERT, UPDATE  
AS  
IF Exists (Select ConferenceDays.ConferenceDayID,
				  ConferenceDays.Seats,
				  sum(ConferenceReservations.Quantity) 
			from ConferenceReservations
			inner join ConferenceDays 
			on ConferenceDays.ConferenceDayID = ConferenceReservations.ConferenceDayID
			and DATEDIFF(day, ConferenceReservations.ReservationDate, getdate()) < 7 
			and ConferenceReservations.isCanceled = 0
			group by ConferenceDays.ConferenceDayID,
					 ConferenceDays.Seats
			having  ConferenceDays.Seats < sum(ConferenceReservations.Quantity)  )

BEGIN  
RAISERROR ('Conference Reservation have greater quantity than available', 16, 1);  
ROLLBACK TRANSACTION;  
RETURN   
END;  
GO
ALTER TABLE [dbo].[ConferenceReservations] ENABLE TRIGGER [CheckConferenceReservationQuantity]
GO
