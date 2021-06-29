({
    doInit : function(component, event, helper) { 
    	var action = component.get("c.getUser");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") { 
                var result = response.getReturnValue();
             //  console.log('userId---->',result.userId);
              	component.set("v.parentId", result.userId);
                //console.log('userRec---->',result.fullphotourl);
                component.set("v.fullphotourl", result.fullphotourl);
            }
        });
        
        component.set("v.EditPhoto",false);
        $A.enqueueAction(action);
    },
    doSave: function(component, event, helper) {
        
        if (component.find("fileId").get("v.files").length > 0) {
            helper.uploadHelper(component, event);
            component.set("v.currentphotobool",true);
        } else {
            alert('Please Select a Valid File');
        }
    },
 
    handleFilesChange: function(component, event, helper) {
        var fileName = 'No File Selected..';
        if (event.getSource().get("v.files").length > 0) {
            fileName = event.getSource().get("v.files")[0]['name'];
        }
        component.set("v.fileName", fileName);
        component.set("v.EditPhoto",true);
    },
     doClose : function(component, event, helper) {
		component.set("v.istruthy",false);
	},
})