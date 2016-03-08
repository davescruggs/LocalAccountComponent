@isTest
private class AccountGeoExtensionTest {

	@isTest static void testGetLocalAccounts() {
		// Implement test code
		Double startLatitude = 37.784173;
		Double startLongitude = -122.401557;
		Double range = 50;
		Account aOne = new Account(Name = 'Foo');
		aOne.BillingLatitude = startLatitude + 0.05;
		aOne.BillingLongitude = startLongitude + 0.05;
		insert aOne;
		Account aTwo = new Account(Name = 'Bar');
		aOne.BillingLatitude = startLatitude - 0.05;
		aOne.BillingLongitude = startLongitude - 0.05;
		insert aTwo;
		List<Account> accounts = AccountGeoExtension.getLocalAccounts(startLatitude, startLatitude, range);
		System.Assert(accounts != null);
	}

	@isTest static void test_method_two() {
		// Implement test code
	}

}