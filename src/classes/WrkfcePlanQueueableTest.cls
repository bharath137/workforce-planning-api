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
public with sharing class WrkfcePlanQueueableTest {
    
    @testSetup 
    static void setup() {
        List<Case> cases = new List<Case>();
        List<Case> updatedCases = new List<Case>();
        for(Integer i =0; i < 100; i++) {
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

    static testmethod void testQueueable_200() { 
        List<Case> cases = [SELECT Id, WP_Processing_Status__c, Closed_By__r.Agent_Id__c FROM Case WHERE WP_Processing_Status__c = 'Pending'];
        List<Case> updatedCases = new List<Case>();
        for(Case caseObj : cases) {
            caseObj.WP_Processing_Status__c = 'Queued';
            updatedCases.add(caseObj);
        }
        UPDATE updatedCases;
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(200, '{"success":true,"secretKey":"12345"}', null));
        
        Test.startTest();
        ID jobID = System.enqueueJob(new WrkfcePlanQueueable(updatedCases));
        Test.stopTest();

        cases = [SELECT Id, WP_Processing_Status__c, Closed_By__r.Agent_Id__c, WP_Secret_Key__c FROM Case WHERE WP_Processing_Status__c = 'Completed'];
        System.assertEquals(100, cases.size());
        
        Boolean condition = true;
        for(Case caseObj : cases) {
            if(!(String.isNotBlank(caseObj.WP_Secret_Key__c) && caseObj.WP_Secret_Key__c.equals('12345'))) {
                condition = false;
                break;
            }
        }
        System.assert(condition);
    }

    static testmethod void testQueueable_500() { 
        List<Case> cases = [SELECT Id, WP_Processing_Status__c, Closed_By__r.Agent_Id__c FROM Case WHERE WP_Processing_Status__c = 'Pending'];
        List<Case> updatedCases = new List<Case>();
        for(Case caseObj : cases) {
            caseObj.WP_Processing_Status__c = 'Queued';
            updatedCases.add(caseObj);
        }
        UPDATE updatedCases;
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(500, '{"success":false,"secretKey":"error message"}', null));

        Test.startTest();
        ID jobID = System.enqueueJob(new WrkfcePlanQueueable(updatedCases));
        Test.stopTest();
        
        cases = [SELECT Id, WP_Processing_Status__c, Closed_By__r.Agent_Id__c, WP_Secret_Key__c FROM Case WHERE WP_Processing_Status__c = 'Pending'];
        System.assertEquals(100, cases.size());

        Boolean condition = true;
        for(Case caseObj : cases) {
            if(!(String.isBlank(caseObj.WP_Secret_Key__c))) {
                condition = false;
                break;
            }
        }
        System.assert(condition);
    }
}