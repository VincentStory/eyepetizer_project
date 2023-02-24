class Url {
  // 'http://baobab.kaiyanapp.com/api/';
  static String baseUrl = "";

  static Map<String, String> httpHeader = {
    'Accept': 'application/json, text/plain, */*',
    'Accept-Encoding': 'gzip, deflate, br',
    'Accept-Language': 'zh-CN,zh;q=0.9',
    'Connection': 'keep-alive',
    'Content-Type': 'application/json',
    'User-Agent':
    'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1',
  };

  // home
  static String feedUrl = '${baseUrl}v2/feed?num=1';
  static String keywordUrl = '${baseUrl}v3/queries/hot';
  static String searchUrl = "${baseUrl}v1/search?query=";

  // detail
  static String videoRelatedUrl = '${baseUrl}v4/video/related?id=';

  // discovery
  static String communityUrl = '${baseUrl}v7/community/tab/rec';
  static String categoryUrl = '${baseUrl}v4/categories';
  static String followUrl = '${baseUrl}v4/tabs/follow';
  static String categoryVideoUrl = '${baseUrl}v4/categories/videoList?';
  static String newsUrl =
      '${baseUrl}v7/information/list?vc=6030000&deviceModel=';
  static String topicsDetailUrl = '${baseUrl}v3/lightTopics/internal/';
  static String topicsUrl = '${baseUrl}v3/specialTopics';

  // hot
  static String rankUrl = '${baseUrl}v4/rankList';
}
