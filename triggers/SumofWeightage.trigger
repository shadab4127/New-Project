trigger SumofWeightage on Progress_Bar_Question__c (before insert,before update) {
    Set<ID> se=new Set<ID>();
    Decimal sum=0;
       if(Trigger.isinsert){
         List<Progress_Bar_Question__c> pb=[select id,Weightage__c from Progress_Bar_Question__c LIMIT 50000];  
            for(Progress_Bar_Question__c p: pb){
                sum=sum+p.Weightage__c;
            }
            for(Progress_Bar_Question__c p : trigger.new){
                sum=sum+p.Weightage__c; 
                if(sum>100){
                    p.Weightage__c.addError('The total sum of weightage of all questions should not be greater than 100.');
                }
            }
        }
        if(Trigger.isupdate){
         for(Progress_Bar_Question__c p : trigger.new){
             se.add(p.id);
         }
         List<Progress_Bar_Question__c> pb=[select id, Weightage__c from Progress_Bar_Question__c where NOT (ID IN:se)];
            for(Progress_Bar_Question__c p : pb){
             sum=sum+p.Weightage__c;
         }
            for(Progress_Bar_Question__c p : trigger.new){
                sum=sum+p.Weightage__c;
                if(sum>100){
                    p.Weightage__c.addError('The total sum of weightage of all questions should not be greater than 100.');
                }
            } 
        }    
}