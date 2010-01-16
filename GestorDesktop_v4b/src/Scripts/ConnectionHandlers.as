// ActionScript file
import flash.events.Event;


private function projectSuccessHandler(event : ResultEvent) : void
{
	var xml:XML = XML(event.result);
	
	availableProjectsIDs = new Array();
	availableProjectsNames = new Array();
	
	var i:int;
	for(i=0; i<xml.descendants("project").length(); i++)
	{
		availableProjectsIDs.push(xml.descendants("project")[i].child("id").toString());
		availableProjectsNames.push(xml.descendants("project")[i].child("name").toString());
	}
	
	filterProjects();
}

private function filterProjectsSuccessHandler(event : ResultEvent) : void
{
	var xml:XML = XML(event.result);
	
	var active:int = int(xml.descendants("project")[0].child("active").toString());
	if(active == 0)
		removeProject(int(xml.descendants("project")[0].child("id").toString()));	
}

private function projectFailHandler(event : Event) : void
{
	
}

private function addItemSuccess(event : ResultEvent) : void
{
	addActionItemWindow.close();
	refreshActionItems();
}

private function editItemSuccess(event : ResultEvent) : void
{
	addActionItemWindow.close();
	refreshActionItems();
}

private function markAsDoneSuccess(event : ResultEvent) : void
{
	Alert.show("ActionItem successfully marked as done","Success");
	refreshActionItems();
}

private function refreshItemsSuccess(event : ResultEvent) : void
{
	var xml:XML = XML(event.result);
	
	//Faz reset aos arrays antes de adicionar os novos
	actionItemsArray = new Array();
	doneActionItemsArray = new Array();
	checksArray = new Array();
	labelsArray = new Array();
	
	var i:int;
	for(i=0; i<xml.descendants("title").length(); i++)
	{
		var priority:int;
		priority = int(xml.descendants("priority")[i].toString());
		//debug.text += xml.descendants("title")[i].toString()+"\n";
		//debug.text += xml.descendants("targets")[i].child("user").child("login").toString();
		
		var actionItem:ActionItem = new ActionItem(
				xml.descendants("title")[i].toString(),
				xml.descendants("action_item")[i].child("id").toString(),
				xml.descendants("project")[i].child("id").toString(),
				xml.descendants("project")[i].child("name").toString(),
				xml.descendants("due_date")[i].toString(),
				priority,
				xml.descendants("description")[i].toString(),
				xml.descendants("author")[i].child("user").child("login").toString(),
				xml.descendants("author")[i].child("user").child("id").toString(),
				xml.descendants("author")[i].child("user").child("name").toString()
		);
		
		var curProjectName:String = xml.descendants("project")[i].child("id").toString();
		var curProjectID:String = xml.descendants("project")[i].child("name").toString();
		
		//Da fase em que os projectos da lista eram os dos action items
		//Sera removido mas esta ca para referencia se necessario ate finalizar
		/*if(availableProjectsIDs.indexOf(curProjectName) == -1)
		{
			availableProjectsIDs.push(curProjectName);
			availableProjectsNames.push(curProjectID);
		}*/
			
		var j:int;
		for(j=0; j<xml.descendants("targets")[i].child("user").child("name").length(); j++)
		{	
			var userName:String = xml.descendants("targets")[i].child("user").child("name")[j].toString();
			var userID:String = xml.descendants("targets")[i].child("user").child("id")[j].toString();
			
			actionItem.getTargetsFullNameArray().push(userName);
			actionItem.getTargetsIDArray().push(userID);			
		}
		
		actionItemsArray.push(actionItem);
	}
	
	makeListFromItems();
}

private function failHandler(evt : FaultEvent) : void
{
	var title:String = evt.type + " (" + evt.fault.faultCode + ")";
 	var text:String = evt.fault.faultString;
    var alert:Alert = Alert.show(text, title);

}