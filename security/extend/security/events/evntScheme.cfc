<cfcomponent extends="algid.inc.resource.base.event" output="false">
<cfscript>
	public void function onIPChange( required struct transport, required string lastIP, required string remote_addr ) {
		local.eventLog = arguments.transport.theApplication.managers.singleton.getEventLog();
		
		local.eventLog.logEvent('security', 'ipChanged', 'IP address changed from ''' & arguments.lastIP & ''' to ''' & arguments.remote_addr & '''.');
	}
</cfscript>
</cfcomponent>
