USE [DataBase_Shedule]
GO

/****** Object:  StoredProcedure [dbo].[p_Semestrs]    Script Date: 07.06.2017 19:59:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[p_Semestrs]
as
begin
	select sem.Semestrs_ID, sem.Name from dbo.t_Semestrs as sem
end
GO

