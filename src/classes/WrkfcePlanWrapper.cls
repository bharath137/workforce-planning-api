/**
 * @description       : 
 * @author            : Bharath Kumar
 * @group             : 
 * @last modified on  : 09-12-2020
 * @last modified by  : Bharath Kumar
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   09-12-2020   Bharath Kumar   Initial Version
**/
public with sharing class WrkfcePlanWrapper {
    public String id;
    public String agentid;

    public Boolean success;
    public String error;
    public String secretKey;

    public Enum WP_Processing_Status{PENDING, QUEUED, COMPLETED}
    public Enum WP_Output_Status{SUCCESS, ERROR}

    public static WrkfcePlanWrapper parse(String jsonInput) {
        return (WrkfcePlanWrapper) System.JSON.deserialize(jsonInput, WrkfcePlanWrapper.class);
    }
}