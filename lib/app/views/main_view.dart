// ignore_for_file: use_build_context_synchronously

import 'package:cek_ip/app/core/models/data_ip.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/services/network_service.dart';

class MainVIew extends StatefulWidget {
  const MainVIew({super.key});

  @override
  State<MainVIew> createState() => _MainVIewState();
}

class _MainVIewState extends State<MainVIew> {
  DataIp dataIp = DataIp(ipV4: [], ipV6: []);

  DataIp dataIpPing = DataIp(ipV4: [], ipV6: []);

  bool isLoad = false;

  funcGetIp() async {
    setState(() {
      isLoad = true;
    });
    dataIp = await NetworkService.getMyIp();
    setState(() {
      isLoad = false;
    });
  }

  funcCopyTextInClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    // vibration feedback
    HapticFeedback.vibrate();

    ScaffoldMessenger.of(context).removeCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied to Clipboard'),
        backgroundColor: Colors.green,
      ),
    );
  }

  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    funcGetIp();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Whats My Ip'),
          centerTitle: true,
        ),
        body: isLoad
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // keyboard search
                      TextField(
                        controller: controller,
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.search,
                        onSubmitted: (value) async {
                          final result = await NetworkService.getDomainIp(
                            domain: controller.text,
                          );
                          dataIpPing = result;

                          setState(() {});
                        },
                        decoration: InputDecoration(
                          labelText: 'Get Domain IP',
                          hintText: 'google.com',
                          suffixIcon: IconButton(
                            onPressed: () async {
                              final result = await NetworkService.getDomainIp(
                                domain: controller.text,
                              );
                              dataIpPing = result;

                              setState(() {});
                            },
                            icon: const Icon(Icons.search),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: kToolbarHeight / 3,
                      ),
                      Card(
                        child: ListTile(
                          title: const Text('IPv4'),
                          subtitle: dataIpPing.ipV4.isEmpty
                              ? const Text('No Data')
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: kToolbarHeight / 4,
                                    ),
                                    for (var item in dataIpPing.ipV4)
                                      InkWell(
                                        borderRadius: BorderRadius.circular(10),
                                        onTap: () {
                                          funcCopyTextInClipboard(
                                              item.address.address);
                                        },
                                        child: SizedBox(
                                          width: double.infinity,
                                          child: Padding(
                                            padding: const EdgeInsets.all(15),
                                            child: Row(
                                              children: [
                                                Text(
                                                  '${item.address.address} (${item.interfaceName})',
                                                ),
                                                const Spacer(),
                                                Icon(
                                                  iconByNetworkInterfaceName(
                                                    item.interfaceName,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    const SizedBox(
                                      height: kToolbarHeight / 3,
                                    )
                                  ],
                                ),
                        ),
                      ),
                      const SizedBox(
                        height: kToolbarHeight / 3,
                      ),
                      const Divider(),
                      const SizedBox(
                        height: kToolbarHeight / 3,
                      ),
                      Text(
                        'Your IP',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      const SizedBox(
                        height: kToolbarHeight / 4,
                      ),
                      Card(
                        child: ListTile(
                          title: const Text('IPv4'),
                          subtitle: dataIp.ipV4.isEmpty
                              ? const Text('No Data')
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: kToolbarHeight / 4,
                                    ),
                                    for (var item in dataIp.ipV4)
                                      InkWell(
                                        borderRadius: BorderRadius.circular(10),
                                        onTap: () async {
                                          funcCopyTextInClipboard(
                                              item.address.address);
                                          // NetworkService.getDomainIp(
                                          //   domain: 'google.com',
                                          // );
                                        },
                                        child: SizedBox(
                                          width: double.infinity,
                                          child: Padding(
                                            padding: const EdgeInsets.all(15),
                                            child: Row(
                                              children: [
                                                Text(
                                                  '${item.address.address} (${item.interfaceName})',
                                                ),
                                                const Spacer(),
                                                Icon(
                                                  iconByNetworkInterfaceName(
                                                    item.interfaceName,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    const SizedBox(
                                      height: kToolbarHeight / 3,
                                    )
                                  ],
                                ),
                        ),
                      ),
                      const SizedBox(
                        height: kToolbarHeight / 3,
                      ),
                      Card(
                        child: ListTile(
                          title: const Text('IPv6'),
                          subtitle: dataIp.ipV4.isEmpty
                              ? const Text('No Data')
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: kToolbarHeight / 4,
                                    ),
                                    for (var item in dataIp.ipV6)
                                      InkWell(
                                        borderRadius: BorderRadius.circular(10),
                                        onTap: () {
                                          funcCopyTextInClipboard(
                                              item.address.address);
                                        },
                                        child: SizedBox(
                                          width: double.infinity,
                                          child: Padding(
                                            padding: const EdgeInsets.all(15),
                                            child: Row(
                                              children: [
                                                Text(
                                                  '${item.address.address} (${item.interfaceName})',
                                                ),
                                                const Spacer(),
                                                Icon(
                                                  iconByNetworkInterfaceName(
                                                    item.interfaceName,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    const SizedBox(
                                      height: kToolbarHeight / 3,
                                    )
                                  ],
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

IconData iconByNetworkInterfaceName(String interfaceName) {
  if (interfaceName.contains('wlan')) {
    return Icons.wifi;
  } else if (interfaceName.contains('eth') || interfaceName.contains('rmnet')) {
    return Icons.phone_android_rounded;
  } else if (interfaceName.contains('lo')) {
    return Icons.memory;
  } else if (interfaceName.contains('domain')) {
    return Icons.domain;
  } else {
    return Icons.device_unknown;
  }
}
