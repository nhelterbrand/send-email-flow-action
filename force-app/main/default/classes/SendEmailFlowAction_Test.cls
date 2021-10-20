@isTest
private class SendEmailFlowAction_Test {

    @isTest static void testSimpleEmail() {
        String testEmailTo = 'test@test.com';
        SendEmailFlowAction.SendEmailRequest req = new SendEmailFlowAction.SendEmailRequest();
        req.toAddresses = new List<String>{testEmailTo};
        req.plainTextBody = 'test body';

        Test.startTest();
        List<SendEmailFlowAction.SendEmailResult> results = SendEmailFlowAction.sendEmails(new List<SendEmailFlowAction.SendEmailRequest>{req});
        Test.stopTest();

        List<EmailMessage> emailMessages = [SELECT Id FROM EmailMessage WHERE ToAddress =: testEmailTo];
        System.assertEquals(1, emailMessages.size());

        for (SendEmailFlowAction.SendEmailResult res : results) {
            System.assertEquals(res.isSuccess, true);
        }
    }

    @isTest static void testSimpleEmailException() {
        String testEmailTo = 'test@test.com';
        SendEmailFlowAction.SendEmailRequest req = new SendEmailFlowAction.SendEmailRequest();
        req.toAddresses = new List<String>{testEmailTo};

        Test.startTest();
        try {
            List<SendEmailFlowAction.SendEmailResult> results = SendEmailFlowAction.sendEmails(new List<SendEmailFlowAction.SendEmailRequest>{req});
        } catch (SendEmailFlowAction.SendEmailFlowActionException e) {
            System.assertNotEquals(null, e.getMessage());
        }

        Test.stopTest();
    }
}