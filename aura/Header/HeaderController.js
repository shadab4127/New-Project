({
    doInit : function(component, event, helper) {
        var ShowResultValue = event.getParam("Pass_Result");
        component.set("v.Get_Result",ShowResultValue );
        var action = component.get('c.getcalculateactual');
		action.setParams({
			"userId": $A.get("$SObjectType.CurrentUser.Id"),
		});
		action.setCallback(this, function (a) {
			if (a.getState() === 'SUCCESS') {
				var percVal = a.getReturnValue();
                component.set("v.Get_Result",percVal );
			}
		});
		$A.enqueueAction(action);
    }
})