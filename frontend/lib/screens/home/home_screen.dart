import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/api_service.dart';
import '../../services/notification_service.dart';
import '../../models/qr_code.dart';
import 'create_qr_dialog.dart';
import 'qr_code_details_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize notification service
    context.read<NotificationService>().initialize();
  }

  Future<void> _createQRCode() async {
    final qrCode = await showDialog<QRCode>(
      context: context,
      builder: (context) => const CreateQRDialog(),
    );

    if (qrCode != null && mounted) {
      setState(() {}); // Refresh the QR codes list
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('QR code created successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('QR Doorbell'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await context.read<ApiService>().logout();
                if (mounted) {
                  Navigator.of(context).pushReplacementNamed('/login');
                }
              },
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'My QR Codes'),
              Tab(text: 'Call History'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            QRCodesTab(),
            CallHistoryTab(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _createQRCode,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class QRCodesTab extends StatefulWidget {
  const QRCodesTab({super.key});

  @override
  State<QRCodesTab> createState() => _QRCodesTabState();
}

class _QRCodesTabState extends State<QRCodesTab> {
  late Future<List<QRCode>> _qrCodesFuture;

  @override
  void initState() {
    super.initState();
    _loadQRCodes();
  }

  void _loadQRCodes() {
    _qrCodesFuture = context.read<ApiService>().getQRCodes();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          _loadQRCodes();
        });
      },
      child: FutureBuilder<List<QRCode>>(
        future: _qrCodesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${snapshot.error}',
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _loadQRCodes();
                      });
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final qrCodes = snapshot.data!;
          if (qrCodes.isEmpty) {
            return const Center(
              child: Text('No QR codes yet. Create one by tapping the + button!'),
            );
          }

          return ListView.builder(
            itemCount: qrCodes.length,
            itemBuilder: (context, index) {
              final qrCode = qrCodes[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(qrCode.name),
                  subtitle: Text(qrCode.description ?? ''),
                  trailing: Text(
                    qrCode.expiryDate != null
                        ? 'Expires: ${qrCode.expiryDate?.day}/${qrCode.expiryDate?.month}/${qrCode.expiryDate?.year}'
                        : 'No expiry date',
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => QRCodeDetailsDialog(qrCode: qrCode),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class CallHistoryTab extends StatelessWidget {
  const CallHistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Implement call history list
    return const Center(
      child: Text('Call History Tab'),
    );
  }
}
