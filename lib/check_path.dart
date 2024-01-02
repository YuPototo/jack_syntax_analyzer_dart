import 'dart:io';

List<FileSystemEntity> checkPath(String path) {
  // check if path is a directory or a file

  var isDir = FileSystemEntity.isDirectorySync(path);

  if (isDir) {
    var dir = Directory(path);
    handleDirectorySource(dir);
    return dir.listSync();
  } else {
    // todo: handle file source
    throw Exception('File source not implemented yet');
  }
}

List<FileSystemEntity> handleDirectorySource(Directory dir) {
  // list all files in directory

  var files = dir.listSync();

  // filter files that are jack files
  var jackFiles = files.where((file) => file.path.endsWith('.jack')).toList();

  // check if there are no jack files
  if (jackFiles.isEmpty) {
    throw Exception('No jack files found');
  }

  // validate file names
  for (var file in jackFiles) {
    checkFileName(file.path);
  }

  return jackFiles;
}

void checkFileName(String path) {
  // get file name from path

  var fileName = path.split('/').last;

  // check if first character is uppercase

  var firstChar = fileName[0];

  if (firstChar.toUpperCase() != firstChar) {
    throw Exception('Invalid file name');
  }
}
