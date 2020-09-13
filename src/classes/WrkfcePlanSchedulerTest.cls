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
private with sharing class WrkfcePlanSchedulerTest {
    
    public static testMethod void testWrkfcePlanScheduler() {
        Test.startTest();

        Case caseObj = new Case();
		caseObj.Status='New';
		caseObj.subject='Test'; 
        insert caseObj;
        
        caseObj.Status='Closed';
        update caseObj;

        Case updatedCase = [SELECT Id, Closed_By__c, toLabel(WP_Processing_Status__c) FROM Case WHERE Id = :caseObj.Id LIMIT 1];
        System.assertEquals(UserInfo.getUserId(), updatedCase.Closed_By__c);
        System.assertEquals('Pending', updatedCase.WP_Processing_Status__c);

        Datetime dt = Datetime.now().addMinutes(1);
        String schedule = '0 '+ dt.minute() + ' * ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year();
        String jobId = System.schedule('Test Workforce Plan Scheduler', schedule, new WrkfcePlanScheduler());

        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId]; 
        System.assertEquals(0, ct.TimesTriggered); 
        String expected = String.valueOf(Date.today()).removeEnd(' 00:00:00') + ' ' + dt.hour() + ':' + dt.minute() + ':00';
        System.assertEquals(expected, String.valueOf(ct.NextFireTime));   
        Test.stopTest();
    }
}