import 'package:drag_drop_example/dropzone_provider.dart';
import 'package:drag_drop_example/error_alert_dialog.dart';
import 'package:drag_drop_example/model/file_DataModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:provider/provider.dart';



class DropZoneWidget extends StatelessWidget {

  final ValueChanged<File_Data_Model> onDroppedFile;
  final List<String> mimes;
  final int maxFiles;

  const DropZoneWidget(
      {Key? key,
      required this.onDroppedFile,
      required this.mimes,
      required this.maxFiles})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
  late DropzoneViewController ctrl;
    

    DropzoneProvider dropzoneProv = context.watch<DropzoneProvider>();
    

    

    return Container(
      margin: const EdgeInsets.all(30),
      width: MediaQuery.of(context).size.width,
      child: buildDecoration(
        dropzoneProv: dropzoneProv,
          child: Stack(
        children: [
          DropzoneView(
            onError: (value) => throw fileInvalid(value.toString(), dropzoneProv, context),
            onDropMultiple: (value) {
              (value!.length > maxFiles)
                  ? fileInvalid("Unable To Drop Multiple Files", dropzoneProv, context)
                  : 
                  // UploadedFile(value.first, ctrl, dropzoneProv); // upload without checking the ext and size
                  checkFile(value.first, ctrl, dropzoneProv, context);
            },
            onCreated: (controller) async {
              ctrl = controller;
            },
            onHover: () => dropzoneProv.highlight = true,
            onLeave: () => dropzoneProv.highlight = false,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.cloud_upload_outlined,
                  size: 80,
                  color: Colors.black,
                ),
                Text(
                  'Drop Files Here',
                  style: TextStyle(color: Colors.black, fontSize: 24),
                ),
                const SizedBox(
                  height: 16,
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    final events = await ctrl.pickFiles(
                        mime: mimes, multiple: false);
                    if (events.isEmpty) return;
                    checkFile(events.first, ctrl, dropzoneProv, context);
                  },
                  icon: Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                  label: Text(
                    'Choose File',
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      primary: dropzoneProv.highlight
                          ? Colors.grey.shade200
                          : Colors.grey.shade300,
                      shape: RoundedRectangleBorder()),
                )
              ],
            ),
          ),
        ],
      )),
    );
  }

Future checkFile(dynamic event, ctrl, dropzoneProv, context) async {
      final mime = await ctrl.getFileMIME(event);
      final byte = await ctrl.getFileSize(event);
      var sizeInMB = byte / (1024 * 1024);

      if (mimes.contains(mime)) {
        if (sizeInMB < 200) {
          UploadedFile(event, ctrl, dropzoneProv);
        } else {
          fileInvalid("Invalid File Size", dropzoneProv, context);
        }
      } else {
        fileInvalid("Invalid File Extension", dropzoneProv, context);
      }
    }

    Future<dynamic> fileInvalid(String message, dropzoneProv, context) {
      dropzoneProv.highlight = false;
      return showDialog(
          context: context,
          builder: (context) {
            return ErrorAlertDialog(
              error: message,
            );
          });
    }

Future UploadedFile(dynamic event, ctrl, dropzoneProv) async {
      final name = event.name;

      final mime = await ctrl.getFileMIME(event);
      final byte = await ctrl.getFileSize(event);
      final url = await ctrl.createFileUrl(event);

      print('Name : $name');
      print('Mime: $mime');

      print('Size : ${byte / (1024 * 1024)}');
      print('URL: $url');

      final droppedFile =
          File_Data_Model(name: name, mime: mime, bytes: byte, url: url);

      onDroppedFile(droppedFile);
      dropzoneProv.highlight = false;
    }

  Widget buildDecoration({required Widget child, required DropzoneProvider dropzoneProv}) {
      final colorBackground =
          dropzoneProv.highlight ? Colors.grey.shade200 : Colors.white;
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(10),
          child: DottedBorder(
              borderType: BorderType.RRect,
              color: Colors.black,
              strokeWidth: 3,
              dashPattern: [8, 4],
              radius: Radius.circular(10),
              padding: EdgeInsets.zero,
              child: child),
          color: colorBackground,
        ),
      );
    }
}
