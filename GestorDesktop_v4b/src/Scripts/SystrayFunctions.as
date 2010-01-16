// ActionScript file
import flash.display.Loader;
import flash.events.Event;
import flash.net.URLRequest;

import mx.controls.Alert;
import mx.events.CloseEvent;

private var dockImage:BitmapData;

private static var blueFlag:String = "http://jeknowledge.pt/media/icons/cog_delete.png"
private static var greenFlag:String = "http://jeknowledge.pt/media/icons/flag_green.png"
private static var redFlag:String = "http://jeknowledge.pt/media/icons/flag_red.png"
private static var yellowFlag:String = "http://jeknowledge.pt/media/icons/flag_yellow.png"

public static var isMinimized:Boolean = false;

private function startupTrayIcon() : void
{
	//Use the loader object to load an image, which will be used for the systray       //After the image has been loaded into the object, we can prepare the application       //for docking to the system tray 
      var loader:Loader = new Loader();
      loader.contentLoaderInfo.addEventListener(Event.COMPLETE, prepareForSystray);      
      
      if(!isLoggedIn)
      	loader.load(new URLRequest(blueFlag));      
      else if(countLateActionItems() > 0)
      	loader.load(new URLRequest(redFlag));
      else if(countTodoActionItems() > 0)
      	loader.load(new URLRequest(yellowFlag));
      else 
      	loader.load(new URLRequest(greenFlag));
       
      //Catch the closing event so that the user can decide if it wants to dock or really       //close the application 
      this.addEventListener(Event.CLOSING, closingApplication);
}

private function changeIcon() : void
{
	var loader:Loader = new Loader();
    loader.contentLoaderInfo.addEventListener(Event.COMPLETE, prepareForSystray); 
      
	if(!isLoggedIn)
      	loader.load(new URLRequest(blueFlag));      
    else if(countLateActionItems() > 0)
  		loader.load(new URLRequest(redFlag));
  	else if(countTodoActionItems() > 0)
  		loader.load(new URLRequest(yellowFlag));
 	else 
  		loader.load(new URLRequest(greenFlag));
}

private function closingApplication(evt:Event):void 
{
  	//Don't close, so prevent the event from happening 
  	evt.preventDefault();
   
  	//Check what the user really want's to do       //Alert.buttonWidth = 110; 
  	Alert.yesLabel = "Close";
  	Alert.noLabel = "Minimize";
  	Alert.show("Close or minimize?", "Close?", 3, this, alertCloseHandler);
}

   // Event handler function for displaying the selected Alert button. 
private function alertCloseHandler(event:CloseEvent):void 
{
  	if (event.detail==Alert.YES) {
     	closeApp(event);
  	} else {
  		changeIcon();
     	stage.nativeWindow.visible = false;
  	}
}


public function prepareForSystray(event:Event):void 
{
	//Retrieve the image being used as the systray icon 
  	dockImage = event.target.content.bitmapData;
   
  	//For windows systems we can set the systray props       //(there's also an implementation for mac's, it's similar and you can find it on the net... ;) ) 
  	if (NativeApplication.supportsSystemTrayIcon)
  	{
     	setSystemTrayProperties();
      
     	//Set some systray menu options, so that the user can right-click and access functionality          //without needing to open the application          
		SystemTrayIcon(NativeApplication.nativeApplication .icon).menu = createSystrayRootMenu();
  	}
  	
  	NativeApplication.nativeApplication.icon.bitmaps = [dockImage];
}

private function createSystrayRootMenu():NativeMenu
{
  	//Add the menuitems with the corresponding actions 
  	var menu:NativeMenu = new NativeMenu();
  	var openNativeMenuItem:NativeMenuItem = new NativeMenuItem(getTooltip());
  	var exitNativeMenuItem:NativeMenuItem = new NativeMenuItem("Exit");

  	//What should happen when the user clicks on something...       

  	openNativeMenuItem.addEventListener(Event.SELECT, undock);
  	exitNativeMenuItem.addEventListener(Event.SELECT, closeApp);

  	//Add the menuitems to the menu 
  	menu.addItem(openNativeMenuItem);
  	menu.addItem(new NativeMenuItem("",true));
  	//separator 
  	menu.addItem(exitNativeMenuItem);
   
  	return menu;
}
 
private function setSystemTrayProperties():void
{
  	//Text to show when hovering of the docked application icon       
	SystemTrayIcon(NativeApplication.nativeApplication .icon).tooltip = getTooltip();
   
  	//We want to be able to open the application after it has been docked       
	SystemTrayIcon(NativeApplication.nativeApplication .icon).addEventListener(MouseEvent.CLICK, undock);
   
  	//Listen to the display state changing of the window, so that we can catch the minimize       
	stage.nativeWindow.addEventListener(NativeWindowDisplayStateEvent.DISPLAY_STATE_CHANGING, nwMinimized); //Catch the minimize event 
}

private function nwMinimized(displayStateEvent:NativeWindowDisplayStateEvent):void 
{
  	//Do we have an minimize action?       //The afterDisplayState hasn't happened yet, but only describes the state the window will go to,       //so we can prevent it! 
  	if(displayStateEvent.afterDisplayState == NativeWindowDisplayState.MINIMIZED) 
  	{
	 	//Prevent the windowedapplication minimize action from happening and implement our own minimize          //The reason the windowedapplication minimize action is caught, is that if active we're not able to          //undock the application back neatly. The application doesn't become visible directly, but only after clicking          //on the taskbars application link. (Not sure yet what happens exactly with standard minimize) 
	 	displayStateEvent.preventDefault();
	      
	 	//Dock (our own minimize) 
	 	stage.nativeWindow.visible = false;
  	}
}
 
public function undock(evt:Event):void {
  	//After setting the window to visible, make sure that the application is ordered to the front,       //else we'll still need to click on the application on the taskbar to make it visible 
  	stage.nativeWindow.visible = true;
  	stage.nativeWindow.orderToFront();
}


private function closeApp(evt:Event):void {
  	stage.nativeWindow.close();
}
   
private function getTooltip() : String
{
	var late:int = countLateActionItems();
	var todo:int = countTodoActionItems();
	
	if(!isLoggedIn)
		return "Not logged in";
	if(actionItemsArray.length == 0)
		return "No ActionItems";	
	if(late > 0)
		return late+" ActionItems late, "+todo+" to do";
	else
		return todo+" ActionItems to do";
	
}