import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
//import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
/*import 'package:dio/dio.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';*/
import 'package:inedithos_chat/lang/cas.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';

class CustomPdf extends StatelessWidget{
  String fileUrl;

  CustomPdf(String fileUrl){
    this.fileUrl = fileUrl;

  }
  @override
  Widget build(BuildContext context) {
    if (fileUrl != null) {
      // Show the pdf with pdf viewer
     return  new FlatButton(
        child:  //Draw how we see the pdf message
          new Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
          children:// <Widget>
           [
            new Icon(Icons.picture_as_pdf, color: Colors.red, size: 40,),
            new Icon (Icons.open_in_new,  color: Colors.black87,size: 50),
          ],
        ),
        onPressed: (){ getFileFromUrl(fileUrl).then((file) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PDFScreen(file.path)),
          );
        });
         /*(){ getFileFromUrl(fileUrl).then((file) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        PdfViewPage(path: file.path, fromUrl: false,)
            ));
          });*/

        },
      );
    }
  }
  Future<File> getFileFromUrl(String url) async {
    try {
      var data = await http.get(url);
      var bytes = data.bodyBytes;
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/mypdf.pdf");

      File urlFile = await file.writeAsBytes(bytes);
      return urlFile;
    } catch (e) {
      throw Exception("Error opening url file");
    }
  }

}


class PDFScreen extends StatelessWidget {
  String pathPDF = "";
  PDFScreen(this.pathPDF);

  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
        appBar: AppBar(
          title: Text(cas_text_myDocument),
          /*actions: <Widget>[
            IconButton(
              icon: Icon(Icons.share),
              onPressed: () {},
            ),
          ],         */
        ),
        path: pathPDF);
  }
}







/*

class PdfViewPage extends StatefulWidget {
  final String path, url;
  final bool fromUrl;
  const PdfViewPage({Key key, this.path, this.fromUrl, this.url}) : super(key: key);
  @override
  _PdfViewPageState createState() => _PdfViewPageState();
}


class _PdfViewPageState extends State<PdfViewPage> {
  bool pdfReady = false;
  PDFViewController _pdfViewController;
  Future<void> downloadFile(String url) async{
    Dio dio = Dio();
    var dir = await DownloadsPathProvider.downloadsDirectory;
    print("\n\n\nThe dir is" + dir.path);
  //   PermissionStatus permissionResult = await SimplePermissions.requestPermission(Permission. WriteExternalStorage);
    // if (permissionResult == PermissionStatus.authorized){
    await dio.download(url, "${dir.path}/pdf.pdf");
    //}
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: widget.fromUrl ? FloatingActionButton(
          onPressed: () async {
            downloadFile(widget.url);
          },
          backgroundColor: Colors.black,
          child: Icon(Icons.remove_red_eye,
            color: Colors.white,),
        ) : null,
        appBar: AppBar(
          title: Text(cas_text_myDocument),
        ),
        body: Stack(
          children: <Widget>[
            PDFView(
              filePath: widget.path,
              autoSpacing: true,
              enableSwipe: true,
              pageSnap: true,
              swipeHorizontal: true,
              onError: (e) {
                print(e);
              },
              onRender: (_pages) {
                setState(() {
                  pdfReady = true;
                });
              },
              onViewCreated: (PDFViewController vc) {
                _pdfViewController = vc;
              },
            ),
            !pdfReady ? Center(child: CircularProgressIndicator()) : Offstage(),
          ],
        ));
  }
}*/