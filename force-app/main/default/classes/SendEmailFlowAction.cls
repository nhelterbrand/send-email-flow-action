global with sharing class SendEmailFlowAction {

    @InvocableMethod(label='Send Email Flow Action' description='Sends Email with options for attachments and templates')
    global static List<SendEmailResult> sendEmail(List<SendEmailRequest> sendEmailRequests) {
        List<SendEmailResult> sendEmailResults = new List<SendEmailResult>();

        for (SendEmailRequest ser : sendEmailRequests) {
            Messaging.SingleEmailMessage emailMessage = new Messaging.SingleEmailMessage();

            emailMessage.setTargetObjectId(ser.targetObjectId);
            emailMessage.setSenderDisplayName(ser.senderDisplayName);
            emailMessage.setReplyTo(ser.replyTo);
            emailMessage.setUseSignature(ser.useSignature);

            if (ser.bccSender != null) {
                emailMessage.setBccSender(ser.bccSender);
            }

            emailMessage.setSaveAsActivity(ser.saveAsActivity);
            emailMessage.setTemplateID(ser.emailTemplateId);
            emailMessage.setWhatId(ser.emailWhatId);
            emailMessage.toAddresses = ser.toAddresses;

            List<Id> idList = new List<Id>();

            if (ser.contentVersions != null) {
                for (ContentVersion recs : ser.contentVersions) {
                    idList.add(String.valueOf(recs.Id));
                }
            }

            if (ser.documents != null) {
                for (Document docs : ser.documents) {
                    idList.add(String.valueOf(docs.Id));
                }
            }

            if (ser.attachments != null) {
                for (Attachment atts : ser.attachments) {
                    idList.add(String.valueOf(atts.Id));
                }
            }

            if (!idList.isEmpty()) {
                emailMessage.setEntityAttachments(idList);
            }

            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {emailMessage};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);

            SendEmailResult ser;
            for (Messaging.SendEmailResult result : results) {
                ser = new SendEmailResult();
                ser.isSuccess = result.isSuccess();
                ser.errorMessage = result.getErrors();
                sendEmailResults.add(ser);
            }

            return sendEmailResults;
        }
    }

    global class SendEmailRequest {
        @InvocableVariable(required=true label='Target Object Record ID' description='Represents the Record ID that the Email will be attached to')
        global Id targetObjectId;

        @InvocableVariable(required=true label='Sender Display Name')
        global String senderDisplayName;

        @InvocableVariable(required=true label='Reply To Email Address')
        global String replyTo;

        @InvocableVariable(label='Use Signature?')
        global Boolean useSignature = false;

        @InvocableVariable(label='BCC Email Address')
        global Boolean bccSender = false;

        @InvocableVariable(label='Save as Activity?')
        global Boolean saveAsActivity = false;

        @InvocableVariable(required=true)
        global Id emailTemplateId;

        @InvocableVariable(required=true)
        global Id emailWhatId;

        @InvocableVariable(required=true)
        global String[] toAddresses;

        @InvocableVariable
        global List<ContentVersion> contentVersions;

        @InvocableVariable
        global List<Document> documents;

        @InvocableVariable
        global List<Attachment> attachments;
    }

    global class SendEmailResult {
        @InvocableVariable
        global Boolean isSuccess;

        @InvocableVariable
        global String errorMessage;
    }
}