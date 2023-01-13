import 'dart:developer';
import 'dart:io';

import '../models/data_ip.dart';

class NetworkService {
  static Future<DataIp> getMyIp() async {
    DataIp dataIp = DataIp(ipV4: [], ipV6: []);

    // ipv4
    var resultIPv4 = await NetworkInterface.list(
      includeLoopback: true,
      type: InternetAddressType.IPv4,
    );

    for (var interface in resultIPv4) {
      for (var addr in interface.addresses) {
        dataIp.ipV4.add(
          DetalIp(
            address: addr,
            interfaceName: interface.name,
          ),
        );
        log('${interface.name} ${addr.address} ${addr.host} ${addr.isLoopback} ${addr.rawAddress} ${addr.type}',
            name: "ipv4");
      }
    }
    // end ipv4

    // ipv6
    var resultIPv6 = await NetworkInterface.list(
      includeLoopback: true,
      type: InternetAddressType.IPv6,
    );

    for (var interface in resultIPv6) {
      for (var addr in interface.addresses) {
        dataIp.ipV6.add(
          DetalIp(
            address: addr,
            interfaceName: interface.name,
          ),
        );
        log('${interface.name} ${addr.address} ${addr.host} ${addr.isLoopback} ${addr.rawAddress} ${addr.type}',
            name: "ipv6");
      }
    }
    // end ipv6

    return dataIp;
  }

  // get ip from domain
  static Future<DataIp> getDomainIp({required String domain}) async {
    DataIp dataIp = DataIp(ipV4: [], ipV6: []);

    try {
      final result = await InternetAddress.lookup(domain);

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        for (var item in result) {
          dataIp.ipV4.add(
            DetalIp(
              address: item,
              interfaceName: 'domain',
            ),
          );
        }
      } else {
        dataIp = DataIp(ipV4: [], ipV6: []);
      }
    } on SocketException catch (_) {
      dataIp = DataIp(ipV4: [], ipV6: []);
    }

    return dataIp;
  }
}
