// ActionScript file	
import Classes.ActionItem;

import flash.events.Event;
import flash.events.MouseEvent;

import mx.controls.CheckBox;
import mx.controls.Label;

private function getActionItemByName(name : String) : ActionItem
{
	var i:int;
	for(i=0; i<actionItemsArray.length; i++)
	{
		var item:ActionItem = actionItemsArray[i];
		if(item.getTitle() == name)
			return item;
	}
	return null;
}

private function makeListFromItems() : void
{
	if(isSending)
		return;
	
	//ActionItems por fazer
	var text:Label;
	var dateStringTemp:String;
	var item:ActionItem;
	var arr:String;
	var check:CheckBox;
	
	//Uso um current index para definir os Y das labels em vez da variavel iterativa
	//Por causa do search
	//Se temos o 5o elemento mas apenas aparece esse devido a um search
	//Ele tem de aparecer em 1a posicao e nao 5a para nao ficar espacos em branco
	//Dai, currentIndex que apenas e incrementado quando um item e adicionado com sucesso
	var currentIndex:int = 0;
	var i:int;
	var j:int;
	
	//Limpar items correntes
	actionItemsPanel.removeAllChildren();
	
	//Ciclo de adicionar items
	for(i=0; i<actionItemsArray.length; i++)
	{	
		//Filtrar item se houver search e nao fizer parte do search
		item = actionItemsArray[i];
		if(searchTextField.text.length > 0)
			if(item.getTitle().indexOf(searchTextField.text) < 0)
				continue;
		
		//Criar label do item	
		text = new Label();
		dateStringTemp = parseString(item.getDues());	
		if(dateStringTemp == "To do")
			text.setStyle("color",0xF5B800);
		else if(dateStringTemp == "Late")
			text.setStyle("color",0xF53D00);
		
		text.text = item.getTitle();
		text.width = 200;
		text.x = 5;
		text.y = currentIndex*15;
		text.toolTip = 
			"Title: "+item.getTitle()+"\n"+
			"Project: "+item.getProjectName()+"\n"+
			"Team: \n";
		text.addEventListener(MouseEvent.CLICK, createEditWindow);
		text.toolTip += item.getTargets();
		
		//Adiciona label ao painel
		actionItemsPanel.addChild(text);
		labelsArray.push(text);
		
		//Cria checkbox ao lado da label
		check = new CheckBox();
		check.x = 205;
		check.y = currentIndex*15;
		check.addEventListener(MouseEvent.CLICK, markAsDone);
		actionItemsPanel.addChild(check);
		checksArray.push(check);
		
		currentIndex++;
	}
	
	//ActionItems feitos
	for(i=0; i<doneActionItemsArray.length; i++)
	{
		item = actionItemsArray[i];
		if(searchTextField.text.length > 0)
			if(item.getTitle().indexOf(searchTextField.text) < 0)
			continue;
		
		text = new Label();
		dateStringTemp = parseString(item.getDues());
		
		text.setStyle("color",0x009900);
		text.text = item.getTitle();
		text.width = 200;
		text.x = 5;
		text.y = currentIndex*15;
		text.toolTip = 
			"Title: "+item.getTitle()+"\n"+
			"Project: "+item.getProjectName()+"\n"+
			"Team: \n";
			
		text.toolTip += item.getTargets();
		
		actionItemsPanel.addChild(text);
		labelsArray.push(text);
		
		check = new CheckBox();
		check.selected = true;
		check.x = 205;
		check.y = currentIndex*15;
		check.addEventListener(MouseEvent.CLICK, unmarkAsDone);
		actionItemsPanel.addChild(check);
		checksArray.push(check);
		
		currentIndex++;
	}
}

private function resetActionItemsList() : void
{
	actionItemsArray = new Array();
	
	checksArray = new Array();
	labelsArray = new Array();
}

private function addActionItemToArray(item : ActionItem) : void
{	
	actionItemsArray.push(item);
}

private function addDoneActionItem(item:ActionItem) : void
{
	doneActionItemsArray.push(item);
}

private function countLateActionItems() : int
{
	var ct:int = 0;
	
	for each(var item:ActionItem in actionItemsArray)
	{
		if(parseString(item.getDues()) == "Late")
			ct++;
	}	
	
	return ct;
}

private function countTodoActionItems() : int
{
	var ct:int = 0;
	
	for each(var item:ActionItem in actionItemsArray)
	{
		if(parseString(item.getDues()) == "To do")
			ct++;
	}	
	
	return ct;
}

private function parseString(date:String) : String
{
	//Lembrar que retorna meses 0-11 e dias 0-30
	var currentDate:Date = new Date();
	
	//AAAA-MM-DD
	var ret:String = "";
	var splitStrings:Array = date.split("-");
	
	if(currentDate.fullYear > parseInt(splitStrings[0]))
		return ("Late");
	if(currentDate.fullYear < parseInt(splitStrings[0]))
		return ("To do");
	if(currentDate.month > parseInt(splitStrings[1])-1)
		return ("Late");
	if(currentDate.month < parseInt(splitStrings[1])-1)
		return ("To do");
	if(currentDate.day > parseInt(splitStrings[2])-1)
		return ("Late");
	else return ("To do");		
}

private function markAsDone(event : Event) : void
{
	var i:int;
	for(i=0; i<actionItemsArray.length; i++)
	{
		if(checksArray[i].selected == true)
		{
			//Mudar label corrente, enviar request do corrente
			labelsArray[i].setStyle("color",0x009900);
			sendMarkAsDoneHTTPRequest(actionItemsArray[i]);
			
			//Mudar corrente para array de feitos
			//E fazer shift left ao array de por fazer
			doneActionItemsArray.push(actionItemsArray[i]);
			
			var j:int;
			for(j=i; j<actionItemsArray.length-1; j++)
			{
				actionItemsArray[i] = actionItemsArray[i+1];								
			}
			actionItemsArray[actionItemsArray.length-1] = null;
							
		}		
	}			
}

private function unmarkAsDone(event : Event) : void
{
	
}
