import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';

void main() => runApp(const Web3Example());

class Web3Example extends StatefulWidget {
  const Web3Example({Key? key}) : super(key: key);

  @override
  State<Web3Example> createState() => _Web3ExampleState();
}

class _Web3ExampleState extends State<Web3Example> {
  SessionStatus? _session;

  WalletConnect connector = WalletConnect(
    bridge: 'https://bridge.walletconnect.org',
    clientMeta: const PeerMeta(
      name: 'APP_NAME',
      description: 'Description',
      url: 'website_url',
      icons: ['icon_url'],
    ),
  );
  void connectMetaMask() async {
    _session = await connector.createSession(
      onDisplayUri: (final uri) async {
        await launchUrlString(
          'metamask://wc?uri=$uri',
          mode: LaunchMode.externalApplication,
        );
      },
    );
    setState(() {});
  }

  void connectTrustWallet() async {
    _session = await connector.createSession(
      onDisplayUri: (final uri) async {
        final String encodeUri = Uri.encodeComponent(uri);
        await launchUrlString(
          'trust://wc?uri=$encodeUri',
          mode: LaunchMode.externalApplication,
        );
      },
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Web3 Connect',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Web3 Connect'),
        ),
        body: Center(
          child: !connector.session.connected
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: connectMetaMask,
                      child: const Text('MetaMask Connect'),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    TextButton(
                      onPressed: connectTrustWallet,
                      child: const Text('Trust Wallet Connect'),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_session!.accounts[0]),
                    const SizedBox(
                      height: 50,
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          connector.killSession();
                        });
                      },
                      child: const Text('Kill Session'),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
