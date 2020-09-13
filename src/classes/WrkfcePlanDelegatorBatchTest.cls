/**
 * @description       : 
 * @author            : Bharath Kumar
 * @group             : 
 * @last modified on  : 09-13-2020
 * @last modified by  : Bharath Kumar
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   09-13-2020   Bharath Kumar   Initial Version
**/
@isTest
private with sharing class WrkfcePlanDelegatorBatchTest {
    
    @testSetup 
    static void setup() {
        List<Case> cases = new List<Case>();
        List<Case> updatedCases = new List<Case>();
        for(Integer i =0; i < 500; i++) {
            Case caseObj = new Case();
            caseObj.Status='New';
            caseObj.subject='Test ' + i;
            cases.add(caseObj);
        }
        INSERT cases;

        for(Case caseObj : cases) {
            caseObj.Status='Closed';
            updatedCases.add(caseObj);
        }
        UPDATE updatedCases;
    }

    static testmethod void testBatch() { 
        Test.startTest();
        WrkfcePlanDelegatorBatch wrkfcPlanDelegatorBatch = new WrkfcePlanDelegatorBatch();
        Id batchId = Database.executeBatch(wrkfcPlanDelegatorBatch, 15000);
        Test.stopTest();
        Integer queuedJobs = [SELECT count() FROM AsyncQueue__c WHERE Job_Type__c = 'Queueable'];
        System.assertEquals(5, queuedJobs);
    }
}