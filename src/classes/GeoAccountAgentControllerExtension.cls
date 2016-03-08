public with sharing class GeoAccountAgentControllerExtension {

	// private final Account myAccount;
	//
  //   // The extension constructor initializes the private member
  //   // variable mysObject by using the getRecord method from the standard
  //   // controller.
  //   public GeoAccountAgentControllerExtension(ApexPages.StandardController stdController) {
  //       this.myAccount = (Account)stdController.getRecord();
  //   }
	//
  //   public String getRecordName() {
  //       return 'Hello ' + (String)myAccount.get('name') + ' (' + (Id)myAccount.get('Id') + ')';
  //   }

		@AuraEnabled
		public static void claimAvailableAccount(String accountId) {
			Account acct = [SELECT Name, Id, Owner.FirstName, Owner.LastName, Permanent_Partner_Manager__c, Partner_Manager__c
									FROM Account WHERE Id = :accountId];
            System.debug('Claiming account ' + acct.Name + '  ID: ' + acct.Id);
            Id currentUserId =  UserInfo.getUserId();
            System.debug('User to assign is ' + currentUserId );
			acct.Partner_Manager__c = currentUserId;
			update acct;
	}
}