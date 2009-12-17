<cfcomponent extends="algid.inc.resource.plugin.configure" output="false">
	<cffunction name="onRequestStart" access="public" returntype="void" output="false">
		<cfargument name="theApplication" type="struct" required="true" />
		<cfargument name="theSession" type="struct" required="true" />
		<cfargument name="theRequest" type="struct" required="true" />
		<cfargument name="theUrl" type="struct" required="true" />
		<cfargument name="theForm" type="struct" required="true" />
		<cfargument name="targetPage" type="string" required="true" />
		
		<cfset var eventLog = '' />
		<cfset var lastIP = '' />
		<cfset var objSession = '' />
		<cfset var resetSessionOnIPChange = '' />
		
		<!--- Get the setting for the session reset on IP change --->
		<cfset resetSessionOnIPChange = arguments.theApplication.managers.plugin.getSecurity().getResetSessionOnIPChange() />
		
		<!--- Check for a change in the ip address --->
		<cfif resetSessionOnIPChange>
			<!--- Get the session object --->
			<cfset objSession = arguments.theSession.managers.singleton.getSession() />
			
			<!--- Check if we already have a ipAddress stored --->
			<cfset lastIP = objSession.getIPAddress() />
			
			<cfif lastIP eq ''>
				<!--- If no previous IP, store the current one --->
				<cfset objSession.setIPAddress(cgi.remote_addr) />
			<cfelseif lastIP neq cgi.remote_addr>
				<!--- Get the event log --->
				<cfset eventLog = arguments.theApplication.managers.singleton.getEventLog() />
				
				<!--- Log the successful login event --->
				<cfset eventLog.logEvent('security', 'ipChanged', 'IP address changed from ''' & lastIP & ''' to ''' & cgi.remote_addr & '''.') />
				
				<!--- The IP addresses to not match, reset the session --->
				<cfset arguments.theSession.sparkplug = createObject('component', 'algid.inc.resource.session.sparkplug').init() />
				
				<!--- Start the session --->
				<cfset arguments.theSession.sparkplug.start( arguments.theApplication, arguments.theSession ) />
				
				<!--- Get the new session object --->
				<cfset objSession = arguments.theSession.managers.singleton.getSession() />
				
				<!--- Store the new IP --->
				<cfset objSession.setIPAddress(cgi.remote_addr) />
			</cfif>
		</cfif>
	</cffunction>
</cfcomponent>