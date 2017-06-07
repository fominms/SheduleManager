USE [DataBase_Shedule]
GO

/****** Object:  StoredProcedure [dbo].[p_Teachers]    Script Date: 07.06.2017 20:02:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[p_Teachers]
as
begin
	select t.Teachers_ID, t.Name from dbo.t_Teachers as t
end
GO

