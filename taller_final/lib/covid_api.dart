import 'dart:convert';
import 'package:http/http.dart' as http;
import 'covid_data.dart';

Future<CovidData> fetchCountry(String pais) async{
  final u=Uri.https('disease.sh','/v3/covid-19/countries/${Uri.encodeComponent(pais)}');
  final r=await http.get(u).timeout(const Duration(seconds:10));
  if(r.statusCode!=200){
    throw Exception('Error del servidor: ${r.statusCode}');
  }
  return CovidData.fromJson(jsonDecode(r.body) as Map<String,dynamic>);
}
