// ActionScript file

private function addItemSuccess(event : ResultEvent) : void
{
	debug.text = XML(event.result).toString();	
	addActionItemWindow.close();
}

private function editItemSuccess(event : ResultEvent) : void
{
	debug.text = XML(event.result).toString();
}

private function markAsDoneSuccess(event : ResultEvent) : void
{
	debug.text = XML(event.result).toString();
}

private function refreshItemsSuccess(event : ResultEvent) : void
{
	var xml:XML = XML(event.result);
	resetActionItemsList();
	
	var i:int;
	for(i=0; i<xml.descendants("title").length(); i++)
	{
		var priority:int;
		priority = xml.descendants("priority")[i].toString();
		debug.text += xml.descendants("title")[i].toString()+"\n";
		debug.text += xml.descendants("targets")[i].child("user").child("login").toString();
		
		var actionItem:ActionItem = new ActionItem(
				xml.descendants("title")[i].toString(),
				xml.descendants("action_item")[i].child("id").toString(),
				xml.descendants("project")[i].child("id").toString(),
				xml.descendants("project")[i].child("name").toString(),
				xml.descendants("due_date")[i].toString(),
				priority,
				xml.descendants("description")[i].toString(),
				"",
				xml.descendants("author")[i].child("user").child("login").toString(),
				xml.descendants("author")[i].child("user").child("id").toString(),
				xml.descendants("author")[i].child("user").child("name").toString()
		);
		
		var curProjectName:String = xml.descendants("project")[i].child("id").toString();
		var curProjectID:String = xml.descendants("project")[i].child("name").toString();
		
		if(availableProjectsIDs.indexOf(curProjectName) == -1)
		{
			availableProjectsIDs.push(curProjectName);
			availableProjectsNames.push(curProjectID);
		}
			
		var j:int;
		for(j=0; j<xml.descendants("targets")[i].length(); j++)
		{	
			actionItem.addTargetsEntry(
				xml.descendants("targets")[i].child("user").child("name").toString()+" (ID:"+
				xml.descendants("targets")[i].child("user").child("id").toString() +",Login:"+
				xml.descendants("targets")[i].child("user").child("login").toString() + ")"
			);
			
			(actionItem.getTargetsArray()).push(
				xml.descendants("targets")[i].child("user").child("id").toString()
			);
		}
		
		actionItem.setXML("<action_item>\n<done>0</done>\n</action_item>");
		actionItemsArray.push(actionItem);
		
		//Obter XML do item em concreto
		debug.text += "\n" + actionItem.getProjectLink() + "\n";	
	}
	
	makeListFromItems();
}

private function failHandler(evt : FaultEvent) : void
{
	var title:String = evt.type + " (" + evt.fault.faultCode + ")";
 	var text:String = evt.fault.faultString;
    var alert:Alert = Alert.show(text, title);

}