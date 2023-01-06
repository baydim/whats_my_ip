import 'dart:io';

class DataIp {
  DataIp({
    required this.ipV4,
    required this.ipV6,
  });

  List<DetalIp> ipV4;
  List<DetalIp> ipV6;
}

class DetalIp {
  DetalIp({
    required this.address,
    required this.interfaceName,
  });

  InternetAddress address;
  String interfaceName;
}
