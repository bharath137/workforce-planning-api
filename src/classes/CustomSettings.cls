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
public with sharing class CustomSettings {

    public static void create() {
        INSERT EndpointSettings.init();
    }
}