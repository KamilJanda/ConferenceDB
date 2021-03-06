USE [jsroka_a]
GO
/****** Object:  View [dbo].[WorkshopCanceledRepayment]    Script Date: 2018-02-04 12:36:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[WorkshopCanceledRepayment] AS 
SELECT Customer.CustomerID,CustomerName, Price*WorkshopReservations.Quantity as repayment
FROM Customer
INNER JOIN ConferenceReservations
  ON Customer.CustomerID = ConferenceReservations.CustomerID
INNER JOIN WorkshopReservations
  ON ConferenceReservations.ConferenceReservationID = WorkshopReservations.ConferenceReservatioID
INNER JOIN Workshops
  ON WorkshopReservations.WorkshopID = Workshops.WorkshopID
WHERE Workshops.isCanceled=1 and datediff(DAY,WorkshopReservations.reservationDate,Workshops.StartTime)<7 and WorkshopReservations.Paid=1
GO
