/**
 * @description       : Queue to setup the callouts.
 * @author            : Bharath Kumar
 * @group             : 
 * @last modified on  : 09-13-2020
 * @last modified by  : Bharath Kumar
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   09-12-2020   Bharath Kumar   Initial Version
**/
public with sharing class WrkfcePlanQueueable implements Queueable, Database.AllowsCallouts {

    /**
     * Input gets serialised and deserialised in AsyncApexFramework
     */
    public List<Case> cases;
    
    /**
     * Invoked by WrkfcePlanDelegatorBatch
     */
    public WrkfcePlanQueueable(List<Case> caseList) {
        cases = caseList ;
    }

    /**
     * Queued by AsyncApexFramework. 
     */
    public void execute(QueueableContext qc) {
        List<Case> casesToUpdate = new List<Case>();
        if(cases != null && !cases.isEmpty()) {
            for (Case caseObj : cases) {
                try {
                    /**
                     * The request.setTimeout can be set to 120,000 milliseconds if needed.  For now using the default.
                     */
                    HttpRequest request = new HttpRequest();
                    HttpResponse response = new HttpResponse();
                    Http http = new Http();
                    String jsonResponse = null;
    
                    WrkfcePlanWrapper body = new WrkfcePlanWrapper();
                    body.id = caseObj.Id;
                    body.agentid = caseObj.Closed_By__r.Agent_Id__c;
    
                    request.setHeader('Content-Type', 'application/json');
                    request.setEndpoint('https://nfapihub.herokuapp.com'); // URL to be moved to an appropriate place.
                    request.setMethod('POST');
                    request.setBody(JSON.serialize(body, true));
                    response = http.send(request);

                    jsonResponse = response.getBody();
                    WrkfcePlanWrapper output = WrkfcePlanWrapper.parse(jsonResponse);

                    /**
                     * If the STATUS = success. Set the WP_Processing_Status to COMPLETED. 
                     * Store the secretKey from response into WP_Secret_Key__c
                     * Additionally set the WP_Output_Status__c to SUCCESS. Optional.
                     * 
                     * If the STATUS != success. Set the WP_Processing_Status back to PENDING.
                     * Additionally set the WP_Output_Status__c to ERROR. Optional.
                     * WP_Output_Message__c to the error message. Optional. If it is needed to analyse for future. 
                     */
                    if (response.getStatusCode() == 200) {
                        caseObj.WP_Output_Status__c = String.valueOf(WrkfcePlanWrapper.WP_Output_Status.SUCCESS);
                        caseObj.WP_Processing_Status__c = String.valueOf(WrkfcePlanWrapper.WP_Processing_Status.COMPLETED);
                        caseObj.WP_Secret_Key__c = output.secretKey;
                        casesToUpdate.add(caseObj);
                    } else {
                        caseObj.WP_Output_Status__c = String.valueOf(WrkfcePlanWrapper.WP_Output_Status.ERROR);
                        caseObj.WP_Processing_Status__c = String.valueOf(WrkfcePlanWrapper.WP_Processing_Status.PENDING);
                        caseObj.WP_Output_Message__c = output.error;
                        casesToUpdate.add(caseObj);
                    }
                } catch(Exception ex) {
                    /**
                     * If there is any exception, reset the WP_Processing_Status back to PENDING.
                     */
                    caseObj.WP_Processing_Status__c = String.valueOf(WrkfcePlanWrapper.WP_Processing_Status.PENDING);
                    casesToUpdate.add(caseObj);
                }
            }
        }

        /**
         * Update all cases.
         */
        if(!casesToUpdate.isEmpty()) {
            Database.update(casesToUpdate);
        }
    }
}