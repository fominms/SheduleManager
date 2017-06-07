USE [DataBase_Shedule]
GO

/****** Object:  StoredProcedure [dbo].[p_Weeks]    Script Date: 07.06.2017 20:02:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[p_Weeks]
as
begin
	select w.Weeks_ID, w.Name, w.Symbol from dbo.t_Weeks as w
end
GO

