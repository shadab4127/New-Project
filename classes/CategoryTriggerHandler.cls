public without sharing class CategoryTriggerHandler implements ITriggerHandler{
    //Use this variable to disable this trigger from transaction
     
    //check if the trigger is disabled from transaction
    public void beforeInsert(List<sObject> newList) {
        list< Category__c > cat = (list< Category__c >) newList;
        list< Category__c > categories = [SELECT Id, Minimum_Range__c, Maximum_Range__c FROM Category__c LIMIT 50000];
        for(Category__c c1:cat){
            if(c1.Minimum_Range__c < 1 || c1.Minimum_Range__c > 100){
                c1.Minimum_Range__c.addError('Minimum Range should exist from 1 - 100');
            }
            if(c1.Maximum_Range__c < 1 || c1.Maximum_Range__c > 100){
                c1.Maximum_Range__c.addError('Maximum Range should exist from 1 - 100');
            }
            if(c1.Minimum_Range__c >= c1.Maximum_Range__c){
                c1.Maximum_Range__c.addError(' Maximum Range should be greater than Minimum Range'); 
            }
            for(Category__c c2:categories){
                if(c1.Minimum_Range__c >= c2.Minimum_Range__c && c1.Minimum_Range__c <= c2.Maximum_Range__c ){
                    c1.Minimum_Range__c.addError('This Minimum Range already exist in the other category range. Please fill another set of range');
                }
                if(c1.Maximum_Range__c >= c2.Minimum_Range__c && c1.Maximum_Range__c <= c2.Maximum_Range__c ){
                    c1.Maximum_Range__c.addError('This Maximum Range already exist in the other category range. Please fill another set of range');
                }
            }
        }
    }
    public void afterInsert(Map<Id, sObject> newMap) {}
    public void beforeUpdate(Map<Id, sObject> newMap, Map<Id, sObject> oldMap) {
        Map<Id, Category__c > cat = (Map<Id, Category__c >) newMap;
        list< Category__c > categories = [SELECT Id, Minimum_Range__c, Maximum_Range__c FROM Category__c LIMIT 50000];
          for(Category__c c1:cat.values()){
            if(c1.Minimum_Range__c < 1 || c1.Minimum_Range__c > 100){
                c1.Minimum_Range__c.addError('Minimum Range should exist from 1 - 100');
            }
            if(c1.Maximum_Range__c < 1 || c1.Maximum_Range__c > 100){
                c1.Maximum_Range__c.addError('Maximum Range should exist from 1 - 100');
            }
            if(c1.Minimum_Range__c >= c1.Maximum_Range__c){
                c1.Maximum_Range__c.addError(' Maximum Range should be greater than Minimum Range'); 
            }
              for(Category__c c2:categories){
                  Category__c oldCat = (Category__c)oldMap.get(c1.Id);
                  if(c1.Minimum_Range__c >= c2.Minimum_Range__c && c1.Minimum_Range__c <= c2.Maximum_Range__c 
                     && oldCat.Minimum_Range__c != c1.Minimum_Range__c && c1.Id != c2.Id){
                      c1.Minimum_Range__c.addError('This Minimum Range already exist. Please fill another set of range');
                  }
                  if(c1.Maximum_Range__c >= c2.Minimum_Range__c && c1.Maximum_Range__c <= c2.Maximum_Range__c 
                     && oldCat.Maximum_Range__c != c1.Maximum_Range__c && c1.Id != c2.Id){
                      c1.Maximum_Range__c.addError('This Maximum Range already exist in the other category range. Please fill another set of range');
                  }
              }
          }
    }
    public void afterUpdate(Map<Id, sObject> newMap, Map<Id, sObject> oldMap) {}
    public void beforeDelete( Map<Id, sObject> oldMap) {}
    public void afterDelete( Map<Id, sObject> oldMap) {}
    public void afterUnDelete(Map<Id, sObject> newMap) {}
}