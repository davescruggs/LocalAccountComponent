({
  clearSearchText: function(component, event, helper) {},
  searchKeyChange: function(component, event, helper) {},
  jsLoaded: function(component, event, helper) {
    //debugger; // find out what may be going wrong in latest version
    console.log('getting location');
    helper.getLocation(component, helper);
    helper.sayHello(component, helper);
    console.log('getting map');
      console.log('latitude: ' + component.get("v.latitude"));
      console.log('longitude: ' + component.get("v.longitude"));
      console.log('max distance: ' + component.get("v.maxDistance"));
  }
})
