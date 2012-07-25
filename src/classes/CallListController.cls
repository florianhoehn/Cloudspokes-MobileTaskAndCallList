public with sharing class CallListController {
        public List<Task> incomingCallTypeTasks {
                get {
                        return [SELECT Id, Who.Name, Done__c, Call_Type__c, Description, CreatedDate, Who.Phone
                                  FROM Task
                                 WHERE Call_Type__c = 'Incoming'
                                   AND Done__c = false];
                }
        }
        public List<Task> outgoingCallTypeTasks {
                get {
                        return [SELECT Id, Who.Name, Done__c, Call_Type__c, Description, CreatedDate, Who.Phone
                                  FROM Task
                                 WHERE Call_Type__c = 'Outgoing'
                                   AND Done__c = false];
                }
        }
        public List<Task> pendingCallTypeTasks {
                get {
                        return [SELECT Id, Who.Name, Done__c, Call_Type__c, Description, CreatedDate, Who.Phone
                                  FROM Task
                                 WHERE Call_Type__c = 'Pending'
                                   AND Done__c = false];
                }
        }
}