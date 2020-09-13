/**
 * @description       : 
 * @author            : Bharath Kumar
 * @group             : 
 * @last modified on  : 09-11-2020
 * @last modified by  : Bharath Kumar
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   09-11-2020   Bharath Kumar   Initial Version
**/
public with sharing class EndpointSettings {
    public static final String WORKFORCE_PLANNING_API = 'Workforce Planning API';
    
    public static List<Endpoint__c> init() {
        List<Endpoint__c> endpoints = new List<Endpoint__c>();
        endpoints.add(new Endpoint__c(Name=WORKFORCE_PLANNING_API, Value__c='https://nfapihub.herokuapp.com'));

        return endpoints;
    }

    public static String getValue(String name) {
        List<Endpoint__c> endpointSettings = Endpoint__c.getall().values();
        String value = null;
        if(String.isNotBlank(name) && !endpointSettings.isEmpty()) {
            for(Endpoint__c endpointSetting : endpointSettings) {
                if(name.equalsIgnoreCase(endpointSetting.name)) {
                    value = endpointSetting.Value__c;
                    break;
                }
            }
        }
        return value;
    }

    public static Boolean hasValues() {
        List<Endpoint__c> endpointSettings = Endpoint__c.getall().values();
        return !endpointSettings.isEmpty() ? true : false;
    }
}