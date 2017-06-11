USE [DataBase_Shedule]
GO

/****** Object:  Table [dbo].[t_Weeks_Number]    Script Date: 11.06.2017 22:54:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[t_Weeks_Number](
	[Weeks_Number_ID] [int] IDENTITY(1,1) NOT NULL,
	[Shedules_Detail_ID] [int] NULL,
	[Number] [int] NULL
) ON [PRIMARY]

GO

