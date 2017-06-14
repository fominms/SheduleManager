USE [DataBase_Shedule]
GO

/****** Object:  StoredProcedure [dbo].[p_Weeks]    Script Date: 07.06.2017 20:02:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[p_Weeks_Type]
as
begin
	select wt.Weeks_ID, wt.Name, wt.Symbol from dbo.t_Weeks_Type as wt
end
GO

