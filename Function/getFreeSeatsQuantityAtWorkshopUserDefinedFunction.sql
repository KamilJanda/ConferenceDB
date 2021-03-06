USE [jsroka_a]
GO
/****** Object:  UserDefinedFunction [dbo].[getFreeSeatsQuantityAtWorkshop]    Script Date: 2018-02-04 12:36:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[getFreeSeatsQuantityAtWorkshop](@WorkshopID int)
 RETURNS int
 BEGIN
   DECLARE @ret int
   DECLARE @isCancelled int
   SELECT @isCancelled=Workshops.isCanceled
   FROM Workshops
   WHERE Workshops.WorkshopID=@WorkshopID

   IF @isCancelled=1
     BEGIN
       RETURN NULL
     END
   ELSE
     BEGIN

   SELECT @ret=Workshops.Seats- (SELECT sum(Quantity)
                       FROM WorkshopReservations
                       WHERE datediff(DAY, WorkshopReservations.ReservationDate,getdate()) < 7 and
                             WorkshopReservations.isCanceled = 0 and WorkshopReservations.WorkshopID=Workshops.WorkshopID
   )
   FROM Workshops
   WHERE Workshops.WorkshopID=@WorkshopID
     END
   RETURN @ret
 END
GO
