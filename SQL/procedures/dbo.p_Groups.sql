USE [DataBase_Shedule]
GO

/****** Object:  StoredProcedure [dbo].[p_Groups]    Script Date: 07.06.2017 19:57:18 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[p_Groups]
as
begin
	select g.Groups_ID, g.Name from dbo.t_Groups as g
end
GO

