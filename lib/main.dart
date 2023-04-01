import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:quill_json_to_html/json_to_html.dart';
import 'package:quill_markdown/quill_markdown.dart';
import 'colors.dart';
import 'package:flutter_quill/src/models/documents/document.dart' as d;
import 'package:html2md/html2md.dart' as html2md;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  List images = [];
  bool textEditorShowing = false;
  late QuillController textController = QuillController.basic();
  final FocusNode _focusNode = FocusNode();

  void _incrementCounter() {

    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    var myJSON = jsonDecode(r'[{"insert":"hello\n"}]');
    textController = QuillController(
      document: d.Document.fromJson( jsonDecode("${markdownToQuill(html2md.convert("<ul><li><em><strong>Test</strong></em></li></ul>"))}"),),
      selection: TextSelection.collapsed(offset: 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: size.width*0.04),
        decoration: BoxDecoration(
            border: Border(
                top: BorderSide(
                  width:1,
                  color: AppColors.neutralColor[200]!,
                )
            ),
            color: Colors.white
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: size.height*0.3,
            ),
            Container(
                width: size.width*0.9,
                child: QuillEditor(
                  controller: textController,
                  scrollController: ScrollController(),
                  scrollable: true,
                  focusNode: _focusNode,
                  autoFocus: false,
                  readOnly: false,
                  placeholder: 'Add content',
                  enableSelectionToolbar: true,
                  expands: false,
                  padding: EdgeInsets.zero,
                  // customStyleBuilder: (Attribute attribute){
                  //   return TextStyle();
                  // },
                  customStyles: DefaultStyles(
                    bold: DefaultStyles.getInstance(context).bold!.copyWith(
                      fontSize: 10,
                    ),
                    placeHolder: DefaultTextBlockStyle(
                        const TextStyle(
                          fontSize: 10,
                          color: Colors.black,
                          height: 1.15,
                          fontWeight: FontWeight.w300,
                        ),
                        const VerticalSpacing(8, 0),
                        const VerticalSpacing(0, 0),
                        null
                    ),
                    paragraph: DefaultTextBlockStyle(
                        const TextStyle(
                          fontSize: 10,
                          color: Colors.black,
                          height: 1.15,
                          fontWeight: FontWeight.w300,
                        ),
                        const VerticalSpacing(16, 0),
                        const VerticalSpacing(0, 0),
                        null
                    ),
                    // paragraph: DefaultTextBlockStyle(),
                    // sizeSmall: const TextStyle(fontSize: 9),
                  ),

                )
            ),
            SizedBox(
              height: size.height*0.02,
            ),
            SizedBox(
              width: size.width*0.9,
              child: QuillToolbar.basic(
                controller: textController,
                showAlignmentButtons: false,
                showCenterAlignment: false,
                showBackgroundColorButton: false,
                showClearFormat: false,
                showColorButton: false,
                showDirection: false,
                showDividers: false,
                showFontFamily: false,
                showFontSize: false,
                showHeaderStyle: false,
                showIndent: false,
                showJustifyAlignment: false,
                showLeftAlignment: false,
                showListCheck: false,
                showRedo: false,
                showRightAlignment: false,
                showSearchButton: false,
                showQuote: false,
                showSmallButton: false,
                showUndo: false,
                showInlineCode: false,
                showListNumbers: false,
                toolbarIconSize: size.height*0.02,
                toolbarIconAlignment: WrapAlignment.start,
                iconTheme: QuillIconTheme(
                    borderRadius: 4,
                    iconUnselectedFillColor: Colors.transparent,
                    iconSelectedFillColor: AppColors.primaryColor[50],
                    iconSelectedColor: AppColors.primaryColor[600],
                    iconUnselectedColor: const Color(0xFF64748B)
                ),
              ),
            ),
            SizedBox(
              height: size.height*0.3,
            ),
          ],
        ),
      ),
      floatingActionButton:InkWell(
        onTap: (){
          print(quillDeltaToHtml(textController.document.toDelta()));
        },
        child: const Icon(
            Icons.add
        ),
      )
    );
  }

  String quillDeltaToHtml(Delta delta) {
    final html = QuillJsonToHTML.encodeJson(delta.toJson());
    return html;
  }
}


