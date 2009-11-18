package Classes
{
	public class ActionItem
	{
		private var title:String;
		private var actionItemID:String;
		
		private var project_id:int;
		private var project_name:String;
		private var targets_user:String;
		private var targetsArray:Array = new Array();
		
		private var description:String;
		private var due_date:String;
		private var priority:int;
		
		private var xmlForm:String;
		
		private var author_user_login:String;
		private var author_user_id:int;
		private var author_user_name:String;
		
		private var isCurrent:Boolean = false;
		
		public function ActionItem(inTitle:String, inActionID:String, inProjectID:int, inProjectName:String, inDues:String, inPriority:int, inDescription:String, inTargets_user:String, inAuthor_user_login:String, inAuthor_user_id:int, inAuthor_user_name:String)
		{
			title = inTitle;
			actionItemID = inActionID;
			
			project_id = inProjectID;
			project_name = inProjectName;
			due_date = inDues;
			priority = inPriority;
			description = inDescription;
			targets_user = inTargets_user;
			
			author_user_login = inAuthor_user_login;
			author_user_id = inAuthor_user_id;
			author_user_name = inAuthor_user_name;			
		}
		
		public function setXML(arg:String) : void
		{
			this.xmlForm = arg;
		}
		public function getTargetsArray() : Array
		{
			return targetsArray;
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
		public function getCurrent() : Boolean
		{
			return isCurrent;
		}
		public function setCurrent(value : Boolean) : void
		{
			isCurrent = value;
		}
		public function getTargets() : String
		{
			return targets_user;
		}
		public function addTargetsEntry(entry:String) : void
		{
			targets_user += "\t"+entry+"\n";
		}
	}
}