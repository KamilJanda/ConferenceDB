USE [jsroka_a]
GO
/****** Object:  Table [dbo].[Customer]    Script Date: 2018-02-04 12:36:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customer](
	[CustomerID] [int] IDENTITY(1,1) NOT NULL,
	[CustomerName] [nvarchar](50) NOT NULL,
	[Country] [nvarchar](50) NOT NULL,
	[City] [nvarchar](50) NOT NULL,
	[Address] [nvarchar](50) NOT NULL,
	[Phone] [nchar](10) NULL,
	[isCompany] [bit] NOT NULL,
	[NIP] [nchar](10) NULL,
 CONSTRAINT [PK_Customer] PRIMARY KEY CLUSTERED 
(
	[CustomerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Customer]  WITH CHECK ADD  CONSTRAINT [address] CHECK  ((ltrim([address])<>''))
GO
ALTER TABLE [dbo].[Customer] CHECK CONSTRAINT [address]
GO
ALTER TABLE [dbo].[Customer]  WITH CHECK ADD  CONSTRAINT [City] CHECK  ((ltrim([City])<>''))
GO
ALTER TABLE [dbo].[Customer] CHECK CONSTRAINT [City]
GO
ALTER TABLE [dbo].[Customer]  WITH CHECK ADD  CONSTRAINT [Country] CHECK  ((ltrim([Country])<>''))
GO
ALTER TABLE [dbo].[Customer] CHECK CONSTRAINT [Country]
GO
ALTER TABLE [dbo].[Customer]  WITH CHECK ADD  CONSTRAINT [Name] CHECK  ((ltrim([CustomerName])<>''))
GO
ALTER TABLE [dbo].[Customer] CHECK CONSTRAINT [Name]
GO
ALTER TABLE [dbo].[Customer]  WITH CHECK ADD  CONSTRAINT [NIP] CHECK  (([NIP] IS NULL OR [NIP] like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'))
GO
ALTER TABLE [dbo].[Customer] CHECK CONSTRAINT [NIP]
GO
ALTER TABLE [dbo].[Customer]  WITH CHECK ADD  CONSTRAINT [PhoneNumber] CHECK  (([phone] IS NULL OR isnumeric([Phone])=(1)))
GO
ALTER TABLE [dbo].[Customer] CHECK CONSTRAINT [PhoneNumber]
GO
