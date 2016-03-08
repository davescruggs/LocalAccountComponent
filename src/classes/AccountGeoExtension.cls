public with sharing class AccountGeoExtension {


    @AuraEnabled
    public static List<Account> getLocalAccounts(Double latitude, Double longitude, Double maxDistance){
        System.debug('searching for latitude: ' + latitude + ' longitude: '  + longitude + ' distance: ' + maxDistance);
        List<Account> localAccounts = [SELECT Name, Id, Owner.FirstName, Owner.LastName,
                  Permanent_Partner_Manager__c, Partner_Manager__c, BillingLatitude, BillingLongitude
                 FROM Account
                 WHERE DISTANCE(BillingAddress, GEOLOCATION(:latitude, :longitude), 'mi') < :maxDistance
                 ORDER BY DISTANCE(BillingAddress, GEOLOCATION(:latitude, :longitude), 'mi')];
        System.debug(' Found ' + localAccounts.size() + ' accounts');
        return localAccounts;
    }
    @AuraEnabled
    public static List<Account> findLocalAccounts(Double latitude, Double longitude, Double maxDistance){
        System.debug('searching for latitude: ' + latitude + ' longitude: '  + longitude + ' distance: ' + maxDistance);
        return [SELECT Name, Id, Owner.FirstName, Owner.LastName,
                  Permanent_Partner_Manager__c, Partner_Manager__c, BillingLatitude, BillingLongitude
                 FROM Account
                 WHERE DISTANCE(BillingAddress, GEOLOCATION(:latitude, :longitude), 'mi') < :maxDistance
                 ORDER BY DISTANCE(BillingAddress, GEOLOCATION(:latitude, :longitude), 'mi')];
    }

    @AuraEnabled
    public static String greeting(String caller){
      return 'Hello ' + caller;
    }

    // @AuraEnabled
    // public static Account claimAccount(Id id, Id partnerId){
    //     Account claimedAccount = [SELECT Name, Id, Owner.FirstName, Owner.LastName, Permanent_Partner_Manager__c, Partner_Manager__c
    //                  FROM Account
    //                  WHERE Id = :id];
    //     if (claimedAccount != null){
    //         claimedAccount.Permanent_Partner_Manager__c = true;
    //         claimedAccount.Partner_Manager__c = partnerId;
    //         update claimedAccount;
    //     }
    //     return claimedAccount;
    // }

    // @AuraEnabled
    // public static Account getAccount(Id id){
    //     Account account = [
    //         SELECT Id, Name, BillingStreet, BillingCity, BillingState, BillingLatitude, BillingLongitude, Owner.FirstName, Owner.LastName
    //         FROM Account
    //         WHERE Id = :id
    //         ];
    //     return account;
    // }



}
