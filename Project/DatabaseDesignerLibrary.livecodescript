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


on DBDCreateNewBlankTemplate
   // create a name for the template
   local stackNumber
   put 1 into stackNumber
   repeat
      if (there is a stack ("Untitled" && stackNumber)) then
         add 1 to stackNumber
      else
         exit repeat
      end if
   end repeat
   
   // set the templateStack properties
   set the name of the templateStack to ("Untitled" && stackNumber)
   set the visible of the templateStack to FALSE
   set the width of the templateStack to 1024
   set the height of the templateStack to 768
   set the destroyStack of the templateStack to TRUE
   set the destroyWindow of the templateStack to TRUE
   set the topLeft of the templateStack to 100, 100  // left, top
   
   // create the stack
   lock messages
   create stack
   local newStackLongID
   put it into newStackLongID
   
   // copy the tools group
   //if (there is no group "DatabaseDesignerTools") then
   copy group "DatabaseDesignerTools" of stack "DatabaseDesignerToolsUI" to newStackLongID
   local newGroupLongID
   put it into newGroupLongID
   set the lockLoc of newGroupLongID to TRUE
   set the left of newGroupLongID to (the width of newStackLongID - the width of newGroupLongID)
   set the height of of newGroupLongID to (the height of newStackLongID)
   //end if
   
   // show the stack
   show stack newStackLongID
   unlock messages
   reset the templateStack
end DBDCreateNewBlankTemplate
