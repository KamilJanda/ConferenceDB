USE [jsroka_a]
GO
/****** Object:  StoredProcedure [dbo].[addConference]    Script Date: 2018-02-04 12:36:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



Create Procedure [dbo].[addConference](
	@ConferenceName	nvarchar(50),
	@OrganizerID	int	
) AS BEGIN
  SET NOCOUNT ON;  
		Declare @name nvarchar(50)
		Select @name =  (Select Organizers.OrganizatorName from Organizers where OrganizerID = @OrganizerID)
		IF @name is null and @OrganizerId is not null 
			THROW 51000, 'Organizer with given Id does not exist ', 1
		IF @ConferenceName is not null and ltrim(@ConferenceName) = ''
			THROW 51000, '@ConferenceName is empty String ', 1
		
		INSERT INTO Conferences(ConferenceName, OrganizerID)
		VALUES (@ConferenceName, @OrganizerID)
END  
GO
