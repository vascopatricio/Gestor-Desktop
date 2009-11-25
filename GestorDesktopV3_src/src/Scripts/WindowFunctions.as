// ActionScript file
import Classes.ActionItem;

import flash.events.KeyboardEvent;
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
	
	if(!testLogin(userTextField.text, passTextField.text))
	{
		loginResult.text = "Login try failed!";
		return;
	}
		
	currentUser = userTextField.text;
	currentPass = passTextField.text;
	isLoggedIn = true;
			
	showMainMode();				
}

private function testLogin(user:String, pass:String) : Boolean
{
	if(user == "fake")
		return false;
	return true;
}

private function logout() : void
{
	currentUser = null;
	currentPass = null;
	isLoggedIn = false;
	
	if(addActionItemWindow != null)
		addActionItemWindow = null;
	
	showLoginMode();
}

private function showLoginMode() : void
{
	searchLabel.visible = false;
	searchTextField.visible = false;
	refreshBut.visible = false;
	actionItemsPanel.visible = false;
	addButton.visible = false;
	logoutButton.visible = false;
	
	passTextField.addEventListener(KeyboardEvent.KEY_DOWN, checkIfEnterAndLogin);
		
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
	actionItemsPanel.visible = true;
	addButton.visible = true;
	logoutButton.visible = true;
	
	userLabel.visible = false;
	userTextField.visible = false;
	passLabel.visible = false;
	passTextField.visible = false;
	loginBut.visible = false;
	loginResult.visible = false;
	
	refreshAll();
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
	
	params.targets = makeTargetsString();
	Alert.show(makeTargetsString(),"");
	params.description = addActionItemWindow.descriptionTextArea.text;
	params.priority = addActionItemWindow.priorityComboBox.selectedIndex + 1;
	if(addActionItemWindow.duesDateField.text.length != 0)
		params.due_date = addActionItemWindow.duesDateField.text;
	
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
	params.targets = makeTargetsString();
	params.description = addActionItemWindow.descriptionTextArea.text;
	params.priority = addActionItemWindow.priorityComboBox.selectedIndex + 1;
	if(addActionItemWindow.duesDateField.text.length != 0)
		params.due_date = addActionItemWindow.duesDateField.text;
	
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