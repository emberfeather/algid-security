<cfcomponent extends="algid.inc.resource.base.event" output="false">
<cfscript>
	/* required content */
	public void function onIPChange( struct transport, string lastIP, string remote_addr ) {
		var eventLog = '';
		
		// Get the event log from the transport
		eventLog = arguments.transport.theApplication.managers.singleton.getEventLog();
		
		// Log the successful login event
		eventLog.logEvent('security', 'ipChanged', 'IP address changed from ''' & arguments.lastIP & ''' to ''' & arguments.remote_addr & '''.');
	}
</cfscript>
</cfcomponent>
