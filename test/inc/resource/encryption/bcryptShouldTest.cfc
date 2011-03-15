component extends="mxunit.framework.TestCase" {
	public function setup() {
		variables.bcrypt = createObject('component', 'plugins.security.inc.resource.encryption.bcrypt').init();
	}
	
	public void function testHashedValueChecks() {
		local.plainText = 'HashingAPassword';
		local.hashed = variables.bcrypt.hashpw(local.plainText, variables.bcrypt.gensalt());
		
		assertTrue(variables.bcrypt.checkpw(local.plainText, local.hashed));
	}
	
	public void function testHashedValueChecksWithLogRounds() {
		local.plainText = 'HashingAPassword';
		local.hashed = variables.bcrypt.hashpw(local.plainText, variables.bcrypt.gensalt(12));
		
		assertTrue(variables.bcrypt.checkpw(local.plainText, local.hashed));
	}
	
	public void function testHashedValueChecksWithLogRoundsAndRandom() {
		local.plainText = 'HashingAPassword';
		local.random = createObject('java', 'java.security.SecureRandom').init();
		local.hashed = variables.bcrypt.hashpw(local.plainText, variables.bcrypt.gensalt(11, local.random));
		
		assertTrue(variables.bcrypt.checkpw(local.plainText, local.hashed));
	}
}
