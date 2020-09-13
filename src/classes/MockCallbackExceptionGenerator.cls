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
public class MockCallbackExceptionGenerator implements HttpCalloutMock {
    public HttpResponse respond(HttpRequest request) {
        CalloutException ex = (CalloutException)CalloutException.class.newInstance();
        ex.setMessage('Unauthorized endpoint, please check Setup->Security->Remote site settings.');
        throw ex;
    }
}