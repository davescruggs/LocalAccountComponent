global class BatchLatLongGenerator implements Database.Batchable<sObject>, Database.AllowsCallouts {

  String query;


  global BatchLatLongGenerator() {

    query = 'Select Id, Name, BillingLatitude,BillingLongitude,BillingStreet,BillingCity,BillingState, BillingCountry,BillingPostalCode from Account';
  }

  global Database.QueryLocator start(Database.BatchableContext BC) {
    return Database.getQueryLocator(query);
  }

  global void execute(Database.BatchableContext BC, List<sObject> scope) {

    for(Account acc : (List<Account>)scope){
      system.debug('Starting encode for account ' + acc.Name);
      string address='';

      if(acc.BillingStreet!=null){
        address += acc.BillingStreet+',';
      }
      if(acc.BillingCity !=null){
        address += acc.BillingCity+',';
      }
      if(acc.BillingState!=null){
        address +=acc.BillingState+',';
      }
      if(acc.BillingCountry!=null){
        address += acc.BillingCountry+',';
      }
      if(acc.BillingPostalCode!=null){
        address += acc.BillingPostalCode+',';
      }
      /* if address is not blank then get the latitude and longitude through google api */
      if(address !=''){
        HttpRequest req = new HttpRequest();
        system.debug('Address is not blank');
        /* Encode address */
        address = EncodingUtil.urlEncode(address,'UTF-8');
        system.debug('address is ' + address);
        req.setEndPoint('https://maps.googleapis.com/maps/api/geocode/xml?address='+address+'&sensor=true');
        req.setMethod('GET');
        Http http = new Http();
        HttpResponse res;
        if(!Test.isRunningTest()){
          res = http.send(req);
        }else{
          /* create sample data for test method */
          String resString = '<GeocodeResponse><status>OK</status><result><geometry><location><lat>37.4217550</lat> <lng>-122.0846330</lng></location>';
          resString +='</geometry> </result> </GeocodeResponse>';
          res = new HttpResponse();
          res.setBody(resString);
          res.setStatusCode(200);

        }

        System.debug('response code ' + res.getStatusCode());
        Dom.Document doc = res.getBodyDocument();
        /* Get the root of xml response */
        Dom.XMLNode geocodeResponse = doc.getRootElement();
        if(geocodeResponse!=null){
          /* Get the result tag of xml response */
          system.debug('geocodeResponse was not null');
          system.debug('geocodeResponse: \n' + geocodeResponse);
          Dom.XMLNode result = geocodeResponse.getChildElement('result',null);
          if(result!=null){
            /* Get the geometry tag  of xml response */
            system.debug('geolocation result was not null');
            Dom.XMLNode geometry = result.getChildElement('geometry',null);
            if(geometry!=null){
              /* Get the location tag  of xml response */
              system.debug('geometry was not null');
              Dom.XMLNode location = geometry.getChildElement('location',null);
              if(location!=null){
                /* Get the lat and lng tag  of xml response */
                system.debug('location was not null');
                String lat = location.getChildElement('lat', null).getText();
                String lng = location.getChildElement('lng', null).getText();
                system.debug('lat: ' + lat + ' lng: ' + lng);
                try{
                  acc.BillingLatitude =Decimal.valueof(lat);
                  acc.BillingLongitude =Decimal.valueof(lng);
                  system.debug('Encoded '  + acc.Name + ' for ' + acc.BillingLatitude + ' : ' + acc.BillingLongitude);
                }catch(Exception ex){
                  system.debug('Exception '+ex.getMessage());
                }
              } else {
                system.debug('location was null ');
              }
            }
          }
        }
      }

    }

    update scope;

  }

  global void finish(Database.BatchableContext BC) {
    //create a mail object to send a single email.
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    User u =[select email,name from user where id=: userinfo.getUserId() limit 1];
    //set the email properties
    mail.setToAddresses(new string[] {u.email});
    mail.setSubject('Case Latitude Longitude batch completed');
    String body='';
    body +='Hi '+u.name+',';
    body+='<br/><br/>Account Latitude Longitude Calulation Batch is complete';
    body+='<br/><br/>Thank,<br/>Admin';
    mail.setHtmlBody(body);
    mail.setPlainTextBody('Account Latitude Longitude Calulation Batch is complete');
    //send the email
    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail } );
  }

}