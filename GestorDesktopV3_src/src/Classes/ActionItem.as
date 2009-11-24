package Classes
{
	public class ActionItem
	{
		private var title:String;
		private var actionItemID:String;
		
		private var project_id:int;
		private var project_name:String;
		
		private var targetsFullNameArray:Array = new Array();
		private var targetsIDArray:Array = new Array();
		
		private var description:String;
		private var due_date:String;
		private var priority:int;
		
		private var xmlForm:String;
		
		private var author_user_login:String;
		private var author_user_id:int;
		private var author_user_name:String;
		
		private var isCurrent:Boolean = false;
		
		public function ActionItem(inTitle:String, inActionID:String, inProjectID:int, inProjectName:String, inDues:String, inPriority:int, inDescription:String, inAuthor_user_login:String, inAuthor_user_id:int, inAuthor_user_name:String)
		{
			title = inTitle;
			actionItemID = inActionID;
			
			project_id = inProjectID;
			project_name = inProjectName;
			due_date = inDues;
			priority = inPriority;
			description = inDescription;
			
			author_user_login = inAuthor_user_login;
			author_user_id = inAuthor_user_id;
			author_user_name = inAuthor_user_name;			
		}
		
		public function setXML(arg:String) : void
		{
			this.xmlForm = arg;
		}
		
		public function getTitle() : String
		{
			return title;
		}
		public function getActionItemID() : String
		{
			return actionItemID;
		}
		public function getProjectID() : int
		{
			return project_id;
		}
		public function getProjectName() : String
		{
			return project_name;	
		}
		public function getDues() : String
		{
			return due_date;
		}
		public function getProjectLink() : String
		{
			return "http://jeknowledge.pt/gestor/api/action_items/"+actionItemID;
		}
		public function getAuthor() : String
		{
			return author_user_login;
		}
		public function getPriority() : int
		{
			return priority;
		}
		public function getDescription() : String
		{
			return description;
		}
		public function getXMLForm() : String
		{
			return xmlForm;
		}
		
		public function getTargetsFullNameArray() : Array
		{
			return targetsFullNameArray;
		}
		
		public function getTargetsIDArray() : Array
		{
			return targetsIDArray;
		}
		
		public function getCurrent() : Boolean
		{
			return isCurrent;
		}
		public function setCurrent(value : Boolean) : void
		{
			isCurrent = value;
		}
		public function makeTargetsText() : String
		{
			var str:String = "";
			
			var i:int;
			for(i=0; i<targetsFullNameArray.length; i++)
			{
				str += "\t"+targetsFullNameArray[i];
				if(i != targetsFullNameArray.length -1)
					str += "\n";
			}
			
			return str;			
		}
	}
}