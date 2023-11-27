import 'package:arobot_controller/soon.dart';
import 'package:arobot_controller/tela2.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class Tela3 extends StatefulWidget {
  const Tela3({super.key});

  @override
  State<Tela3> createState() => _Tela3State();
}

class _Tela3State extends State<Tela3> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        backgroundColor: Color(0xFF2A2656),
        body: ListView(
          children: [
            Container(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    width:
                    40.0, // Ajuste conforme necessário para o tamanho desejado
                    height:
                    40.0, // Ajuste conforme necessário para o tamanho desejado
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF07234F), // Substitua pela cor hexa desejada
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    // Adicione qualquer conteúdo desejado aqui, como um ícone ou texto
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                        child: Icon(Icons.arrow_back, color: Colors.white,)),
                  ),

                ],
              )
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              child: Text("Decida o seu destino! e pilote para o futuro...", style: TextStyle(
                color: Colors.white,
                fontSize: 30, fontWeight: FontWeight.bold

              ),),
            ),

            SizedBox(
              height: 10,
            ),

            Stack(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.rightToLeft,
                        duration: const Duration(milliseconds: 230),
                        child: Tela2(),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    padding: EdgeInsets.only(left: 50),
                    height: MediaQuery.of(context).size.height * .25,
                    width: MediaQuery.of(context).size.height * .9,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Text("ARO", style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 38
                            ),),
                            SizedBox(
                              width: 5,
                            ),
                            Text("BOT", style: TextStyle(
                                color: Color(0xFF2A2656),
                                fontWeight: FontWeight.w900,
                                fontSize: 38
                            ),),
                          ],
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(Icons.arrow_forward_ios, color: Colors.lightBlueAccent,size: 30,)
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: -11,
                  child: Image.asset("assets/arobot.png", height: MediaQuery.of(context).size.height * .18,),
                ),
              ],
            ),
            SizedBox(
              height: 50,
            ),

            Stack(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.rightToLeft,
                        duration: const Duration(milliseconds: 200),
                        child: SoonPage(),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    padding: EdgeInsets.only(left: 20),
                    height: MediaQuery.of(context).size.height * .25,
                    width: MediaQuery.of(context).size.height * .9,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Text("ARO", style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 35
                            ),),
                            SizedBox(
                              width: 5,
                            ),
                            Text("DRONES", style: TextStyle(
                                color: Color(0xFF2A2656),
                                fontWeight: FontWeight.w900,
                                fontSize: 35
                            ),),
                          ],
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(Icons.arrow_forward_ios, color: Colors.lightBlueAccent, size: 30,)
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: -30,
                  right: -18,
                  child: Image.asset("assets/droone.png", height: MediaQuery.of(context).size.height * .18,),
                ),
              ],
            )
          ],
        ),
      );
  }
}
