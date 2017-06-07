USE [DataBase_Shedule]
GO

/****** Object:  StoredProcedure [dbo].[p_ClassRooms]    Script Date: 07.06.2017 19:55:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[p_ClassRooms]
as
begin
	select 
		cr.ClassRooms_ID
		, cr.Name
	from dbo.t_ClassRooms as cr
end

GO

