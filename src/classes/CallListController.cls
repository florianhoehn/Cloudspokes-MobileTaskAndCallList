global with sharing class CallListController {
    public CallListController(){}

    public Date today {
        get {
            return system.today();
        }
    }

    public List<Task> incomingCallTypeTasks {
        get {
            return [SELECT Id, Done__c, Call_Type__c, Subject, Description, CreatedDate, Who.Name, Who.Phone, WhoId
                      FROM Task
                     WHERE Call_Type__c = 'Incoming'
                       AND Done__c = false];
        }
    }
    public List<Task> outgoingCallTypeTasks {
        get {
            return [SELECT Id, Done__c, Call_Type__c, Subject, Description, CreatedDate, Who.Name, Who.Phone, WhoId
                      FROM Task
                     WHERE Call_Type__c = 'Outgoing'
                       AND Done__c = false];
        }
    }
    public List<Task> pendingCallTypeTasks {
        get {
            return [SELECT Id, Done__c, Call_Type__c, Subject, Description, CreatedDate, Who.Name, Who.Phone, WhoId
                      FROM Task
                     WHERE Call_Type__c = 'Pending'
                       AND Done__c = false];
        }
    }

    @remoteAction
    global static Boolean saveFollowUptask(Task task, Task doneTask) {
        Boolean response = true;
        try{
            insert task;
            update doneTask;
        } catch (Exception e) {
            response = false;
        }
        return response;
    }

    // UNIT TESTS
    @isTest
    private static void test_getters() {
        Contact contact = new Contact(FirstName = 'FIRSTNAME',
                                      LastName = 'LASTNAME',
                                      Phone = '123456789');
        insert contact;

        Task incomingTask = new Task(WhoId = contact.id,
                                     Done__c = false,
                                     Call_Type__c = 'Incoming',
                                     Description = 'DESCRIPTION');
        insert incomingTask;

        Task outgoingTask = new Task(WhoId = contact.id,
                                     Done__c = false,
                                     Call_Type__c = 'Outgoing',
                                     Description = 'DESCRIPTION');
        insert outgoingTask;

        Task pendingTask = new Task(WhoId = contact.id,
                                     Done__c = false,
                                     Call_Type__c = 'Pending',
                                     Description = 'DESCRIPTION');
        insert pendingTask;

        Test.startTest();
            CallListController controller = new CallListController();
            List<Task> incomingTasks = controller.incomingCallTypeTasks;
            List<Task> outgoingTasks = controller.outgoingCallTypeTasks;
            List<Task> pendingTasks = controller.pendingCallTypeTasks;
            Date today = controller.today;
        Test.stopTest();

        System.AssertEquals(incomingTask.WhoId, incomingTasks.get(0).WhoId);
        System.AssertEquals(incomingTask.id, incomingTasks.get(0).id);

        System.AssertEquals(outgoingTask.WhoId, outgoingTasks.get(0).WhoId);
        System.AssertEquals(outgoingTask.id, outgoingTasks.get(0).id);

        System.AssertEquals(pendingTask.WhoId, pendingTasks.get(0).WhoId);
        System.AssertEquals(pendingTask.id, pendingTasks.get(0).id);
    }

    @isTest
    private static void test_SaveFollowUpTask() {
        Contact contact = new Contact(FirstName = 'FIRSTNAME',
                                      LastName = 'LASTNAME',
                                      Phone = '123456789');
        insert contact;

        Task outgoingTask = new Task(WhoId = contact.id,
                                     Done__c = false,
                                     Call_Type__c = 'Outgoing',
                                     Description = 'DESCRIPTION');
        insert outgoingTask;

        Task incomingTask = new Task(WhoId = contact.id,
                                     Done__c = false,
                                     Call_Type__c = 'Incoming',
                                     Description = 'DESCRIPTION');

        Test.startTest();
            Boolean response = CallListController.saveFollowUptask(incomingTask, outgoingTask);
            Boolean negativeResponse = CallListController.saveFollowUptask(null, null);
        Test.stopTest();

        System.AssertEquals(true, response);
        System.AssertEquals(false, negativeResponse);
    }
}