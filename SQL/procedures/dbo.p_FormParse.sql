alter procedure dbo.p_Form_Parse (@FilePath varchar(max), @FileBinary varbinary(max) = null, @Academic_Years_ID int)
as 
begin
	set nocount on

	begin try
		-- {���� ����������� �� Microsoft SQL Server Management Studio, �� ������� ���������} 
 		if app_name() like '%Microsoft SQL Server Management Studio%' declare @_debug bit = 1	 	

		-- {������� ��� �����} 
		declare @FileName varchar(1024) = right(@FilePath, charindex('\', reverse(@FilePath))-1)
		raiserror('#	��� �����: %s', 0, 1, @FileName) with nowait
			
		-- {������� ���� � �������}
		insert into dbo.t_Files (Name, Date, FileData) select @FileName, getdate(), @FileBinary 
		declare @Files_ID int = scope_identity()

		-- {�������� ��������� �������} 
		if object_id('tempdb..#form') is not null drop table #form

		-- {������� ���� Excel � �������� �������}
		begin try
			if (exists(select 1 from sys.servers where name = 'XlsLnkSrv')) exec master.dbo.sp_dropserver @server = 'XlsLnkSrv', @droplogins = 'droplogins'
			exec master.dbo.sp_addlinkedserver @server = 'XlsLnkSrv', @srvproduct = 'ACE 12.0', @provider = 'Microsoft.ACE.OLEDB.12.0', @datasrc = @FilePath, @provstr = 'Excel 12.0; HDR=No; IMEX=1;'
		end try
		begin catch
			declare @errorMessage varchar(max) = error_message()
			raiserror('������ ��� ����������� Excel �����: %s', 16, 1) with nowait
		end catch

		-- {������� ������ �� Excel ����� �� ��������� �������}
		begin try
			raiserror('#	������ ������ �� Excel ����� �� ��������� �������', 0, 1) with nowait
			select * into #form from openquery (XlsLnkSrv, 'select F1, F2, F3, F4, F5, F6, F7, F8, F19 from [�101$]')	
		end try
		begin catch
			set @errorMessage = error_message()
			raiserror('������ ��� ������ Excel �����: %s', 16, 1) with nowait
		end catch

		-- {������� � ������� ���� id} 
		alter table #form add id int identity(1,1)

		-- {������ �������� ������}
		raiserror('#	�������� �������� �����', 0, 1) with nowait
		delete from #form where id = 1

		-- {�������� ��������� ������� ��� ������ �����}
		if object_id('tempdb..#t_form') is not null drop table #t_form
		create table #t_form (
			id				int identity(1,1)
			, kursNumber	int
			, semestr		int
			, groupName		varchar(max)
			, subjectName	varchar(max)
			, cafedra		varchar(max)
			, lectionCount	numeric(5,2)
			, laboryCount	numeric(5,2)
			, practiceCount numeric(5,2)
			, groupsCount	numeric(5,2)
			, practiceType  varchar(8))							
		
		declare
			@id			 int
		, @kursNumber	 varchar(max)
		, @semestr		 varchar(max)
		, @groupName	 varchar(max)
		, @subjectName	 varchar(max)
		, @cafedra		 varchar(max)
		, @lectionCount	 varchar(max)
		, @laboryCount	 varchar(max)
		, @practiceCount varchar(max)
		, @groupsCount	 varchar(max)
		, @practiceType	 varchar(8)

		-- {�������� ���� �� ������� � ��������������� ������� �����}
		raiserror('#	��������� ������', 0, 1) with nowait
		declare curForm cursor for select F1, F2, F3, F4, F5, F6, F7, F8, F19, id from #form
		open curForm
		while 1 = 1 begin
			fetch next from curForm into
				@kursNumber
				, @semestr
				, @groupName
				, @subjectName
				, @cafedra
				, @lectionCount
				, @laboryCount
				, @practiceCount
				, @groupsCount
				, @id
			if (@@fetch_status <> 0) break

			set @practiceType = ''

			-- {��� ���������� � ����� ���������� ������� �������� ������}
			set @lectionCount = replace(@lectionCount, ',', '.')
			set @laboryCount = replace(@laboryCount, ',', '.')
			set @practiceCount = replace(@practiceCount, ',', '.')
			set @groupsCount = replace(@groupsCount, ',', '.')

			-- {��������� ��� �������� �� ������������ ��������}
			if (charindex('�', @practiceCount) > 0)
			begin
				set @practiceType = '�'
				set @practiceCount = replace(@practiceCount, '�', '')
			end 

			-- {������� ������ ����� �� ��������� �������}
			insert into #t_form (kursNumber, semestr, groupName, subjectName, cafedra, lectionCount, laboryCount, practiceCount, groupsCount, practiceType)
			select 
				cast(@kursNumber as int)
				, cast(@semestr as int)
				, gn.GroupName
				, @subjectName
				, @cafedra
				, cast(@lectionCount as numeric(5,2))
				, cast(@laboryCount as numeric(5,2))
				, cast(@practiceCount as numeric(5,2))
				, cast(@groupsCount as numeric(5,2))
				, @practiceType
			from dbo.f_GroupNumber_Parse(@groupName) as gn							
		end
		close curForm
		deallocate curForm
	
		raiserror('#	������ ����������, ������ ���������� � ��', 0, 1) with nowait
		set @cafedra = (select top 1 cafedra from #t_form)
		if (exists(select top 1 1 from dbo.t_Cafedra where Cafedra_Name = @cafedra))
		begin
			declare @Cafedra_ID int = (select top 1 Cafedra_ID from dbo.t_Cafedra where Cafedra_Name = @cafedra)
		end
		else
		begin
			insert into dbo.t_Cafedra (Cafedra_Name) select @cafedra
			set @Cafedra_ID = scope_identity()
		end	

		-- {������ ���������� � �����}
		begin try
			insert into dbo.t_Forms (Files_ID, Academic_Years_ID, Cafedra_ID) select @Files_ID, @Academic_Years_ID, @Cafedra_ID
			declare @Form_ID int = scope_identity()

			declare curFormDetail cursor for
				select 
					t.kursNumber 
					, t.semestr
					, t.groupName
					, t.subjectName
					, t.lectionCount
					, t.laboryCount
					, t.practiceCount
					, t.practiceType
				from #t_form as t
			open curFormDetail
			while 1 = 1 begin
				fetch next from curFormDetail into
					@kursNumber, @semestr, @groupName, @subjectName, @lectionCount, @laboryCount, @practiceCount, @practiceType
				if (@@fetch_status <> 0) break
		
				if (exists(select top 1 1 from dbo.t_Groups where upper(Name) = upper(@groupName)))
				begin
					declare @Groups_ID int = (select top 1 Groups_ID from dbo.t_Groups where upper(Name) = upper(@groupName))
				end
				else
				begin
					insert into dbo.t_Groups (Name) select @groupName
					set @Groups_ID = scope_identity()
				end

				if (exists(select top 1 1 from dbo.t_Subjects where upper(Name) = upper(@subjectName)))
				begin
					declare @Subjects_ID int = (select top 1 Subjects_ID from dbo.t_Subjects where upper(Name) = upper(@subjectName))
				end
				else
				begin
					insert into dbo.t_Subjects(Name) select @subjectName
					set @Subjects_ID = scope_identity()
				end

				insert into dbo.t_Forms_Detail (Form_ID, Kurs, Semestr, Groups_ID, Subjects_ID, Lection_Count, Labory_Count, Practice_Count, Practice_Type)
				select @Form_ID, @kursNumber, @semestr, @Groups_ID, @Subjects_ID, cast(@lectionCount as numeric(5,2)), cast(@laboryCount as numeric(5,2)), cast(@practiceCount as numeric(5,2)), @practiceType
			end
			close curFormDetail
			deallocate curFormDetail
		end try
		begin catch
			set @errorMessage = error_message()
			raiserror('������ ��� ������ ���������� � ��: %s', 16, 1, @errorMessage) with nowait
		end catch

		-- {�������� ��������� ������}
		if object_id('tempdb..#t_form') is not null drop table #t_form
		if object_id('tempdb..#form') is not null drop table #form

		raiserror('�������� ����� ����� 101 ���������', 0, 1) with nowait
		if (@@trancount > 0) commit
	end try
	begin catch
		set @errorMessage = error_message()
		if (@@trancount > 0) rollback
		-- {�������� ��������� ������}
		if object_id('tempdb..#t_form') is not null drop table #t_form
		if object_id('tempdb..#form') is not null drop table #form
		raiserror('%s', 16, 1) with nowait
	end catch
end