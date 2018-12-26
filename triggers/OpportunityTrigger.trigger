trigger OpportunityTrigger on Opportunity (after update) {
    OpportunityTriggerHandler handler = new OpportunityTriggerHandler(Trigger.isExecuting, Trigger.size);
    if(Trigger.isUpdate && Trigger.isAfter && OpportunityTriggerHandler.isAfterUpdateFirstRun){
        handler.onAfterUpdate(Trigger.old, Trigger.oldMap, Trigger.new, Trigger.newMap);
    }
}