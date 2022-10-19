script "DatabaseAbstraction"
function DBOpenSQL filePath
   local databaseID
   put revOpenDatabase("sqlite", filepath) into databaseID
   
   if (databaseID is not a number) then
      throw databaseID
   else
      put databaseID
      return databaseID
   end if
end DBOpenSQL


on DBCreateTable databaseID, tableName, values
   try
      if _DBIsOpen(databaseID) then
         local sql
         put "create table" && tableName && "(" into sql
         repeat with i = 1 to (the number of lines in the keys of values)
            --            put ":" & i & COMMA & SPACE after sql
            put values[i] & COMMA & SPACE after sql
         end repeat
         delete char -2 to -1 of sql
         put ")" after sql
         revExecuteSQL databaseID, sql, "values"
      else
         throw "Database is not open."
      end if
   catch errorParam
      throw errorParam
   end try
end DBCreateTable


on DBInsert databaseID, tableName, columnNames, insertValues
   try
      if _DBIsOpen(databaseID) then
         local sql
         put "insert into" && tableName && "(" into sql
         repeat with i = 1 to (the number of lines in the keys of columnNames)
            put columnNames[i] & COMMA & SPACE after sql
         end repeat
         delete char -2 to -1 of sql
         put ") values (" after sql
         repeat with i = 1 to (the number of lines in the keys of insertValues)
            put ":" & i & COMMA & SPACE after sql
         end repeat
         delete char -2 to -1 of sql  -- remove the trailing comma and space
         put ")" after sql
         revExecuteSQL databaseID, sql, "insertValues"
      else
         put "not open"
      end if
   catch errorParamater
      break
   end try
end DBInsert


on DBUpdate databaseID, tableName, values, where
   try
      if (_DBIsOpen(databaseID)) then
         local sql
         put "UPDATE" && tableName && "SET " into sql
         repeat for each line columnName in the keys of values
            put columnName & "=" & _DBQuote(values[columnName]) & COMMA & SPACE after sql
         end repeat
         delete char -2 of sql
         put "WHERE" && (line 1 of the keys of where) & "=" & where[line 1 of the keys of where] after sql
         revExecuteSQL databaseID, sql
      end if
   end try
end DBUpdate


on DBDelete databaseID, tableName, where
   try
      if (_DBIsOpen(databaseID)) then
         local sql
         put "DELETE FROM" && tableName && "WHERE " into sql
         put (line 1 of the keys of where) & "=" & _DBQuote(where[line 1 of the keys of where]) after sql
         revExecuteSQL databaseID, sql
      end if
   end try
end DBDelete


on DBAlterTableAddColumn databaseID, tableName, values
   try
      if (_DBIsOpen(databaseID)) then
         local sql
         put "ALTER TABLE" && tableName && "ADD" && values[1] into sql
         revExecuteSQL databaseID, sql
      end if
   end try
end DBAlterTableAddColumn


on DBAlterTableDropColumn databaseID, tableName, values
   try
      if (_DBIsOpen(databaseID)) then
         local sql
         put "ALTER TABLE" && tableName && "DROP COLUMN :1" into sql
         put sql
      end if
   end try
end DBAlterTableDropColumn




function _DBIsOpen databaseID
   local openDatabases
   put revOpenDatabases() into openDatabases
   
   if (word 1 of openDatabases = "revdberr") then
      throw openDatabases
   else
      return (databaseID is among the items of openDatabases)
   end if
end _DBIsOpen


function _DBQuote values
   if (values is a number) then
      return values
   else
      return QUOTE & values & QUOTE
   end if
end _DBQuote
