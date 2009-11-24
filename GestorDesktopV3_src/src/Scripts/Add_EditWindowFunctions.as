// ActionScript file
import mx.collections.ArrayCollection;

private function makeTargetList(projectName:String) : void
{
	var targets:ArrayCollection = new ArrayCollection();	
	
	targets.addItem("Vasco Patricio");
	addActionItemWindow.currentUserIDs.push("60");
	targets.addItem("Pedro Gaspar");
	addActionItemWindow.currentUserIDs.push("1");
	targets.addItem("Sérgio Santos");
	addActionItemWindow.currentUserIDs.push("2");
	
	addActionItemWindow.targetList.dataProvider = targets;
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