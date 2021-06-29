@isTest public class TestSumofWeightage {
    @isTest public static void testinsertWeightage(){
        Decimal sum=0;
        Progress_Bar_Question__c p = new Progress_Bar_Question__c();
        p.Field_Api_Name__c = 'Email';
        p.Object_Name__c = 'Contact';
        p.Question__c = 'Enter Email';
        p.Weightage__c = 120;
        Database.SaveResult result = Database.insert(p, false);
        List<Progress_Bar_Question__c> pb=[select id,Weightage__c from Progress_Bar_Question__c LIMIT 50000];
        for(Progress_Bar_Question__c prog:pb){
            sum=sum+prog.Weightage__c;
        }
        if(sum > 100){
            System.assertEquals('The total sum of weightage of all questions should not be greater than 100.',result.getErrors()[0].getMessage());
        }
    }
    @isTest public static void testUpdateWeightage(){
        Decimal sum=0;
        Progress_Bar_Question__c p = new Progress_Bar_Question__c();
        p.Field_Api_Name__c = 'Email';
        p.Object_Name__c = 'Contact';
        p.Question__c = 'Enter Email';
        p.Weightage__c = 70;
        Database.SaveResult insertResult = Database.insert(p, false);
        p.Weightage__c=40;
        Database.SaveResult updateResult = Database.update(p, false);
        List<Progress_Bar_Question__c> pb=[select id,Weightage__c from Progress_Bar_Question__c LIMIT 50000];
        for(Progress_Bar_Question__c prog:pb){
            sum=sum+prog.Weightage__c;
        }
        if(sum > 100){
            System.assertEquals('The total sum of weightage of all questions should not be greater than 100.',updateResult.getErrors()[0].getMessage());
        }
    }
}