public abstract class AbstactRestHandler {

    public static final String HTTP_GET = 'GET';
    public static final String HTTP_POST = 'POST';

    public abstract String getActionName();
    public abstract String getRoute();
    public abstract String getHttpMethod();

    public abstract void execute(RestRequest request, RestResponse response);

    public static Matcher matchRoute(AbstactRestHandler restHandler, String restUrl) {
        System.debug(restUrl);
        System.debug(restHandler.getRoute());
        return Pattern.compile(restHandler.getRoute()).matcher(restUrl);
    }


    public static void statusCodeResponse(RestResponse response, Integer statusCode){
        response.statusCode = statusCode;
    }

    public static void successfullyResponse(RestResponse response){
        statusCodeResponse(response, 200);
    }

    public static void errorResponse(RestResponse response){
        statusCodeResponse(response, 400);
    }

    public static void JSONResponse(RestResponse response, Object result, Integer statusCode){
        response.responseBody = blob.valueOf(JSON.serialize(result));
        response.addHeader('Content-Type', 'application/json');
        statusCodeResponse(response, statusCode);
    }

    public static void JSONResponse(RestResponse response, Integer statusCode){
        JSONResponse(response, null, statusCode);
    }

    public static void JSONResponse(RestResponse response, Object result){
        JSONResponse(response, result, 200);
    }

    public class RestHandlerException extends Exception {}
}