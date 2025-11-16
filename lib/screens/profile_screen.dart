import 'package:flutter/material.dart';

import '../services/notification_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notificationsEnabled = true;
  bool _maintenanceRemindersEnabled = true;
  bool _privacyMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile & Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 32,
                child: Text('SC'),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Smart Driver',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'demo@smartcar.app',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Card(
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: SwitchListTile(
              title: const Text('Dark mode'),
              subtitle: const Text('Toggle a simple light / dark theme'),
              value: widget.isDarkMode,
              onChanged: widget.onThemeChanged,
              secondary: const Icon(Icons.dark_mode_outlined),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Notifications'),
                  subtitle: const Text('Enable push notifications for expenses'),
                  value: _notificationsEnabled,
                  onChanged: (value) {
                    setState(() {
                      _notificationsEnabled = value;
                    });
                  },
                  secondary: const Icon(Icons.notifications_outlined),
                ),
                const Divider(height: 0),
                SwitchListTile(
                  title: const Text('Maintenance reminders'),
                  subtitle:
                      const Text('Remind me about oil, ITP and inspections'),
                  value: _maintenanceRemindersEnabled,
                  onChanged: (value) {
                    setState(() {
                      _maintenanceRemindersEnabled = value;
                    });
                  },
                  secondary: const Icon(Icons.build_circle_outlined),
                ),
                const Divider(height: 0),
                SwitchListTile(
                  title: const Text('Privacy mode'),
                  subtitle: const Text('Hide amounts on screenshots'),
                  value: _privacyMode,
                  onChanged: (value) {
                    setState(() {
                      _privacyMode = value;
                    });
                  },
                  secondary: const Icon(Icons.privacy_tip_outlined),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About this demo'),
              subtitle: const Text('Smart car expenses · Local data only'),
              trailing: Text(
                'v0.1',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _simulateNotifications,
            icon: const Icon(Icons.notifications_active_outlined),
            label: const Text('Simulate notifications'),
          ),
        ],
      ),
    );
  }

  void _simulateNotifications() {
    NotificationService.showDemoNotifications(context);
  }
}

