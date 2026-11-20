class CovidData{
  final String country;
  final int cases,todayCases,deaths,todayDeaths,recovered;
  final DateTime updated;

  CovidData({required this.country,required this.cases,required this.todayCases,
    required this.deaths,required this.todayDeaths,required this.recovered,required this.updated});

  factory CovidData.fromJson(Map<String,dynamic> j){
    int t(dynamic v)=>(v as num?)?.toInt()??0;
    return CovidData(
      country:j['country'] as String,
      cases:t(j['cases']),
      todayCases:t(j['todayCases']),
      deaths:t(j['deaths']),
      todayDeaths:t(j['todayDeaths']),
      recovered:t(j['recovered']),
      updated:DateTime.fromMillisecondsSinceEpoch(t(j['updated'])),
    );
  }
}
