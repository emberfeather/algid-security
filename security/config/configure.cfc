component extends="algid.inc.resource.plugin.configure" {
	public void function onRequestStart(required struct theApplication, required struct theSession, required struct theRequest, required struct theUrl, required struct theForm, required string targetPage) {
		var eventLog = '';
		var lastIP = '';
		var objSession = '';
		var observer = '';
		var resetSessionOnIPChange = '';
		
		// Get the setting for the session reset on IP change
		resetSessionOnIPChange = arguments.theApplication.managers.plugin.getSecurity().getResetSessionOnIPChange();
		
		// Check for a change in the ip address
		if (resetSessionOnIPChange) {
			// Get the session object
			objSession = arguments.theSession.managers.singleton.getSession();
			
			// Check if we already have a ipAddress stored
			lastIP = objSession.getIPAddress();
			
			if (lastIP eq '') {
				// If no previous IP, store the current one
				objSession.setIPAddress(cgi.remote_addr);
			} else if (lastIP neq cgi.remote_addr) {
				// Get the event observer
				observer = getPluginObserver('security', 'security');
				
				// IP Change Event
				observer.onIpChange(variables.transport, lastIP, cgi.remote_addr);
				
				// The IP addresses to not match, reset the session
				arguments.theSession.sparkplug = createObject('component', 'algid.inc.resource.session.sparkplug').init();
				
				// Start the session
				arguments.theSession.sparkplug.start( arguments.theApplication, arguments.theSession );
				
				// Get the new session object
				objSession = arguments.theSession.managers.singleton.getSession();
				
				// Store the new IP
				objSession.setIPAddress(cgi.remote_addr);
			}
		}
	}
}
