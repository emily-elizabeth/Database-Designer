script "DatabaseDesignerLibrary"
on DBDCreateToolInStack toolTypeToCreate, stackLongID
   set the defaultStack to stackLongID
   
   lock screen
   lock messages
   
   local toolCreatedID
   do "create" && toolTypeToCreate
   put the long ID of the last control into toolCreatedID
   
   return toolCreatedID
end DBDCreateToolInStack
