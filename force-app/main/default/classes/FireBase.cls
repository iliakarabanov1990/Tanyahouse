public class FireBase{

    public static void updateDataOfFireBase(){

        Http http = new Http(); 
        HttpRequest request = new HttpRequest();   
        request.setMethod('PUT');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        
        List<String> fields = new String[]{'Id', 'Name', 'Description__c'};

        List<SObject> data = getObjectData('CyprusLocation__c', fields);
        sendDataToFireBase(data, fields, http, request, 'https://cyprus-real-estate-for-belarus-default-rtdb.europe-west1.firebasedatabase.app/locations');


        // request.setEndpoint('https://cyprus-real-estate-for-belarus-default-rtdb.europe-west1.firebasedatabase.app/locations/2.json');
        
        // request.setMethod('PUT');
        //request.setMethod('POST');
        //request.setMethod('DELETE'); 
        //request.setHeader('X-Firebase-ETag', 'tt1'); 
        
        //request.setHeader('Authorization', 'Key=AIzaSyDzQd.......'); //legacy server key
        
        // Set the body as a JSON object
        
        // request.setBody('{"ID":"'+ 2 +'", "name": "test1", "key": "2"}');
        
        
        
        // Parse the JSON response
        
        
    }

    static List<SObject> getObjectData(String table, List<String> fields){

        List<SObject> data = Database.query(
                    'SELECT ' + String.join(fields, ', ') + ' FROM ' + table);

        return data;

    } 

    static string sendDataToFireBase(List<SObject> data, List<String> fields, Http http, HttpRequest request, String endPoint){

        for (SObject obj : data) {
            request.setEndpoint(endPoint + '/' + obj.Id + '.json');
            string body = '{';
            for(string field : fields){
                body += '"' + field.replace('__c', '') + '": "' + obj.get(field)+ '",';           
            }
            body = body.removeEnd(',');
            body += '}';
            request.setBody(body);
            HttpResponse response = http.send(request);
            
            System.debug(body);
            
            if (response.getStatusCode() != 200) {          
                System.debug('The status code returned was not expected: ' +                        
                             response.getStatusCode() + ' ' + response.getStatus());            
                return string.valueOf(response.getStatus());           
            } else {        
                System.debug(response.getBody());          
                //return string.valueOf(response.getStatus());       
            }
        }
        
        return 'Data has been updated';
    }

}