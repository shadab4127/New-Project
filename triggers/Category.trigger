trigger Category on Category__c(before Insert,before Update) {
    TriggerDispatcher.run(new CategoryTriggerHandler());
}