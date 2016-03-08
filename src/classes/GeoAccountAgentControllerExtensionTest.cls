@isTest
private class GeoAccountAgentControllerExtensionTest {

	@isTest static void test_method_one() {
		Account stub = new Account(Name = 'foobar');
		insert stub;
		GeoAccountAgentControllerExtension.claimAvailableAccount(stub.Id);
	}



}