USE [DataBase_Shedule]
GO

/****** Object:  StoredProcedure [dbo].[p_Days]    Script Date: 07.06.2017 19:56:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[p_Days]
as
begin
	select d.Days_ID, d.Name from dbo.t_Days as d
end
GO

