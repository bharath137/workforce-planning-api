/**
 * @description       : This batch will delegate the callouts to Queue.
 * @author            : Bharath Kumar
 * @group             : 
 * @last modified on  : 09-13-2020
 * @last modified by  : Bharath Kumar
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   09-12-2020   Bharath Kumar   Initial Version
**/
public with sharing class WrkfcePlanDelegatorBatch implements Database.Batchable<sObject> {

    static final String EMPTY = '';
    static final String SINGLE_QUOTE = '\'';
    static final String PENDING = 'Pending';
    
    public  Database.QueryLocator start(Database.BatchableContext batchableContext) {
        /** 
         * Get all the Cases which are
         *  1. Newly moved to Closed hence 'PENDING' processing
         *  2. Failed processing hence set to 'PENDING'
         * Sorting by ClosedDate ASC will pick the oldest
        */
        String soqlQuery = 'SELECT Id, Closed_By__r.Agent_Id__c FROM Case WHERE WP_Processing_Status__c = ' + WrkfcePlanDelegatorBatch.addSingleQuote(PENDING) + ' ORDER BY ClosedDate ASC';
        return Database.getQueryLocator(soqlQuery);
    }
   
    public void execute(Database.BatchableContext batchableContext, List<Case> scope) {
        List<Case> queued = new List<Case>();
        List<List<Case>> chunkedCases = new List<List<Case>>();

        if(scope != null && !scope.isEmpty()) {
            /**
             * Change the WP_Processing_Status of selected cases to 'QUEUED'.
             * Once this transaction completes, these cases will not be picked up by this batch job next time. 
             */
            for(Case caseObj : scope) {
                caseObj.WP_Processing_Status__c = String.valueOf(WrkfcePlanWrapper.WP_Processing_Status.QUEUED);
                queued.add(caseObj);
            }
            Database.update(queued);
        }

        /**
         * The batch size is 15,000. 
         * Split the batch into multiple lists of size 100.
         */
        if(!queued.isEmpty()) {
            chunkedCases = (List<List<Case>>) Lists.doPartions(queued, 100, List<List<Case>>.class);
        }

        /**
         * Use the AsyncApexFramework to submit queues
         * Use the chunks of 100 as input.
         */
        if(!chunkedCases.isEmpty()) {
            for(List<Case> input : chunkedCases) {
                AsyncApexFramework.submitQueueable(new WrkfcePlanQueueable(input), 99, false);
            }
            AsyncApexFramework.flush();
        }
    }
	
    public void finish(Database.BatchableContext info) { }

    private static String addSingleQuote(String value) {
        String modifiedValue = EMPTY;
        if(String.isNotBlank(value) && !(value.startsWith(SINGLE_QUOTE) && value.endsWith(SINGLE_QUOTE))) {
            modifiedValue = SINGLE_QUOTE + value + SINGLE_QUOTE;
        } else {
            modifiedValue = value;
        }
        return modifiedValue;
    }
}