USE [jsroka_a]
GO
/****** Object:  StoredProcedure [dbo].[cancelConference]    Script Date: 2018-02-04 12:36:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


Create Procedure [dbo].[cancelConference](
	@ConferenceID int
) AS BEGIN
  SET NOCOUNT ON;  
	BEGIN TRY
		BEGIN TRANSACTION;
		IF @ConferenceID is null 
			THROW 51000, '@ConferenceID is null', 1
		
		Declare @id int
		Select @id =  (Select ConferenceID from Conferences where ConferenceID = @ConferenceID and isCanceled = 0)
		IF @id is null 
			THROW 51000, 'ConferenceID with given Id does not exist ', 1
		
		Declare @date smalldatetime
		Select @date =  (Select min(StartDate) from ConferenceDays
						inner join Conferences on Conferences.ConferenceID = ConferenceDays.ConferenceID
						 where Conferences.ConferenceID = @ConferenceID)
		IF @date < getDate()  
			THROW 51000, 'Could not cancel conference that have already started or had ended', 1

		Update Conferences
		set isCanceled =  1
		where ConferenceID = @ConferenceID

		Update Workshops
		set isCanceled = 1
		where ConferenceDayID in (select ConferenceDayID from ConferenceDays where ConferenceID = @ConferenceID )
  
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH 
		ROLLBACK TRANSACTION;
		THROW   
	END CATCH 
END  
GO
