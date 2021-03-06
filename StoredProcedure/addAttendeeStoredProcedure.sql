USE [jsroka_a]
GO
/****** Object:  StoredProcedure [dbo].[addAttendee]    Script Date: 2018-02-04 12:36:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Procedure [dbo].[addAttendee](
	@CustomerID				int,
	@StudentIDCardNumber	int,
	@FirstName		nvarchar(20),
	@LastName		nvarchar(20),
	@Email			nvarchar(50),
	@Password		nvarchar(20)
) AS BEGIN
  SET NOCOUNT ON;  
		IF @CustomerID is null 
			THROW 51000, '@CustomerID is null', 1
		Declare @name nvarchar(50)
		Select @name =  (Select Customer.CustomerName from Customer where CustomerID = @CustomerID)
		IF @name is null 
			THROW 51000, '@Customer with given Id does not exist ', 1
		IF @FirstName is null or ltrim(@FirstName) = ''
			THROW 51000, '@FirstName is null or is empty String ', 1		
		IF @LastName is null or ltrim(@LastName) = ''
			THROW 51000, '@LastName is null or is empty String ', 1
		IF @Email is null or ltrim(@Email) = ''
			THROW 51000, '@Email is null or is empty String ', 1
		IF @Password is null or ltrim(@Password) = ''
			THROW 51000, '@Password is null or is empty String ', 1
		
		INSERT INTO Attendee(CustomerID, StudentIDCardNumber, FirstName, LastName, Email, Password)
		VALUES (@CustomerID, @StudentIDCardNumber, @FirstName, @LastName, @Email, @Password)
END  
GO
