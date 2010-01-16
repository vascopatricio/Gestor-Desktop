// ActionScript file
import Classes.ActionItem;

import flash.events.Event;

import mx.collections.ArrayCollection;
import mx.utils.Base64Encoder;

public var editWindowActionItem:ActionItem = null;

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
}

private function makeTargetList(event : Event) : void
{
	makeTargetListManually();
}

private function receiveTargetsHandler(event : ResultEvent) : void
{
	var xml:XML = XML(event.result);
	var targets:ArrayCollection = new ArrayCollection();
	
	var i:int;
	var j:int;
	
	addActionItemWindow.currentUserIDs = new Array();
	addActionItemWindow.currentUserNames = new Array();
	
	for(i=0; i<xml.descendants("end_date").length(); i++)
	{
		for(j=0; j<xml.descendants("team")[i].child("user").child("name").length(); j++)
		{	
			var userName:String = xml.descendants("team")[i].child("user").child("name")[j].toString();
			var userID:String = xml.descendants("team")[i].child("user").child("id")[j].toString();
			
			targets.addItem(userName);
			addActionItemWindow.currentUserIDs.push(userID);
			addActionItemWindow.currentUserNames.push(userName);
		}	
	}

	addActionItemWindow.targetList.dataProvider = targets;
	
	if(editWindowActionItem != null)
		selectPeopleFromActionItem();
	else
		addActionItemWindow.targetList.selectedIndices = new Array();
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
	
	if(str.charAt(str.length-1) == ",")
		str = str.substring(0,str.length-1);
	
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
	
	addActionItemWindow.duesDateField.formatString = "YYYY-MM-DD";
	
	var currentDate:Date = new Date();	
	addActionItemWindow.duesDateField.text = currentDate.getFullYear()+"-"+(currentDate.getMonth()+1)+"-"+currentDate.getDate();
}

private function selectPeopleFromActionItem() : void
{
	var selectedIndices:Array = new Array(); 
	var i:int;
	//Por cada pessoa na equipa do ActionItem
	for(i=0; i<editWindowActionItem.getTargetsIDArray().length; i++)
	{
		//Procura o indice dessa pessoa no vector de pessoas do projecto
		var index:int = addActionItemWindow.currentUserIDs.indexOf(editWindowActionItem.getTargetsIDArray()[i],0);
			
		//E selecciona esse indice na lista
		if(index > -1)
		{
			//Alert.show("User participa! ","");
			selectedIndices.push(index);
		}
	}
	addActionItemWindow.targetList.selectedIndices = selectedIndices;
}

private function showAddActionItemWindow() : void
{
	editWindowActionItem = null;
	createActionItemWindow();
	
	addActionItemWindow.addButton.addEventListener(MouseEvent.CLICK, addActionItemFromWindow);
	//Colocar prioridade default do actionItem
	addActionItemWindow.priorityComboBox.selectedIndex = 1;
	
	makeTargetListManually();	
}

private function showEditActionItemWindow(actionItem: ActionItem) : void
{
	createActionItemWindow();
	addActionItemWindow.addButton.addEventListener(MouseEvent.CLICK, editActionItemFromWindow);
	addActionItemWindow.addButton.label = "Edit";
	addActionItemWindow.titleTextInput.text = actionItem.getTitle();
	addActionItemWindow.descriptionTextArea.text = actionItem.getDescription();
	
	addActionItemWindow.projectComboBox.selectedIndex = setComboBoxIndexByID(actionItem);

	if(addActionItemWindow.projectComboBox.selectedIndex == -1)
		return;
		
	//API - 1 High, 2 Medium, 3 Low	
	//Na combobox: 0-High, 1-Medium, 2-Low
	if(actionItem.getPriority() > 0)
		addActionItemWindow.priorityComboBox.selectedIndex = actionItem.getPriority()-1;
	
	addActionItemWindow.duesDateField.text = actionItem.getDues();
	makeTargetListManually();
	
	editWindowActionItem = actionItem;			
}

private function setComboBoxIndexByID(actionItem : ActionItem) : int
{
	var projectID:int = actionItem.getProjectID();
	var i:int;
	for(i=0; i<availableProjectsIDs.length;i++)
	{
		if(projectID == availableProjectsIDs[i])
			return i;		
	}
	
	return -1;
}