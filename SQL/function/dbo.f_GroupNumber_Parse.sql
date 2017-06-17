create function dbo.f_GroupNumber_Parse (@groupNumber varchar(max))
returns @t_Groups table (ID int identity(1,1), GroupName varchar(max))
as
begin	
	declare @numbers varchar(max) = substring(@groupNumber, charindex('-', @groupNumber) + 1, len(@groupNumber) - charindex('-', reverse(@groupNumber)) - charindex('-', @groupNumber))

	if left(@numbers, 1) = '(' set @numbers = substring(@numbers, 2, len(@numbers))
	if right(@numbers, 1) = ')' set @numbers = substring(@numbers, 1, len(@numbers) - 1)

	declare @groupName varchar(max) = left(@groupNumber, charindex('-', @groupNumber) - 1)
	declare @groupYear varchar(max) = right(@groupNumber, charindex('-', reverse(@groupNumber)) - 1)
	
	while 1 = 1 begin
		if (charindex(',', @numbers) = 0)
		begin
			declare @num varchar(max) = @numbers
			insert into @t_Groups (GroupName) select @groupName + '-' + @num + '-' + @groupYear
			break
		end
		else
		begin
			set @num = left(@numbers, charindex(',', @numbers) - 1)
			set @numbers = substring(@numbers, charindex(',', @numbers) + 1, len(@numbers))			
			insert into @t_Groups (GroupName) select @groupName + '-' + @num + '-' + @groupYear		
		end
	end
	return
end
