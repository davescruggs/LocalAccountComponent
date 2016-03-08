({
	getLocation: function(component, helper) {
		navigator.geolocation.getCurrentPosition(function(position) {
			this.latitude = component.set("v.latitude", position.coords.latitude);
			this.longitude = component.set("v.longitude", position.coords.longitude);
			console.log(this);
			helper.getAccountsNearby(component, helper);
		}, function() {
			// error default values
			this.latitude = component.set("v.latitude", 37.784173);
			this.longitude = component.set("v.longitude", -122.401557);
			console.log(this);
			helper.getAccountsNearby(component, helper);
		});
	},
	getAccountsNearby: function(cmp, helper) {
		var action = cmp.get("c.findLocalAccounts");
		action.setParams({
			"latitude": cmp.get("v.latitude"),
			"longitude": cmp.get("v.longitude"),
			"maxDistance": cmp.get("v.maxDistance")
		});

        console.log('latitude: ' + cmp.get("v.latitude"));
        console.log('longitude: ' + cmp.get("v.longitude"));
        console.log('max distance: ' + cmp.get("v.maxDistance"));
		action.setCallback(this, function(response) {
			console.log('in getLocalAccount callback client-side method')
			var state = response.getState();
			console.log('response state: ' + state);
			if (state === "SUCCESS") {
					cmp.set("v.accounts", response.getReturnValue());
			    console.log('number of accounts: ' + response.getReturnValue().length);
			    helper.displayMap(cmp);
			    console.log('displayed map');
			    //alert('hello world!');
			} else {
					console.log('callback state: ' + state);
			    helper.displayMap(cmp);
			    console.log('getAccountsNearby Failed');
			}
		});
		console.log('starting enqueueAction');
    //$A.clientService.runActions([action]);
		$A.enqueueAction(action);
		console.log('past enqueueAction');
	},
    displayMap: function(cmp) {
        console.log('map latitude: ' + cmp.get("v.latitude"));
        console.log('map longitude: ' + cmp.get("v.longitude"));
        console.log('map max distance: ' + cmp.get("v.maxDistance"));
        var latitude = cmp.get("v.latitude");
        var longitude = cmp.get("v.longitude");
        var accounts = cmp.get("v.accounts");
       var map = L.map('map', {
         zoomControl: false
       }).setView([latitude, longitude], 14);
       L.tileLayer(
         'https://server.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer/tile/{z}/{y}/{x}', {
           attribution: 'Tiles © Esri'
         }).addTo(map);

       // Add marker [37.784173, -122.401557]
       L.marker([latitude, longitude]).addTo(map).bindPopup('You are here');
        var index = 0;
        for (index = 0; index < accounts.length; ++index) {
            console.log(accounts[index].Id + ' ' + accounts[index].Name);
						console.log('\tcoords: ' + accounts[index].BillingLatitude + ',' + accounts[index].BillingLongitude);
            L.marker([accounts[index].BillingLatitude, accounts[index].BillingLongitude]).addTo(map).bindPopup(accounts[index].Name);
        }
     },
		 sayHello: function(cmp){
			 var action = cmp.get("c.greeting");
			 action.setParams({
				 "caller" : "LightningAccountMapHelper"
			 });
			 action.setCallback(this, function(response) {
					var state = response.getState();
					if (cmp.isValid() && state === "SUCCESS") {
						console.log('Got a response' + response.getReturnValue());
				}
			});
			$A.enqueueAction(action);
		 }

})
