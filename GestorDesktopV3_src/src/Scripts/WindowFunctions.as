// ActionScript file
import Classes.ActionItem;

import flash.events.MouseEvent;

import mx.utils.Base64Encoder;

public var addActionItemWindow:AddNewActionItemWindow;
		
public var availableProjectsNames:Array = new Array();
public var availableProjectsIDs:Array = new Array();
		
private function login() : void
{
	if(userTextField.text == null || passTextField.text == null)
	{
		loginResult.text = "Invalid username/password";
		return;
	}
	if(userTextField.text.length == 0 || passTextField.text.length == 0)
	{
		loginResult.text = "Invalid username/password";
		return;
	}
		
	currentUser = userTextField.text;
	currentPass = passTextField.text;
	isLoggedIn = true;
			
	showMainMode();				
}

private function logout() : void
{
	currentUser = null;
	currentPass = null;
	isLoggedIn = false;
	
	showLoginMode();
}

private function showLoginMode() : void
{
	searchLabel.visible = false;
	searchTextField.visible = false;
	refreshBut.visible = false;
	refreshLabel.visible = false;
	actionItemsPanel.visible = false;
	addButton.visible = false;
	logoutButton.visible = false;
		
	userLabel.visible = true;
	userTextField.visible = true;
	passLabel.visible = true;
	passTextField.visible = true;
	loginBut.visible = true;
	loginResult.visible = true;
}

private function showMainMode() : void
{
	searchLabel.visible = true;
	searchTextField.visible = true;
	refreshBut.visible = true;
	refreshLabel.visible = true;
	actionItemsPanel.visible = true;
	addButton.visible = true;
	logoutButton.visible = true;
	
	userLabel.visible = false;
	userTextField.visible = false;
	passLabel.visible = false;
	passTextField.visible = false;
	loginBut.visible = false;
	loginResult.visible = false;
	
	refreshActionItems();
}

private function createActionItemWindow() : void
{
	addActionItemWindow = new AddNewActionItemWindow();
	addActionItemWindow.open();
	
	addActionItemWindow.cancelButton.addEventListener(MouseEvent.CLICK, closeAddActionItemWindow);	
	addActionItemWindow.projectComboBox.dataProvider = availableProjectsNames;
	
	var priorities:Array = new Array();
	priorities.push("High");
	priorities.push("Medium");
	priorities.push("Low");
	addActionItemWindow.priorityComboBox.dataProvider = priorities;
	addActionItemWindow.priorityComboBox.selectedIndex = 1;
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
	
	var i:int;
	var targetsArray:Array = actionItem.getTargetsArray();
	
	for(i=0; i<targetsArray.length; i++)
		addActionItemWindow.targetsTextInput.text += targetsArray[i]+",";	
}

private function showAddActionItemWindow() : void
{
	createActionItemWindow();
	addActionItemWindow.addButton.addEventListener(MouseEvent.CLICK, addActionItemFromWindow);
		
}

private function editActionItemFromWindow(event: MouseEvent) : void
{
	if(addActionItemWindow.hasBeenChanged == false)
		return;
		
	//Cria request
	var service:HTTPService = new HTTPService();
	service.url = "";
	service.method = "PUT";
	service.addEventListener(ResultEvent.RESULT, editItemSuccess);
	service.addEventListener(FaultEvent.FAULT, failHandler);
	service.resultFormat = "xml";
	
	var params:Object = {};
	params.title = addActionItemWindow.titleTextInput.text;
	params.project_id = availableProjectsIDs[addActionItemWindow.projectComboBox.selectedIndex];
	params.targets = addActionItemWindow.targetsTextInput.text;
	params.description = addActionItemWindow.descriptionTextArea.text;
	params.priority = addActionItemWindow.priorityComboBox.selectedIndex + 1;
	if(addActionItemWindow.dueDateTextInput.text.length != 0)
		params.due_date = addActionItemWindow.dueDateTextInput.text;
	params.targets = addActionItemWindow.targetsTextInput;
	
	//Encode, basic auth
	var encoder : Base64Encoder = new Base64Encoder();
	encoder.encode(currentUser+":"+currentPass);
	service.headers["Authorization"] = "Basic " + encoder.toString();
	
	//Send
	service.send(params);
	addActionItemWindow.close();
}

private function addActionItemFromWindow(event : MouseEvent) : void
{
	Alert.show("Entrado na funcao","");
	
	//Cria request
	var service:HTTPService = new HTTPService();
	service.url = "http://jeknowledge.pt/gestor/api/action_items";
	service.method = "POST";
	service.addEventListener(ResultEvent.RESULT, addItemSuccess);
	service.addEventListener(FaultEvent.FAULT, failHandler);
	service.resultFormat = "xml";
	
	var params:Object = {};
	params.title = addActionItemWindow.titleTextInput.text;
	params.project_id = availableProjectsIDs[addActionItemWindow.projectComboBox.selectedIndex];
	params.targets = addActionItemWindow.targetsTextInput.text;
	params.description = addActionItemWindow.descriptionTextArea.text;
	params.priority = addActionItemWindow.priorityComboBox.selectedIndex + 1;
	if(addActionItemWindow.dueDateTextInput.text.length != 0)
		params.due_date = addActionItemWindow.dueDateTextInput.text;
	
	//Encode, basic auth
	var encoder : Base64Encoder = new Base64Encoder();
	encoder.encode(currentUser+":"+currentPass);
	service.headers["Authorization"] = "Basic " + encoder.toString();
	
	//Send
	service.send(params);
	addActionItemWindow.close();
}

private function closeAddActionItemWindow(event : MouseEvent) : void
{
	addActionItemWindow.close();
}

private function setComboBoxIndexByName(name : String) : int
{
	var i:int;
	for(i=0; i<addActionItemWindow.projectComboBox.rowCount; i++)
	{
		addActionItemWindow.projectComboBox.selectedIndex = i;
		if(addActionItemWindow.projectComboBox.selectedLabel == name)
			return i;		
	}
	
	return -1;
}