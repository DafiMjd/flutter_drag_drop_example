import 'package:drag_drop_example/DropZoneWidget.dart';
import 'package:drag_drop_example/DroppedFileWidget.dart';
import 'package:drag_drop_example/dropzone_provider.dart';
import 'package:drag_drop_example/model/file_DataModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(create: (context) => DropzoneProvider(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File_Data_Model? file;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
        file = null;
        setState(() {});
      }),
      appBar: AppBar(
        title: Text("drag drop flutter Web"),
      ),
      body: SingleChildScrollView(
        child: Container(
            margin: EdgeInsets.fromLTRB(30, 30, 30, 10),
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(15),
            child: Card(
              elevation: 5,
              child: Container(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          "Image",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        const Text(
                          "(ext: png/jpg | size: <200mb)",
                          style: TextStyle(
                              fontWeight: FontWeight.w300, fontSize: 14),
                        ),
                      ],
                    ),
                    Stack(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.4,
                          width: MediaQuery.of(context).size.width,
                          child: Visibility(
                            visible: file == null,
                            child: DropZoneWidget(
                              maxFiles: 1,
                              mimes: ['image/jpeg', 'image/png', 'application/pdf'],
                              onDroppedFile: (file) =>
                                  setState(() => this.file = file),
                            ),
                          ),
                        ),
                        Container(
                            height: MediaQuery.of(context).size.height * 0.4,
                            width: MediaQuery.of(context).size.width,
                            child: Visibility(
                                visible: file != null,
                                child: DroppedFileWidget(file: file))),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Visibility(
                          visible: file != null,
                          child: Tooltip(
                              message: "Clear File",
                              child: IconButton(
                                  onPressed: (() {
                                    file = null;
                                    setState(() {});
                                  }),
                                  icon: const Icon(
                                    Icons.clear_sharp,
                                    size: 30,
                                    color: Colors.black54,
                                  ))),
                        ),
                        Tooltip(
                            message: "Delete Card",
                            child: IconButton(
                                onPressed: (() {}),
                                icon: const Icon(
                                  Icons.delete,
                                  size: 30,
                                  color: Colors.black54,
                                ))),
                      ],
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
