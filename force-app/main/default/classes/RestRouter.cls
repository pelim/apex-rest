public with sharing class RestRouter {

    private static RestRouter instance;

    public static RestRouter getInstance() {
        if(RestRouter.instance == null) {
            RestRouter.instance = new RestRouter();
        }
        return RestRouter.instance;
    }

    private List<String> extractKeys(String routePattern) {
        List<String> keys = new List<String> {};

        Pattern p = Pattern.compile('\\<(.*)\\>');
        Matcher m = p.matcher(routePattern);

        if(m.find()) {
            for (Integer i = 0; i < m.groupCount(); i++) {
                keys.add(m.group(i + 1));
            }
        }
        return keys;
    }

    public Map<String, String> matchRoute(String routePattern, String url) {
        List<String> keys = new List<String> {};
        Map<String, String> urlParameters = new Map<String,String> {};

        Pattern p = Pattern.compile(routePattern);
        Matcher m = p.matcher(url);

        if(!m.find()) {
            return null;
        }

        keys = this.extractKeys(routePattern);

        for (Integer i = 0; i < keys.size(); i++) {
            urlParameters.put(keys.get(i), m.group(i + 1));
        }
        return urlParameters;
    }
}
