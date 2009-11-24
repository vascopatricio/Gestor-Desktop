// ActionScript file
import flash.events.Event;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.utils.Base64Encoder;

private function makeTargetListManually() : void
{
	var projectName:String = getProjectName(addActionItemWindow.projectComboBox.selectedIndex);
	var index:int = availableProjectsNames.indexOf(projectName);
	var id:String = availableProjectsIDs[index];
	
	//Criar request
	var service:HTTPService = new HTTPService();
	service.url = "http://jeknowledge.pt/gestor/api/projects/"+id;
	service.method = "GET";
	service.addEventListener(ResultEvent.RESULT, receiveTargetsHandler);
	service.addEventListener(FaultEvent.FAULT, projectFailHandler);
	service.resultFormat = "xml";
	
	//Encode, basic auth
	var encoder : Base64Encoder = new Base64Encoder();
	encoder.encode(currentUser+":"+currentPass);
	service.headers["Authorization"] = "Basic " + encoder.toString();
	
	//Send
	service.send();
	
	var targets:ArrayCollection = new ArrayCollection();	
	
	targets.addItem("Vasco Patricio");
	addActionItemWindow.currentUserIDs.push("60");
	targets.addItem("Pedro Gaspar");
	addActionItemWindow.currentUserIDs.push("1");
	targets.addItem("Sérgio Santos");
	addActionItemWindow.currentUserIDs.push("2");
	
	addActionItemWindow.targetList.dataProvider = targets;
}

private function makeTargetList(event : Event) : void
{
	makeTargetListManually();
}

private function receiveTargetsHandler(event : ResultEvent) : void
{
	var xml:XML = XML(event.result);
	Alert.show(xml.toString(),"");
}

private function getProjectName(index:int) : String
{	
	return availableProjectsNames[index];
}

private function makeTargetsString() : String
{
	var str:String = "";
	var array:Array = (addActionItemWindow.currentUserIDs);
	
	var i:int;
	for(i = 0; i< array.length; i++)
	{
		if(addActionItemWindow.targetList.selectedIndices.indexOf(i,0) < 0)
			continue;
		
		str += array[i];	
		if(i!=array.length-1)
			str += ",";
	}
	
	return str;
}

private function createActionItemWindow() : void
{
	addActionItemWindow = new AddNewActionItemWindow();
	addActionItemWindow.open();
	
	addActionItemWindow.cancelButton.addEventListener(MouseEvent.CLICK, closeAddActionItemWindow);	
	addActionItemWindow.projectComboBox.dataProvider = availableProjectsNames;
	addActionItemWindow.projectComboBox.addEventListener("change", makeTargetList);
	addActionItemWindow.projectComboBox.selectedIndex = 0;
	
	addActionItemWindow.targetList.allowMultipleSelection = true;
	
	var priorities:Array = new Array();
	priorities.push("High");
	priorities.push("Medium");
	priorities.push("Low");
	addActionItemWindow.priorityComboBox.dataProvider = priorities;
	addActionItemWindow.priorityComboBox.selectedIndex = 1;
	
	makeTargetListManually();
}

private function showEditActionItemWindow(actionItem: ActionItem) : void
{
	createActionItemWindow();
	addActionItemWindow.addButton.addEventListener(MouseEvent.CLICK, editActionItemFromWindow);
	addActionItemWindow.titleTextInput.text = actionItem.getTitle();
	addActionItemWindow.descriptionTextArea.text = actionItem.getDescription();
	addActionItemWindow.projectComboBox.selectedIndex = setComboBoxIndexByName(actionItem.getProjectName());

	if(addActionItemWindow.projectComboBox.selectedIndex == -1)
		return;
		
	//API - 1 High, 2 Medium, 3 Low	
	addActionItemWindow.priorityComboBox.selectedIndex = actionItem.getPriority();
	
	addActionItemWindow.dueDateTextInput.text = actionItem.getDues();
	makeTargetListManually();
}

private function showAddActionItemWindow() : void
{
	createActionItemWindow();
	addActionItemWindow.addButton.addEventListener(MouseEvent.CLICK, addActionItemFromWindow);
	makeTargetListManually();	
}