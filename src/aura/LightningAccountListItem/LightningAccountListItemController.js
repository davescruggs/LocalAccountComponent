({
	claimAccount: function(component, event, helper) {
		// Name, Id, Owner.FirstName, Owner.LastName, Permanent_Partner_Manager__c, Partner_Manager__c
		var account = component.get("v.account");
		console.log('account: ' + account);
		var action = component.get("c.claimAvailableAccount");
		action.setParams({
			"accountId": component.get("v.account.Id")
		});
		console.log("accountId: " + component.get("v.account.Id"));

		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var editRecordEvent = $A.get("e.force:editRecord");
				editRecordEvent.setParams({
					"recordId": component.get("v.account.Id")
				});
				editRecordEvent.fire();
			} else {
				console.log('claimAccount Failed');
			}
		});

		$A.enqueueAction(action);
	},
    editAccount: function(component, event, helper){
        var editRecordEvent = $A.get("e.force:editRecord");
        editRecordEvent.setParams({
            "recordId": component.get("v.account.Id")
        });
        editRecordEvent.fire();
    },
	claimable: function(component, event, helper) {
        console.log('in claimable');
		var account = component.get("v.account");
		console.log('claimable - account: ' + account.Id +
			' Permanent Partner Manager: ' + account.Permanent_Partner_Manager__c +
			'  Partner_Manager__c: (' + account.Partner_Manager__c + ')');
		return account.Permanent_Partner_Manager__c == false && !account.Partner_Manager__c;
	}, 
    doInit: function(component, event, helper) {
        console.log('in list item doInit');
		var account = component.get("v.account");
        var claimable = component.get("v.isClaimable");
		console.log('claimable - account: ' + account.Id +
			' Permanent Partner Manager: ' + account.Permanent_Partner_Manager__c +
			'  Partner_Manager__c: (' + account.Partner_Manager__c + ')');
        if(account.Permanent_Partner_Manager__c == false && !account.Partner_Manager__c){
        	component.set("v.isClaimable", true);
            console.log(account.Id + "is claimable");
        } else {
        	component.set("v.isClaimable", false);
            console.log(account.Id + "is not claimable");
        }
    }
})