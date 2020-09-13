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
public with sharing class EndpointSettingsTest {
    @testSetup
    static void initData() {
        List<Endpoint__c> endpoints = new List<Endpoint__c>();
        endpoints.add(new Endpoint__c(name='Workforce Planning API', value__c='https://nfapihub.herokuapp.com'));
        INSERT endpoints;
    }

    @isTest
    static void test_getEndpointSettings() {
        Test.startTest();
        String actual = EndpointSettings.getValue('Workforce Planning API');
        String expected = 'https://nfapihub.herokuapp.com';
        System.assertEquals(expected, actual);
        Test.stopTest();
    }

    @isTest
    static void test_initEndpointSettings() {
        Test.startTest();
        List<Endpoint__c> actual = EndpointSettings.init();
        System.assertNotEquals(null, actual);
        Test.stopTest();
    }
}