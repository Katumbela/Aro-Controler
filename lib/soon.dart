import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SoonPage extends StatefulWidget {
  const SoonPage({super.key});

  @override
  State<SoonPage> createState() => _SoonPageState();
}

class _SoonPageState extends State<SoonPage> {
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
            SizedBox(
              height: MediaQuery.of(context).size.height * .2,
            ),
            Container(
              child: Image.asset("assets/droone.png", height: MediaQuery.of(context).size.height * .18,),
            ),  SizedBox(
              height: 10,
            ),
            Container(
              child: Image.asset("assets/logo.png", height: MediaQuery.of(context).size.height * .03,),
            ),

            SizedBox(
              height: MediaQuery.of(context).size.height * .1,
            ),

            Container(
              padding: EdgeInsets.only(left: 30,right: 30, top: MediaQuery.of(context).size.height * .0),
              child: Text("Controlador ARODRONE, brevemente disponível...", style: TextStyle(
                  color: Colors.white,
                  fontSize: 25, fontWeight: FontWeight.bold

              ),),
            ),

            SizedBox(
              height: 10,
            ),
          ],
        ),
      );
  }
}
