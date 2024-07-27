set nocount on;
go

drop function if exists [dbo].[[]]];
go
create function [dbo].[[]]](
	@name sysname
)
returns sysname
as
begin
	return replace(@name, ']', ']]')
end;
go

drop function if exists [dbo].[bitset];
go
create function [dbo].[bitset](
	@flags bigint,
	@flag bigint
)
returns bit
as
begin
	if @flag = @flag & @flags
		return 1;
	return 0;
end;
go

drop function if exists [dbo].[schema_exists];
go
create function [dbo].[schema_exists](@name sysname)
returns bit
as
begin
	if exists (select top 1 0 from sys.schemas where name = @name)
		return 1;
	return 0;
end;
go

drop procedure if exists [dbo].[schema_ensure];
go
create procedure [dbo].[schema_ensure]
	@name sysname
as
set nocount on;
if 0 = [dbo].[schema_exists](@name)
begin
	declare @sql nvarchar(max) = 'create schema [' + [dbo].[[]]](@name) + '];'
	exec sp_sqlexec @sql;
end;
go

drop function if exists [dbo].[function_exists];
go
create function [dbo].[function_exists](
	@schema_name sysname,
	@function_name sysname
)
returns bit
as
begin
	if exists (select top 1 0 from sys.objects where name = @function_name and schema_id = schema_id(@schema_name) and type = 'FN')
		return 1;
	return 0;
end;
go

drop function if exists [dbo].[procedure_exists];
go
create function [dbo].[procedure_exists](
	@schema_name sysname,
	@procedure_name sysname
)
returns bit
as
begin
	if exists (select top 1 0 from sys.procedures where name = @procedure_name and schema_id = schema_id(@schema_name))
		return 1;
	return 0;
end;
go

drop function if exists [dbo].[table_exists];
go
create function [dbo].[table_exists]
(
    @schema_name sysname,
    @table_name sysname
)
returns bit
begin
    if exists (
        select
            top 1
            0
        from
            sys.schemas s
        inner join
            sys.tables t
            on t.schema_id = s.schema_id
		where
			s.name = @schema_name
		and
			t.name = @table_name
    )
        return 1;
    return 0;
end;
go

drop function if exists [dbo].[column_exists];
go
create function [dbo].[column_exists]
(
    @schema_name sysname,
    @table_name sysname,
    @column_name sysname
)
returns bit
begin
    if exists (
        select
            top 1
            0
        from
            sys.schemas s
        inner join
            sys.tables t
            on t.schema_id = s.schema_id
        inner join
            sys.columns c
            on c.object_id = t.object_id
		where
			s.name = @schema_name
		and
			t.name = @table_name
		and
			c.name = @column_name
    )
        return 1;
    return 0;
end;
go