component {
	public component function init() {
		variables.bcrypt = createObject('java', 'jBCrypt.BCrypt', '/plugins/security/inc/lib/jbcrypt.jar').init();
		
		return this;
	}
	
	public boolean function checkpw(required string plaintext, required string hashed) {
		return variables.bcrypt.checkpw(arguments.plaintext, arguments.hashed);
	}
	
	public string function gensalt() {
		switch(arrayLen(arguments)) {
		case 2:
			return variables.bcrypt.gensalt(arguments[1], arguments[2]);
			
			break;
		case 1:
			return variables.bcrypt.gensalt(arguments[1]);
			
			break;
		}
		
		return variables.bcrypt.gensalt();
	}
	
	public string function hashpw(required string password, required string salt) {
		return variables.bcrypt.hashpw(arguments.password, arguments.salt);
	}
}
