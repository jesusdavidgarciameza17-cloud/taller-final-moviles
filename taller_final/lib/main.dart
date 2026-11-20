import 'package:flutter/material.dart';
import 'covid_api.dart';
import 'covid_data.dart';
import 'notification_service.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  runApp(const MaterialApp(debugShowCheckedModeBanner:false,home:HomePage()));
}

String fecha(DateTime d){
  String x(int n)=>n.toString().padLeft(2,'0');
  return '${x(d.day)}/${x(d.month)}/${d.year}  ${x(d.hour)}:${x(d.minute)}';
}

class HomePage extends StatefulWidget{
  const HomePage({super.key});
  @override
  State<HomePage> createState()=>_HomePageState();
}

class _HomePageState extends State<HomePage>{
  static const paises=['Colombia','Mexico','Argentina','Peru','Chile','Spain','USA'];
  String sel='Colombia';
  late Future<CovidData> fut=fetchCountry(sel);

  void recargar(){
    setState((){ fut=fetchCountry(sel); });
  }

  Future<void> avisar(CovidData d) async{
    await NotificationService.show(title:'COVID-19: ${d.country}', body:'Casos: ${d.cases} | Muertes: ${d.deaths} | Hoy: ${d.todayCases}');
  }

  Widget caja(String t,String v,Color c,double ang,double left){
    return Transform.rotate(
      angle:ang,
      child:Container(
        margin:EdgeInsets.only(left:left,top:12),
        padding:const EdgeInsets.symmetric(horizontal:14,vertical:10),
        decoration:BoxDecoration(
          color:c,
          border:Border.all(color:Colors.black,width:2),
          borderRadius:BorderRadius.circular(4),
        ),
        child:Row(
          mainAxisSize:MainAxisSize.min,
          children:[
            Text(t,style:const TextStyle(fontSize:13)),
            const SizedBox(width:10),
            Text(v,style:const TextStyle(fontSize:22,fontWeight:FontWeight.w900)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor:const Color(0xFFF2E8C9),
      appBar:AppBar(
        backgroundColor:Colors.black,
        foregroundColor:Colors.yellow,
        title:Transform.rotate(angle:-0.03,child:const Text('covid datos')),
      ),
      body:Padding(
        padding:const EdgeInsets.fromLTRB(16,20,22,16),
        child:Column(
          crossAxisAlignment:CrossAxisAlignment.stretch,
          children:[
            Transform.rotate(
              angle:0.02,
              child:Container(
                padding:const EdgeInsets.symmetric(horizontal:12),
                decoration:BoxDecoration(
                  color:Colors.white,
                  border:Border.all(width:2),
                ),
                child:DropdownButton<String>(
                  value:sel,
                  isExpanded:true,
                  underline:const SizedBox(),
                  items:paises.map((c)=>DropdownMenuItem(value:c,child:Text(c))).toList(),
                  onChanged:(v){
                    if(v==null) return;
                    sel=v;
                    recargar();
                  },
                ),
              ),
            ),
            const SizedBox(height:10),
            Expanded(
              child:FutureBuilder<CovidData>(
                future:fut,
                builder:(context,snap){
                  if(snap.connectionState!=ConnectionState.done){
                    return const Center(child:CircularProgressIndicator());
                  }
                  if(snap.hasError){
                    return Center(
                      child:Column(
                        mainAxisSize:MainAxisSize.min,
                        children:[
                          Text('No se pudo consultar: ${snap.error}'),
                          const SizedBox(height:12),
                          ElevatedButton(onPressed:recargar,child:const Text('Reintentar')),
                        ],
                      ),
                    );
                  }
                  final d=snap.data!;
                  return ListView(
                    children:[
                      Transform.rotate(
                        angle:-0.05,
                        child:Text(d.country,style:const TextStyle(fontSize:44,fontWeight:FontWeight.w900)),
                      ),
                      caja('casos acumulados','${d.cases}',Colors.orangeAccent,0.03,0),
                      caja('casos hoy','${d.todayCases}',Colors.lightBlueAccent,-0.04,40),
                      caja('muertes acumuladas','${d.deaths}',Colors.pinkAccent,0.02,12),
                      caja('muertes hoy','${d.todayDeaths}',Colors.limeAccent,-0.03,70),
                      caja('recuperados','${d.recovered}',Colors.tealAccent,0.05,6),
                      Padding(
                        padding:const EdgeInsets.only(top:18,left:90),
                        child:Transform.rotate(
                          angle:-0.02,
                          child:Text('actualizado ${fecha(d.updated)}',style:const TextStyle(fontSize:12)),
                        ),
                      ),
                      Align(
                        alignment:Alignment.centerRight,
                        child:Padding(
                          padding:const EdgeInsets.only(top:30),
                          child:Transform.rotate(
                            angle:0.04,
                            child:FilledButton(
                              style:FilledButton.styleFrom(
                                backgroundColor:Colors.deepOrange,
                                shape:const RoundedRectangleBorder(),
                                padding:const EdgeInsets.symmetric(horizontal:26,vertical:16),
                              ),
                              onPressed:()=>avisar(d),
                              child:const Text('mandar notificacion'),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
