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
		if(searchTextField.text.length > 0 && searchTextField.text != "search")
			if((item.getTitle().toUpperCase()).indexOf(searchTextField.text.toUpperCase()) < 0)
				continue;
		
		//Criar label do item	
		text = new Label();
		
		if(isLate(item.getDues()))
			dateStringTemp = "Late";
		else
			dateStringTemp = "To do"
		
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
		text.toolTip += item.makeTargetsText();
		
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
		item = doneActionItemsArray[i];
		if(searchTextField.text.length > 0)
			if(item.getTitle().indexOf(searchTextField.text) < 0)
			continue;
		
		text = new Label();
		if(isLate(item.getDues()))
			dateStringTemp = "Late";
		else
			dateStringTemp = "To do";
		
		text.setStyle("color",0x009900);
		text.text = item.getTitle();
		text.width = 200;
		text.x = 5;
		text.y = currentIndex*15;
		text.toolTip = 
			"Title: "+item.getTitle()+"\n"+
			"Project: "+item.getProjectName()+"\n"+
			"Team: \n";
			
		text.toolTip += item.makeTargetsText();
		
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
	
	changeIcon();
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
		if(isLate(item.getDues()) == true)
			ct++;
	}	
	
	return ct;
}

private function countTodoActionItems() : int
{
	var ct:int = 0;
	
	for each(var item:ActionItem in actionItemsArray)
	{
		if(isLate(item.getDues()) == false)
			ct++;
	}	
	
	return ct;
}

private function isLate(date : String) : Boolean
{
	var currentDate:Date = new Date();
	
	//AAAA-MM-DD
	var ret:String = "";
	var splitStrings:Array = date.split("-");
		
	//Se ano maior, nao ta late, se ano ja passou, ta late
	if(currentDate.fullYear > parseInt(splitStrings[0]))
		return true;
	if(currentDate.fullYear < parseInt(splitStrings[0]))
		return false;
	
	//Se ano igual
	if(currentDate.month > parseInt(splitStrings[1])-1)
		return true;
	if(currentDate.month < parseInt(splitStrings[1])-1)
		return false;
	
	//Se mes igual
	if(currentDate.date > parseInt(splitStrings[2])-1)
		return true;
	else return false;		

	//Se acabar neste ano, neste mes e neste dia
	return true;	
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
			
			//Mudar actionItem feito para array de actionItems feitos
			//E fazer shift left ao array de actionItems por fazer
			doneActionItemsArray.push(actionItemsArray[i]);
			
			var j:int;
			for(j=i; j<actionItemsArray.length-1; j++)
			{
				actionItemsArray[i] = actionItemsArray[i+1];								
			}
			actionItemsArray[actionItemsArray.length-1] = null;
			
			return;				
		}
	}			
}

private function unmarkAsDone(event : Event) : void
{
	
}
