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
public with sharing class MockHttpResponseGenerator implements HttpCalloutMock {
    private Integer code; // setStatusCode Example : 200
    private String bodyAsString; // JSON Response
    private Map<String, String> responseHeaders; // header. Example : 'Content-Type', 'application/JSON'
    
    public MockHttpResponseGenerator(Integer code, String body, Map<String, String> responseHeaders) {
        this.code = code;
        this.bodyAsString = body;
        this.responseHeaders = responseHeaders;
    }
    
    public HTTPResponse respond(HTTPRequest req) {
        HttpResponse resp = new HttpResponse();
        resp.setStatusCode(code);
        resp.setBody(bodyAsString);
        if(responseHeaders != null) {
            for (String key : responseHeaders.keySet()) {
                resp.setHeader(key, responseHeaders.get(key));
            }
        }
        return resp;
    }
}