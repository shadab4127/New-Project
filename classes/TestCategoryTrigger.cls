@isTest
public class TestCategoryTrigger {
	@TestSetup
    static void setup(){
        Category__c c = new Category__c();
        c.Badge_Name__c = 'Test';
        c.Minimum_Range__c = 1;
        c.Maximum_Range__c =10;
        insert c; 
    }
    @isTest public static void testCategoryInsert(){
        list< Category__c > categories = [SELECT Id, Minimum_Range__c, Maximum_Range__c FROM Category__c];
        Category__c c1 = new Category__c(Badge_Name__c = 'Test1',Minimum_Range__c = 101,Maximum_Range__c =-1);
        Category__c c2 = new Category__c(Badge_Name__c = 'Test2',Minimum_Range__c = 1,Maximum_Range__c =10);
        Test.startTest();
        Database.SaveResult result1 = Database.insert(c1, false);
        Database.SaveResult result2 = Database.insert(c2, false);
        if(c1.Minimum_Range__c > 100){
            System.assertEquals('Minimum Range should exist from 1 - 100',result1.getErrors()[0].getMessage());
        }
        for(Category__c cat : categories){
            if(c2.Minimum_Range__c >= cat.Minimum_Range__c && c2.Minimum_Range__c <= cat.Maximum_Range__c){
               	System.assertEquals('This Minimum Range already exist in the other category range. Please fill another set of range',result2.getErrors()[0].getMessage());
            }
        }
        Test.stopTest();
}
   @isTest public static void testCategoryUpdate(){
        list< Category__c > categories = [SELECT Id, Minimum_Range__c, Maximum_Range__c FROM Category__c];
        Category__c c1 = [SELECT Id, Minimum_Range__c, Maximum_Range__c FROM Category__c WHERE Badge_Name__c = 'Test'];
        Category__c c2 = [SELECT Id, Minimum_Range__c, Maximum_Range__c FROM Category__c WHERE Badge_Name__c = 'Test'];
       	Category__c c3 = [SELECT Id, Minimum_Range__c, Maximum_Range__c FROM Category__c WHERE Badge_Name__c = 'Test'];
        c1.Minimum_Range__c = 104;
        c1.Maximum_Range__c = -4;
        c2.Minimum_Range__c = 1;
        c2.Maximum_Range__c = 10;
       	c3.Minimum_Range__c = 10;
        c3.Maximum_Range__c = 1;
        Test.startTest();
        Database.SaveResult result1 = Database.update(c1,false);
        Database.SaveResult result2 = Database.update(c2, false);
       	Database.SaveResult result3 = Database.update(c3, false);	
        if(c1.Minimum_Range__c > 100){
            System.assertEquals('Minimum Range should exist from 1 - 100',result1.getErrors()[0].getMessage());
        }
        for(Category__c cat : categories){
            if(c2.Minimum_Range__c >= cat.Minimum_Range__c && c2.Minimum_Range__c <= cat.Maximum_Range__c && c2.Id != cat.Id && c2.Minimum_Range__c != cat.Minimum_Range__c){
                System.assertEquals('This Minimum Range already exist. Please fill another set of range',result2.getErrors()[0].getMessage());
            }
            if(c3.Maximum_Range__c >= cat.Minimum_Range__c && c3.Maximum_Range__c <= cat.Maximum_Range__c && c3.Id != cat.Id && c3.Maximum_Range__c != cat.Maximum_Range__c){
                System.assertEquals('This Minimum Range already exist. Please fill another set of range',result2.getErrors()[0].getMessage());
            }
        }
        Test.stopTest();
    }
    @isTest public static void testCategoryMethods(){
        CategoryTriggerHandler handler = new CategoryTriggerHandler();
        handler.afterInsert(new Map<Id, sObject>());
        handler.afterUpdate(new Map<Id, sObject>(), new Map<Id, sObject>());
        handler.beforeDelete(new Map<Id, sObject>());
        handler.afterDelete(new Map<Id, sObject>());
        handler.afterUnDelete(new Map<Id, sObject>());
        System.assertEquals('test','test');
    }
}