// ActionScript file
import Classes.ActionItem;

import mx.controls.CheckBox;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;
import mx.utils.Base64Encoder;

private function refreshAll() : void
{
	refreshProjects();
	refreshActionItems();
	
	var currentDate:Date = new Date();
	refreshBut.toolTip = "Último refresh: "+currentDate.toLocaleTimeString();
}

private function refreshProjects() : void
{
	//Cria request
	var service:HTTPService = new HTTPService();
	service.url = "http://jeknowledge.pt/gestor/api/projects";
	service.method = "GET";
	service.addEventListener(ResultEvent.RESULT, projectSuccessHandler);
	service.addEventListener(FaultEvent.FAULT, projectFailHandler);
	service.resultFormat = "xml";
	
	//Encode, basic auth
	var encoder : Base64Encoder = new mx.utils.Base64Encoder();
	encoder.encode(currentUser+":"+currentPass);
	service.headers["Authorization"] = "Basic " + encoder.toString();
	
	//Send
	service.send();
}

private function filterProjects() : void
{
	var i:int;
	for(i=0; i<availableProjectsIDs.length; i++)
	{
		//Cria request
		var service:HTTPService = new HTTPService();
		service.url = "http://jeknowledge.pt/gestor/api/projects/"+(availableProjectsIDs[i]);
		service.method = "GET";
		service.addEventListener(ResultEvent.RESULT, filterProjectsSuccessHandler);
		service.addEventListener(FaultEvent.FAULT, projectFailHandler);
		service.resultFormat = "xml";
		
		//Encode, basic auth
		var encoder : Base64Encoder = new mx.utils.Base64Encoder();
		encoder.encode(currentUser+":"+currentPass);
		service.headers["Authorization"] = "Basic " + encoder.toString();
		
		//Send
		service.send();
	}
}

private function refreshActionItems() : void
{
	//Cria request
	var service:HTTPService = new HTTPService();
	service.url = "http://jeknowledge.pt/gestor/api/action_items/todo";
	service.method = "GET";
	service.addEventListener(ResultEvent.RESULT, refreshItemsSuccess);
	service.addEventListener(FaultEvent.FAULT, failHandler);
	service.resultFormat = "xml";
	
	//Encode, basic auth
	var encoder : Base64Encoder = new mx.utils.Base64Encoder();
	encoder.encode(currentUser+":"+currentPass);
	service.headers["Authorization"] = "Basic " + encoder.toString();
	
	//Send
	service.send();
}

private function sendMarkAsDoneHTTPRequest(item : ActionItem) : void
{
	var service:HTTPService = new HTTPService();
	
	var i:int;
	for(i = 0; i<checksArray.length; i++)
	{
		var check:CheckBox = checksArray[i];
		if(check.selected == true)
			{
				var actionItem:ActionItem = actionItemsArray[i];
				service.url = actionItem.getProjectLink()+"?_method=PUT";
			}		
	}
	
	service.method = "POST";
	service.addEventListener(ResultEvent.RESULT, markAsDoneSuccess);
	service.addEventListener(FaultEvent.FAULT, failHandler);
	service.resultFormat = "xml";
	
	//Encode, basic auth
	var encoder : Base64Encoder = new mx.utils.Base64Encoder();
	encoder.encode(currentUser+":"+currentPass);
	service.headers["Authorization"] = "Basic " + encoder.toString(); 
	
	var params:Object = {}; 
	params.done = "True";
	
	//Send
	service.send(params);
}
