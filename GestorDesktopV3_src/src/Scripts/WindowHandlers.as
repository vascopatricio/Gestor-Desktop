// ActionScript file		
import Classes.ActionItem;

import flash.events.KeyboardEvent;
import flash.events.MouseEvent;

private function searchOnChanged() : void
{
	makeListFromItems();		
}	

//Handler para cliques nos menus			
private function menuHandler(event : MenuEvent) : void {
	//Alert.show("Label: "+event.item.@label +" Data: "+event.item.@data, "Clicked menu item");
	
	if(event.item.@label == "File_exit")
		close();
}

private function checkIfEnterAndLogin(event: KeyboardEvent) : void
{
	if(event.charCode == 13)
		login();	
}

private function createEditWindow(event: MouseEvent) : void
{
	var label:Label = event.currentTarget as Label;
	var actionItem:ActionItem = getActionItemByName(label.text);
	showEditActionItemWindow(actionItem);
}