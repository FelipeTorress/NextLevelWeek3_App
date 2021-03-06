import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:happy_app/Screens/Orphanages.dart';
import 'package:happy_app/widgets/DataBase_helper.dart';
import 'package:happy_app/widgets/Orphanage.dart';

class CreateOrphanage extends StatefulWidget {
  @override
  _CreateOrphanageState createState() => _CreateOrphanageState();
}

class _CreateOrphanageState extends State<CreateOrphanage> {
  final nameController = TextEditingController();
  final aboutController = TextEditingController();
  final wppController = TextEditingController();
  final fotoController = TextEditingController();
  final instrucController = TextEditingController();
  final hourController = TextEditingController();

  final _nameFocus = FocusNode();
  final _aboutFocus = FocusNode();
  final _wppFocus = FocusNode();
  final _fotoFocus = FocusNode();
  final _instrucFocus = FocusNode();
  final _hourFocus = FocusNode();

  String lat = '-5.0818092';
  String lng = '-42.8059741';

  bool selected= true;
  bool change = false;

  List<String> images = new List();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Cadastrar um Orfanato', style: TextStyle(fontSize: 16.0,fontFamily: 'GloriaHallelujah')),
          centerTitle: true,
          backgroundColor: Colors.lightBlue,
          elevation: 0.0,
        ),
        body: Container(
          color: Colors.white54,
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          child: ListView(
            children: [
              Text('Dados',textAlign: TextAlign.center,style: TextStyle(color: Colors.indigo[900],fontWeight: FontWeight.bold, fontSize: 25.0),),
              Divider(height: 10.0,thickness: 2.0,color: Colors.indigo[900],),

              //mapa

              //nome
              _buildTextField('Nome',nameController,_nameFocus),
              //sobre
              _buildTextField('Sobre',aboutController,_aboutFocus),
              //número
              _buildTextField('Número(DDD+num)',wppController,_wppFocus),
              //Fotos
              _buildTextField('Fotos',fotoController,_fotoFocus),
              //botao de add
              _longButtonBuilder(Colors.white54, '+'),

              _imagesListView(),

              Text('Visitação',textAlign: TextAlign.center, style: TextStyle(color: Colors.indigo[900],fontWeight: FontWeight.bold, fontSize: 25.0),),
              Divider(height: 10.0,thickness: 2.0,color: Colors.indigo[900],),
              //instruções
              _buildTextField('Instruções',instrucController,_instrucFocus),
              //horários de visita
              _buildTextField('Horário de Visitas',hourController,_hourFocus),

              Text('Atende Fim de semana?',textAlign: TextAlign.center,style: TextStyle(fontSize: 20.0),),
              //botão sim e não
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _yesOrNotButtonBuilder('Sim'),
                  _yesOrNotButtonBuilder('Não'),
                ],
              ),
              _longButtonBuilder(Colors.lightBlue, 'Cadastrar')
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _requestPop(){
    if(change){
      showDialog(context: context,
          builder: (context){
            return AlertDialog(
              title: Text("Descartar Alterações?"),
              content: Text("Se sair as alterações serão perdidas"),
              actions: <Widget>[
                FlatButton(
                  child: Text("Cancelar"),
                  onPressed:(){
                    Navigator.pop(context);//voltar para edicao do contato
                  },
                ),
                FlatButton(
                  child: Text("Sim"),
                  onPressed:(){
                    Navigator.pop(context);//voltar para edicao do contato
                    Navigator.pop(context);//voltar para a homepage
                  },
                )
              ],
            );
          }
      );
      return Future.value(false);//nao deixar sair da tela
    }else{
      return Future.value(true);//deixar sair da tela
    }
  }

  //BUILDERS
  Widget _buildTextField(String label, TextEditingController c, focus) {
    return Padding(
      padding: EdgeInsets.only(top: 5.0,bottom: 10.0),
      child: TextFormField(
        controller: c,
        focusNode:focus,

        style: TextStyle(color: Colors.black, fontSize: 25.0),
        keyboardType: label.contains('Número')?TextInputType.number:TextInputType.text,
        maxLines: label.contains('Sobre')||label.contains('Instruções')?2:1,
        maxLength: label.contains('Sobre')||label.contains('Instruções')?300:null,

        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey, fontSize: 17.0),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(30.0)
          ),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.lightBlue)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black54),
              borderRadius: BorderRadius.circular(30.0)
          ),
          //hintStyle: TextStyle(color: Colors.red),
        ),
        onChanged: (text){
          if(text == '' || text == null){
            change=false;
          }else{
            change=true;
          }
        },
      ),
    );
  }

  _yesOrNotButtonBuilder(String text) {
    return Container(
      width: 150,
      height: 50,
      color: Colors.white54,
      child: RaisedButton(
        onPressed: () {
          if(text.contains('Sim') && selected==false){
            _change();
          }else if(text.contains('Não') && selected==true){
            _change();
          }
        },
        shape: RoundedRectangleBorder(
          borderRadius: _borderBuild(text),
        ),
        color: text.contains('Sim')?selected?Colors.green[300]:Colors.black38:!selected?Colors.green[300]:Colors.black38,
        child:  Text(text, style: TextStyle(fontSize: 15.0, color: Colors.white),),
      ),
    );
  }

  _borderBuild(text){
    if(text.contains('Sim')){
      return BorderRadius.only(topLeft: Radius.circular(25.0),bottomLeft: Radius.circular(25.0));
    }else{
      return BorderRadius.only(topRight: Radius.circular(25.0),bottomRight: Radius.circular(25.0));
    }
  }

  _longButtonBuilder(color, String txt){
    return Padding(
      padding: txt.contains('+')?EdgeInsets.only(bottom: 10.0):EdgeInsets.only(top: 15.0,bottom: 10.0),
      child: Container(
        width: 500,
        height: 50,
        color: Colors.white54,
        child: RaisedButton(
          color: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
            side: BorderSide(color: Colors.green),
          ),
          onPressed: (){
            if(txt.contains('+')){
              _addImage();
            }else{
              _validateData();
              //ir para outra pag apagando a pilha de navegação
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Orphanages()),(Route<dynamic> route) => false);
            }
          },
          child: Text(txt,style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
        ),
      ),
    );
  }

  //HELPERS
  _addImage(){
    if(fotoController.text != '' && fotoController.text != null &&
        fotoController.text.contains('http') && images.length <5){
      setState(() {
        images.add(fotoController.text);
        fotoController.text='';
      });
    }
  }

  _imagesListView(){
    if(images != null && images.length !=0 ){
      return ListView.builder(
          shrinkWrap: true,
          itemCount: images.length,
          itemBuilder: (BuildContext context, int index) {
            return Row(
              children: [
                Expanded(
                  child: Container(
                    height: 35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(
                        width: 3,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Text(images[index],style: TextStyle(fontSize: 18.0,color: Colors.blue,decoration: TextDecoration.underline),),
                    ),
                  ),
                ),
                GestureDetector(
                  child: Icon(Icons.clear,color: Colors.red,),
                  onTap: (){
                    _removeAddedFoto(index);
                  },
                )
              ],
            );
          }
      );
    }else{
      return SizedBox(height: 0,);
    }
  }

  _removeAddedFoto(index){
    setState(() {
      images.removeAt(index);
    });
  }
  // _gridView(){
  //   if(images.length != 0 && images != null){
  //     return Expanded(
  //         child:GridView.count(
  //             crossAxisCount: 2,
  //             children: List.generate(images.length, (index) {
  //               return Image.network(images[index]);
  //             })
  //         )
  //         );
  //   }else{
  //     return SizedBox(height: 1,);
  //   }
  // }

  _change(){
    setState(() {
      setState(() => selected = !selected);
    });
  }

  _validateData(){
    var controllers = [nameController.text,aboutController.text,wppController.text,
      instrucController.text,hourController.text];
    var focus = [_nameFocus,_aboutFocus,_wppFocus,_fotoFocus,_instrucFocus,_hourFocus];
    int index = -1;

    if(lat != '' && lng != '' && images.toString() != ''){
      controllers.forEach((element) {
        index++;
        if(element != null && element.isNotEmpty){
          _sendData();
        }else{
          return  FocusScope.of(context).requestFocus(focus[index]);
        }
      });
    }
  }

  _sendData(){
    Orphanage orp = new Orphanage();
    orp.lat=lat;
    orp.lng=lng;
    orp.name=nameController.text;
    orp.about=aboutController.text;
    orp.whatsapp=wppController.text;
    orp.images=images.toString();
    orp.instructions=instrucController.text;
    orp.opening_hour=hourController.text;
    orp.open_on_weekends=selected?'1':'0';

    DbHelper dbHelper = DbHelper();

    dbHelper.saveOrphanage(orp);
  }
}
