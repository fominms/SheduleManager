create procedure [dbo].[p_Form_Parse] @FilePath varchar(max), @FileBinary varbinary(max) = null
as
begin
	-- {���� ����������� �� Microsoft SQL Server Management Studio, �� ������� ���������} 
	if app_name() like '%Microsoft SQL Server Management Studio%' declare @_debug bit = 1	
	
	begin try
		-- {������� ��� �����} 
		declare @FileName varchar(1024) = right(@FilePath, charindex('\', reverse(@FilePath))-1)

		-- {�������� ����}
		declare @ErrorMessage varchar(max)	

		-- {������� ���� � �������} 
		insert into dbo.t_Files (Name, Date, FileData) select @FileName, getdate(), @FileBinary 
		declare @Files_ID int = scope_identity()

		-- {���������� ��������� ������� �� �����} 
		if object_id('tempdb..#t_form') is not null drop table #t_form

		-- {������� ���� Excel � �������� �������}
		if (exists(select 1 from sys.servers where name = 'XlsLnkSrv')) exec sp_dropserver @server = 'XlsLnkSrv', @droplogins = 'droplogins'
		exec sp_addlinkedserver @server = 'XlsLnkSrv', @srvproduct = 'ACE 12.0', @provider = 'Microsoft.ACE.OLEDB.12.0', @datasrc = @FilePath, @provstr = 'Excel 12.0; HDR=No; IMEX=1;'

		-- {������� ���������� �� Excel �� ��������� �������}
		select * into #t_form from openquery (XlsLnkSrv, 'select * from [����1$]')
		
		-- {������ ���������� ������� �� ��������� �������} 
		declare @_countColumns int = (select count(*) from tempdb.sys.columns where object_id = object_id('tempdb..#t_form')) 
		if (@_debug = 1) raiserror('# ���������� ������� �� ��������� �������: %i', 0, 1, @_countColumns)

		-- {������� ���� id} 
		alter table #t_form add id int identity(1,1)












		
		if object_id('tempdb..#t_form') is not null drop table #t_form
		if (@@trancount > 0) commit
	end try
	begin catch
		if (@@trancount > 0) rollback
		set @ErrorMessage = error_message() 
		raiserror('%s', 16, 1, @ErrorMessage)
		return -1
	end catch
end