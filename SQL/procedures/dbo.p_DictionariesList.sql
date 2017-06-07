USE [DataBase_Shedule]
GO

/****** Object:  StoredProcedure [dbo].[p_DictionariesList]    Script Date: 07.06.2017 19:57:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[p_DictionariesList]
as 
begin
	select 
		Dictionaries_ID
		, Name
		, TableName
		, ViewName
	from dbo.t_Dictionaries
	order by Name
end
GO

