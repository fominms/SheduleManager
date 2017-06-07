USE [DataBase_Shedule]
GO

/****** Object:  StoredProcedure [dbo].[p_Institutes]    Script Date: 07.06.2017 19:57:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[p_Institutes]
as
begin
	select 
		inst.Institutes_ID, inst.Name
	from dbo.t_Institutes as inst
end
GO

