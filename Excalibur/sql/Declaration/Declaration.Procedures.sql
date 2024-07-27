set nocount on;
go

drop view if exists [Declaration].[StructureAndField];
go
create view [Declaration].[StructureAndField]
as
select
	s.[id] [structureId],
	s.[Name] [structureName],
	sf.[id] [fieldId],
	sf.[Name] [fieldName],
	dt.[id] [dataTypeId],
	dt.[Name] [dataTypeName],
	sf.[maximumCount] [fieldMaximumCount]
from
	[Declaration].[Structure] s
inner join
	[Declaration].[StructureField] sf
	on sf.[structureId] = s.[id]
inner join
	[Declaration].[DataType] dt
	on sf.[dataTypeId] = dt.[id]
;
go

drop procedure if exists [Declaration].[Structure_Insert];
go
create procedure [Declaration].[Structure_Insert]
	@classificationId int,
	@name nvarchar(128),
	@attributes bigint,
	@description nvarchar(4000) = null,
	@id int output
as
set nocount on;

insert
	[Declaration].[Structure]
(
	[classificationId],
	[Name],
	[Attributes],
	[Description]
)
values
(
	@classificationId,
	@name,
	@attributes,
	@description
);
set @id = scope_identity();
go

drop procedure if exists [Declaration].[StructureField_Insert];
go
create procedure [Declaration].[StructureField_Insert]
	@structureId int,
	@name nvarchar(128),
	@attributes bigint,
	@description nvarchar(4000) = null,
	@dataTypeId int,
	@enumerationId int,
	@maximumCount tinyint,
	@id int output
as
set nocount on;

insert
	[Declaration].[StructureField]
(
	[StructureId],
	[Name],
	[Attributes],
	[Description],
	[DataTypeId],
	[EnumerationId],
	[MaximumCount]
)
values
(
	@structureId,
	@name,
	@attributes,
	@description,
	@dataTypeId,
	@enumerationId,
	@maximumCount
);
set @id = scope_identity();
go

drop view if exists [Declaration].[ProfileAndProperty];
go
create view [Declaration].[ProfileAndProperty]
as
select
	s.[id] [profileId],
	s.[Name] [profileName],
	pp.[id] [propertyId],
	pp.[Name] [propertyName],
	dt.[id] [dataTypeId],
	dt.[Name] [dataTypeName],
	pp.[maximumCount] [propertyMaximumCount],
	c.[id] [structureId],
	c.[Name] [structureName],
	e.[id] [enumerationId],
	e.[Name] [enumerationName]
from
	[Declaration].[Profile] s
inner join
	[Declaration].[ProfileProperty] pp
	on s.[id] = pp.[profileId]
inner join
	[Declaration].[DataType] dt
	on dt.[id] = pp.[dataTypeId]
inner join
	[Declaration].[Structure] c
	on c.[id] = pp.[structureId]
inner join
	[Declaration].[Enumeration] e
	on e.[id] = pp.[enumerationId]
;
go

drop procedure if exists [Declaration].[Profile_Insert];
go
create procedure [Declaration].[Profile_Insert]
	@classificationId int,
	@name nvarchar(128),
	@attributes bigint,
	@description nvarchar(4000) = null,
	@id int output
as
set nocount on;

insert
	[Declaration].[Profile]
(
	[classificationId],
	[Name],
	[Attributes],
	[Description]
)
values
(
	@classificationId,
	@name,
	@attributes,
	@description
);
set @id = scope_identity();
go

drop procedure if exists [Declaration].[ProfileProperty_Insert];
go
create procedure [Declaration].[ProfileProperty_Insert]
	@profileId int,
	@name nvarchar(128),
	@attributes bigint,
	@description nvarchar(4000) = null,
	@dataTypeId int,
	@structureId int,
	@enumerationId int,
	@maximumCount int,
	@id int output
as
set nocount on;

insert
	[Declaration].[ProfileProperty]
(
	[ProfileId],
	[Name],
	[Attributes],
	[Description],
	[DataTypeId],
	[StructureId],
	[EnumerationId],
	[MaximumCount]
)
values
(
	@profileId,
	@name,
	@attributes,
	@description,
	@dataTypeId,
	@structureId,
	@enumerationId,
	@maximumCount
);
set @id = scope_identity();
go

drop function if exists [Declaration].[DataType_Get];
go
create function [Declaration].[DataType_Get](@id int)
returns nvarchar(128)
begin
	declare @sqltype sysname;
	declare @length smallint;
	declare @precision tinyint;
	declare @scale tinyint;
	select
		top 1
		@sqltype = [sqltype],
		@length = [length],
		@precision = [precision],
		@scale = [scale]
	from
		[Declaration].[DataType]
	where
		[id] = @id
	;
	if 0 = @@rowcount
		return null;
	if 'nvarchar' = @sqltype or 'binary' = @sqltype
	begin
		if 0 = @length
			return @sqltype + '(max)';
		return @sqltype + '(' + cast(@length as varchar(4)) + ')';
	end;
	if 'numeric' = @sqltype
	begin
		if 0 = @precision and 0 = @scale
			return @sqltype;
		if 0 = @scale
			return @sqltype + '(' + cast(@precision as varchar(2)) + ')';
		return @sqltype + '(' + cast(@precision as varchar(2)) + ',' + cast(@scale as varchar(2)) + ')';
	end;
	return @sqltype;
end;
go

drop procedure if exists [Declaration].[BuildColumn];
go
create procedure [Declaration].[BuildColumn]
	@tableName nvarchar(256),
	@columnName sysname,
	@dataTypeId int,
	@structureId int,
	@enumerationId int,
	@nullable bit,
	@maximumCount int
as
set nocount on;

declare @i int;
declare @localColumnName sysname;

if 1 = @dataTypeId
begin
	if 1 != @maximumCount
	begin
		set @i = 0;
		while @i < @maximumCount
		begin
			set @localColumnName = @columnName + cast(@i as nvarchar(1));
			exec [Declaration].[BuildColumn] @tableName, @localColumnName, @dataTypeId, @structureId, @enumerationId, @nullable, 1;
			set @i = @i + 1;
		end;
		return;
	end;

	declare @id int;
	declare @name nvarchar(128);
	declare @attributes bigint;

	select
		top 1
		@id = [id],
		@name = [Name],
		@dataTypeId = [dataTypeId],
		@attributes = [attributes],
		@enumerationId = [enumerationId],
		@maximumCount = [maximumCount]
	from
		[Declaration].[StructureField]
	where
		[structureId] = @structureId
	order by
		[id]
	;
	while 0 <> @@rowcount
	begin
		set @localColumnName = @columnName + '|' + @name;
		set @nullable = dbo.bitset(@attributes, 0x01);
		exec [Declaration].[BuildColumn] @tableName, @localColumnName, @dataTypeId, 0, @enumerationId, @nullable, @maximumCount;
		select
			top 1
			@id = [id],
			@name = [Name],
			@dataTypeId = [dataTypeId],
			@attributes = [attributes],
			@maximumCount = [maximumCount]
		from
			[Declaration].[StructureField]
		where
			[structureId] = @structureId
		and
			[id] > @id
		order by
			[id]
		;
	end;
	return;
end;

declare @dataType sysname = [Declaration].[DataType_Get](@dataTypeId);

declare @sql nvarchar(max);

if 1 = @maximumCount
begin
	set @sql =
	'alter table [Data-Profile].[' + @tableName + '] add [' + @columnName + '] ' + @dataType + case when 1 = @nullable then '' else ' not' end + ' null;'
	print @sql;
	exec sp_sqlexec @sql;
	return;
end
else
begin
	set @i = 0;
	while @i < @maximumCount
	begin
		set @sql =
		'alter table [Data-Profile].[' + @tableName + '] add [' + @columnName + cast(@i as nvarchar(1)) + '] ' + @dataType + case when 1 = @nullable or @i <> 0 then '' else ' not' end + ' null;'
		print @sql;
		exec sp_sqlexec @sql;
		set @i = @i + 1;
	end;
	return;
end;
go

drop procedure if exists [Declaration].[BuildProfilePropertyTableField];
go
create procedure [Declaration].[BuildProfilePropertyTableField]
	@profileName nvarchar(128),
	@sqlkey_column_declarations nvarchar(max),
	@sqlkey_column_names nvarchar(max),
	@propertyId int
as
set nocount on;

declare @name nvarchar(128);
declare @attributes bigint;
declare @dataTypeId int;
declare @structureId int;
declare @enumerationId int;
declare @maximumCount int;

select
	top 1
	@name = [Name],
	@attributes = [attributes],
	@dataTypeId = [dataTypeId],
	@structureId = [structureId],
	@enumerationId = [enumerationId],
	@maximumCount = [maximumCount]
from
	[Declaration].[ProfileProperty]
where
	[id] = @propertyId
;
if 0 = @@rowcount
begin
	-- raiserror
	return;
end;


declare @sql nvarchar(max);
declare @nullable bit = dbo.bitset(@attributes, 0x01);

if 1 = @maximumCount or (0 < @maximumCount and 10 >= @maximumCount)
begin
	exec [Declaration].[BuildColumn] @profileName, @name, @dataTypeId, @structureId, @enumerationId, @nullable, @maximumCount;
	return;
end;

set @sqlkey_column_declarations = @sqlkey_column_declarations +
'    [_ordinal] int not null,';
set @sqlkey_column_names = @sqlkey_column_names + ', [_ordinal]';


set @sql =
'create table [Data-Profile].[' + @profileName + '|' + @name + ']' + char(13) +
'(' + char(13);

set @sql = @sql +
@sqlkey_column_declarations +
'    constraint [PK [DataProfile]].[' + @profileName + '| ' + @name + ']](' + dbo.[[]]](@sqlkey_column_names) + ')]' + char(13) +
'        primary key (' + @sqlkey_column_names + ')' + char(13)

set @sql = @sql +
')';

print @sql;
exec sp_sqlexec @sql;

declare @tableName nvarchar(256) = @profileName + '|' + @name;
exec [Declaration].[BuildColumn] @tableName, @name, @dataTypeId, @structureId, @enumerationId, 0, 1;
go


drop procedure if exists [Declaration].[BuildProfileTable];
go
create procedure [Declaration].[BuildProfileTable]
	@profileId int,
	@deletedOn bit = 0
as
set nocount on;

declare @name nvarchar(128);
declare @attributes bigint;

select
	top 1
	@name = [Name],
	@attributes = [attributes]
from
	[Declaration].[Profile]
where
	[id] = @profileId
;
if 0 = @@rowcount
begin
	-- raiserror
	return;
end;

declare @multientry tinyint = 0x03 & @attributes;
declare @history bit = dbo.bitset(@attributes, 0x04);

if 1 = @deletedOn
	set @name = '_' + @name;

declare @sql nvarchar(max) =
'create table [Data-Profile].[' + @name + ']' + char(13) +
'(' + char(13) +
'    [_insertedId] int not null,' + char(13);

declare @sqlkey_column_declarations nvarchar(max);
declare @sqlkey_column_names nvarchar(max);

if 0 = @deletedOn
begin
	set @sqlkey_column_declarations  =
	'    [_objectId] int not null,' + char(13);
	set @sqlkey_column_names = '[_objectId]';
end
else
begin
	set @sqlkey_column_declarations =
	'    [_deletedId] int not null,' + char(13) +
	'    [_objectId] int not null,' + char(13);
	set @sqlkey_column_names = '[_deletedId], [_objectId]';
end;

if 0 != @multientry
begin
	if 1 = @multientry
	begin
		set @sqlkey_column_declarations = @sqlkey_column_declarations +
		'    [_rowId] int not null,' + char(13);
		set @sqlkey_column_names = @sqlkey_column_names + ', [_rowId]';
	end;
	if 2 = @multientry
	begin
		set @sqlkey_column_names = @sqlkey_column_names + ', [_insertedId]';
	end;
	if 3 = @multientry
	begin
		set @sqlkey_column_declarations = @sqlkey_column_declarations +
		'    [_declaredOn] datetime2 not null,' + char(13);
		set @sqlkey_column_names = @sqlkey_column_names + ', [_insertedId], [declaredOn]';
	end;
end;

set @sql = @sql +
@sqlkey_column_declarations +
'    constraint [PK [DataProfile]].[' + @name + ']](' + dbo.[[]]](@sqlkey_column_names) + ')]' + char(13) +
'        primary key (' + @sqlkey_column_names + ')' + char(13)

set @sql = @sql +
');'

print @sql;
exec sp_sqlexec @sql;

declare @propertyId int;
select
	top 1
	@propertyId = [id]
from
	[Declaration].[ProfileProperty]
where
	[profileId] = @profileId
order by
	[id]
;
while 0 != @@rowcount
begin
	exec [Declaration].[BuildProfilePropertyTableField] @name, @sqlkey_column_declarations, @sqlkey_column_names, @propertyId;

	select
		top 1
		@propertyId = [id]
	from
		[Declaration].[ProfileProperty]
	where
		[profileId] = @profileId
	and
		[id] > @propertyId
	order by
		[id]
	;
end;

if 1 = @history and 0 = @deletedOn
	exec [Declaration].[BuildProfileTable] @profileId, @deletedOn = 1;
go

set xact_abort on;

begin transaction;

declare @fullNameStructureId int = (select top 1 [id] from [Declaration].[Structure] where [classificationId] = 0 and [Name] = 'FullName');
if @fullNameStructureId is null
begin
	exec [Declaration].[Structure_Insert] 0, 'FullName', 0, @id = @fullNameStructureId output;
	exec [Declaration].[StructureField_Insert] @fullNameStructureId, 'Title', 0, null, 0x0A, 0, 1, null;
	exec [Declaration].[StructureField_Insert] @fullNameStructureId, 'FirstName', 0, null, 0x0A, 0, 1, null;
	exec [Declaration].[StructureField_Insert] @fullNameStructureId, 'MiddleNames', 0, null, 0x0A, 0, 8, null;
	exec [Declaration].[StructureField_Insert] @fullNameStructureId, 'LastName', 0, null, 0x0A, 0, 1, null;
	exec [Declaration].[StructureField_Insert] @fullNameStructureId, 'Suffix', 0, null, 0x0A, 0, 1, null;
end;

declare @addressStructureId int = (select top 1 [id] from [Declaration].[Structure] where [classificationId] = 0 and [Name] = 'Address');
if @addressStructureId is null
begin
	exec [Declaration].[Structure_Insert] 0, 'Address', 0, @id = @addressStructureId output;
	exec [Declaration].[StructureField_Insert] @addressStructureId, 'Name', 0, null, 0x0A, 0, 1, null;
	exec [Declaration].[StructureField_Insert] @addressStructureId, 'POBox/Street', 0, null, 0x0A, 0, 2, null;
	exec [Declaration].[StructureField_Insert] @addressStructureId, 'CityTown', 0, null, 0x0A, 0, 1, null;
	exec [Declaration].[StructureField_Insert] @addressStructureId, 'Suburb', 0, null, 0x0A, 0, 1, null;
	exec [Declaration].[StructureField_Insert] @addressStructureId, 'CountyRegion', 0, null, 0x0A, 0, 1, null;
	exec [Declaration].[StructureField_Insert] @addressStructureId, 'Country', 0, null, 0x0A, 0, 1, null;
	exec [Declaration].[StructureField_Insert] @addressStructureId, 'Code', 0, null, 0x0A, 0, 1, null;
end;

declare @personProfileId int = (select top 1 [id] from [Declaration].[Profile] where [classificationId] = 0 and [Name] = 'Default'); -- Person.Default
if @personProfileId is null
begin
	exec [Declaration].[Profile_Insert] 0, 'Default', 0x04, @id = @personProfileId output;
	exec [Declaration].[ProfileProperty_Insert] @personProfileId, 'FullName', 1, null, 0x01, @fullNameStructureId, 0, 1, null;
	exec [Declaration].[ProfileProperty_Insert] @personProfileId, 'Age', 0x00, null, 0x03, 0, 0, 1, null;
	exec [Declaration].[ProfileProperty_Insert] @personProfileId, 'Address', 0x00, null, 0x01, @addressStructureId, 0, 2, null;
	exec [Declaration].[ProfileProperty_Insert] @personProfileId, 'Keywords', 1, null, 0x0A, 0, 0, 50, null;
	exec [Declaration].[ProfileProperty_Insert] @personProfileId, 'Addresses', 0x00, null, 0x01, @addressStructureId, 0, 0, null;
end;

select * from [Declaration].[StructureAndField];
select * from [Declaration].[ProfileAndProperty];

exec [Declaration].[BuildProfileTable] @personProfileId;

commit transaction;
--rollback transaction;