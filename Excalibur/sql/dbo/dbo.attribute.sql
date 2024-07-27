set nocount on;
go

if 0 = [dbo].[table_exists]('dbo', 'attribute_type')
begin
	-- drop table [dbo].[attribute_type];
	create table [dbo].[attribute_type]
	(
		[id] int not null,
		constraint [PK [dbo]].[attribute_type]]([id]])]
			primary key ([id]),
		[Name] sysname not null,
		constraint [UQ [dbo]].[attribute_type]]([Name]])]
			unique ([Name])
	);
	insert [dbo].[attribute_type] ([id], [Name]) values (0, '{Undefined}');
	insert [dbo].[attribute_type] ([id], [Name]) values (1, 'Schema');
	insert [dbo].[attribute_type] ([id], [Name]) values (2, 'Table');
	insert [dbo].[attribute_type] ([id], [Name]) values (3, 'Column');
end;
go

if 0 = [dbo].[table_exists]('dbo', 'attribute')
begin
	-- drop table [dbo].[attribute];
	create table [dbo].[attribute]
	(
		[type_id] int not null,
		constraint [FK [dbo]].[attribute]]([type_id]])]
			foreign key ([type_id])
			references [dbo].[attribute_type]([id]),
		[Level1Name] sysname not null,
		[Level2Name] sysname null,
		[Level3Name] sysname null,
		[Level4Name] sysname null,
		[Name] sysname null,
		constraint [UQ [dbo]].[attribute]]([type_id]], [Level1Name]], [Level2Name]], [Level3Name]], [Level4Name]])]
			unique ([type_id], [Level1Name], [Level2Name], [Level3Name], [Level4Name]),
		[Value] sql_variant not null
	);
end;
go

drop function if exists [dbo].[attribute_get];
go
create function [dbo].[attribute_get]
(
	@type_id int,
    @level_1_name sysname,
    @level_2_name sysname = null,
    @level_3_name sysname = null,
    @level_4_name sysname = null,
	@name sysname
)
returns sql_variant
begin
	declare @result sql_variant = null;
	select
		top 1
		@result = [Value]
	from
		[dbo].[attribute]
	where
		[type_id] = @type_id
	and
		[Level1Name] = @level_1_name
	and
		[Level2Name] = @level_2_name
	and
		[Level3Name] = @level_3_name
	and
		[Level4Name] = @level_4_name
	and
		[Name] = @name
	;
	return @result;
end;
go

drop procedure if exists [dbo].[attribute_set];
go
create procedure [dbo].[attribute_set]
	@type_id int,
    @level_1_name sysname,
    @level_2_name sysname = null,
    @level_3_name sysname = null,
    @level_4_name sysname = null,
    @name sysname,
	@value sql_variant = null
as
set nocount on;

if @value is null
begin
	delete
		[dbo].[attribute]
	where
		[type_id] = @type_id
	and
		[Level1Name] = @level_1_name
	and
		[Level2Name] = @level_2_name
	and
		[Level3Name] = @level_3_name
	and
		[Level4Name] = @level_4_name
	and
		[Name] = @name
	;
	return;
end;

update
	[dbo].[attribute]
set
	[Value] = @value
where
	[type_id] = @type_id
and
	[Level1Name] = @level_1_name
and
	[Level2Name] = @level_2_name
and
	[Level3Name] = @level_3_name
and
	[Level4Name] = @level_4_name
and
	[Name] = @name
;
if 0 = @@rowcount
	insert
		[dbo].[attribute]
	(
		[type_id],
		[Level1Name],
		[Level2Name],
		[Level3Name],
		[Level4Name],
		[Name],
		[Value]
	)
	values
	(
		@type_id,
		@level_1_name,
		@level_2_name,
		@level_3_name,
		@level_4_name,
		@name,
		@value
	);
go

drop function if exists [dbo].[schema_attribute_get];
go
create function [dbo].[schema_attribute_get]
(
    @schema_name sysname,
	@attribute_name sysname
)
returns sql_variant
begin
	return [dbo].[attribute_get](1, @schema_name, null, null, null, @attribute_name);
end;
go

drop procedure if exists [dbo].[schema_attribute_set];
go
create procedure [dbo].[schema_attribute_set]
    @schema_name sysname,
    @attribute_name sysname,
	@value sql_variant = null
as
set nocount on;

exec [dbo].[attribute_set] 1, @schema_name, @name = @attribute_name, @value = @value;
go

drop function if exists [dbo].[table_attribute_get];
go
create function [dbo].[table_attribute_get]
(
    @schema_name sysname,
    @table_name sysname,
	@attribute_name sysname
)
returns sql_variant
begin
	return [dbo].[attribute_get](2, @schema_name, @table_name, null, null, @attribute_name);
end;
go

drop procedure if exists [dbo].[table_attribute_set];
go
create procedure [dbo].[table_attribute_set]
    @schema_name sysname,
    @table_name sysname,
    @attribute_name sysname,
	@value sql_variant = null
as
set nocount on;

exec [dbo].[attribute_set] 2, @schema_name, @table_name, @name = @attribute_name, @value = @value;
go

drop function if exists [dbo].[column_attribute_get];
go
create function [dbo].[column_attribute_get]
(
    @schema_name sysname,
    @table_name sysname,
    @column_name sysname,
	@attribute_name sysname
)
returns sql_variant
begin
	return [dbo].[attribute_get](2, @schema_name, @table_name, @column_name, null, @attribute_name);
end;
go

drop procedure if exists [dbo].[column_attribute_set];
go
create procedure [dbo].[column_attribute_set]
    @schema_name sysname,
    @table_name sysname,
    @column_name sysname,
    @attribute_name sysname,
	@value sql_variant = null
as
set nocount on;

exec [dbo].[attribute_set] 2, @schema_name, @table_name, @column_name, @name = @attribute_name, @value = @value;
go
