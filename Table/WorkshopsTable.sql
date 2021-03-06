USE [jsroka_a]
GO
/****** Object:  Table [dbo].[Workshops]    Script Date: 2018-02-04 12:36:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Workshops](
	[WorkshopID] [int] IDENTITY(1,1) NOT NULL,
	[ConferenceDayID] [int] NOT NULL,
	[WorkshopName] [nvarchar](50) NULL,
	[Seats] [int] NOT NULL,
	[StartTime] [time](7) NOT NULL,
	[EndTime] [time](7) NOT NULL,
	[isCanceled] [bit] NOT NULL,
	[Price] [smallmoney] NOT NULL,
 CONSTRAINT [PK_Workshops] PRIMARY KEY CLUSTERED 
(
	[WorkshopID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [idx_WorkshopConferenceDayIDFK]    Script Date: 2018-02-04 12:36:19 ******/
CREATE NONCLUSTERED INDEX [idx_WorkshopConferenceDayIDFK] ON [dbo].[Workshops]
(
	[ConferenceDayID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Workshops] ADD  CONSTRAINT [DF_Workshops_isCanceled]  DEFAULT ((0)) FOR [isCanceled]
GO
ALTER TABLE [dbo].[Workshops]  WITH NOCHECK ADD  CONSTRAINT [FK_Workshops_ConferenceDays] FOREIGN KEY([ConferenceDayID])
REFERENCES [dbo].[ConferenceDays] ([ConferenceDayID])
GO
ALTER TABLE [dbo].[Workshops] NOCHECK CONSTRAINT [FK_Workshops_ConferenceDays]
GO
ALTER TABLE [dbo].[Workshops]  WITH NOCHECK ADD  CONSTRAINT [WorkshopDate] CHECK  (([EndTime]>[StartTime]))
GO
ALTER TABLE [dbo].[Workshops] NOCHECK CONSTRAINT [WorkshopDate]
GO
ALTER TABLE [dbo].[Workshops]  WITH NOCHECK ADD  CONSTRAINT [WorkshopNotNegativePrice] CHECK  (([Price]>=(0)))
GO
ALTER TABLE [dbo].[Workshops] NOCHECK CONSTRAINT [WorkshopNotNegativePrice]
GO
ALTER TABLE [dbo].[Workshops]  WITH NOCHECK ADD  CONSTRAINT [WorkshopSeatsNotNegative] CHECK  (([Seats]>(0)))
GO
ALTER TABLE [dbo].[Workshops] NOCHECK CONSTRAINT [WorkshopSeatsNotNegative]
GO
ALTER TABLE [dbo].[Workshops]  WITH NOCHECK ADD  CONSTRAINT [WorkshpName] CHECK  (([WorkshopName] IS NULL OR ltrim([WorkshopName])<>''))
GO
ALTER TABLE [dbo].[Workshops] NOCHECK CONSTRAINT [WorkshpName]
GO
