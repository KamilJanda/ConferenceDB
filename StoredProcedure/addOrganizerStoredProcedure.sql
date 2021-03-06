USE [jsroka_a]
GO
/****** Object:  StoredProcedure [dbo].[addOrganizer]    Script Date: 2018-02-04 12:36:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[addOrganizer](
    @OrganizerID int,
    @OrganizatiorName nvarchar(50),
    @Email nvarchar(50),
    @Phone nvarchar(50)
) AS
  BEGIN
      SET NOCOUNT ON;
              IF @OrganizerID is NULL
                  THROW 51000,'@OrganizerID is null',1
              IF @OrganizatiorName IS NULL  or ltrim(@OrganizatiorName)=''
                  THROW 51000,'@OrganizatiorName is null or empty String',1
              IF @Email IS NULL OR LTRIM(@Email)=''
                  THROW 51000,'@Email is null or is empty String',1
              IF @Phone IS NULL OR LTRIM(@Phone)=''
                  THROW 51000,'@Phone is null or is empty String',1

          INSERT INTO Organizers(OrganizerID,OrganizatorName,Email,Phone)
              VALUES (@OrganizerID,@OrganizatiorName,@Email,@Phone)
  END
GO
