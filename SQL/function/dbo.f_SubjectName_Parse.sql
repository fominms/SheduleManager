USE [DataBase_Shedule]
GO

/****** Object:  UserDefinedFunction [dbo].[f_SubjectName_Parse]    Script Date: 11.06.2017 22:53:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER function [dbo].[f_SubjectName_Parse] (@subjectName varchar(max))
returns @t_WeeksNumbers table (SubjectName varchar(max), Number int)
as begin
	set @subjectName = replace(replace(@subjectName, char(10), ''), char(13), ' ')

	while charindex(' Н. ', upper(@subjectName)) > 0 begin
		declare @index int = charindex(' Н. ', upper(@subjectName))
		declare @numbers varchar(max) = left(@subjectName, @index)
		set @subjectName = substring(@subjectName, @index+3, len(@subjectName))

		declare @lenNumbers int = len(@numbers)
		declare @num varchar(max) = ''
		while (@lenNumbers >= 0) begin										
			declare @s varchar(max) = left(@numbers, 1)
			set @numbers = substring(@numbers, 2, len(@numbers))
			if (isnumeric(@s) = 1) and (@s <> ',') set @num += @s
			else 
			begin 
				if (len(@num) > 0)  
				begin
					insert into @t_WeeksNumbers (Number) select cast(@num as int)
					set @num = ''
				end
			end
			set @lenNumbers = @lenNumbers - 1
		end	
	end
	update @t_WeeksNumbers set SubjectName = @subjectName
	return
end









GO

