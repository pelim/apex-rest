public with sharing class RestRouter {

    private static RestRouter instance;

    public static RestRouter getInstance() {
        if(RestRouter.instance == null) {
            RestRouter.instance = new RestRouter();
        }

        return RestRouter.instance;
    }

    private Map<String, String> getRoutes() {

        return new Map<String, String> {
            '/contacts/(?<id>.*)' => 'AccountHandler',
            '/accounts/(?<id>.*)' => 'ContactDetailsHandler'
        };
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

    /*
    public PageReference process(String siteUrl) {
        Map<String, String> routes = this.getRoutes();
        for(String route: routes.keySet()) {
            Map<String, String> urlParameters = this.matchRoute(route, siteUrl);
            if(urlParameters != null) {
                String pageName = routes.get(route);
                PageReference urlMatch = new PageReference(pageName);

                urlMatch.getParameters().putAll(urlParameters);
                return urlMatch;
            }
        }
        return null;
    }*/
}
